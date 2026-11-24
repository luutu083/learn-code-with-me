import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";

const testCaseSchema = z.object({
  name: z.string().trim().min(1).max(120),
  input_data: z.string().default(""),
  expected_output: z.string(),
  is_hidden: z.boolean().default(false),
});

const quizOptionSchema = z.object({
  option_label: z.enum(["A", "B", "C", "D"]),
  option_text: z.string().trim().min(1),
  is_correct: z.boolean(),
});

const quizQuestionSchema = z.object({
  question_text: z.string().trim().min(5),
  explanation: z.string().trim().min(5),
  common_misconception: z.string().default(""),
  options: z
    .array(quizOptionSchema)
    .length(4, "Mỗi câu hỏi phải có đúng 4 đáp án A, B, C, D")
    .refine((opts) => opts.filter((o) => o.is_correct).length === 1, {
      message: "Mỗi câu hỏi chỉ được có đúng 1 đáp án đúng",
    }),
});

const createExerciseSchema = z.object({
  lesson_id: z.string().uuid(),
  title: z.string().trim().min(2).max(200),
  type: z.enum(["coding", "quiz"]),
  instructions: z.string().trim().min(5),
  language: z.enum(["c", "python"]),
  starter_code: z.string().default(""),
  solution_code: z.string().default(""),
  sample_input: z.string().default(""),
  sample_output: z.string().default(""),
  pass_threshold: z.number().int().min(0).max(100).default(100),
  test_cases: z.array(testCaseSchema).optional(),
  quiz_questions: z.array(quizQuestionSchema).optional(),
});

export async function POST(request: NextRequest) {
  const auth = await getApiAuth();
  if (!auth) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  if (auth.profile.role !== "ADMIN") return NextResponse.json({ error: "Forbidden" }, { status: 403 });

  const body = await request.json().catch(() => null);
  const parsed = createExerciseSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Dữ liệu bài tập không hợp lệ", details: parsed.error.flatten() },
      { status: 400 }
    );
  }

  const data = parsed.data;
  if (data.type === "coding" && (!data.test_cases || data.test_cases.length === 0)) {
    return NextResponse.json({ error: "Coding exercise cần ít nhất 1 test case." }, { status: 400 });
  }
  if (data.type === "quiz" && (!data.quiz_questions || data.quiz_questions.length !== 5)) {
    return NextResponse.json({ error: "Theory Quiz bắt buộc phải có chính xác 5 câu hỏi." }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();
  const { data: exercise, error: exErr } = await adminDb
    .from("exercises")
    .insert({
      lesson_id: data.lesson_id,
      title: data.title,
      type: data.type,
      instructions: data.instructions,
      language: data.language,
      starter_code: data.starter_code,
      solution_code: data.solution_code,
      sample_input: data.sample_input,
      sample_output: data.sample_output,
      pass_threshold: data.pass_threshold,
    })
    .select("*")
    .single();

  if (exErr || !exercise) {
    return NextResponse.json({ error: exErr?.message || "Không thể tạo bài tập" }, { status: 500 });
  }

  if (data.type === "coding" && data.test_cases) {
    await adminDb.from("coding_test_cases").insert(
      data.test_cases.map((tc, idx) => ({
        exercise_id: exercise.id,
        name: tc.name,
        input_data: tc.input_data,
        expected_output: tc.expected_output,
        is_hidden: tc.is_hidden,
        sort_order: idx + 1,
      }))
    );
  }

  if (data.type === "quiz" && data.quiz_questions) {
    for (let i = 0; i < data.quiz_questions.length; i++) {
      const q = data.quiz_questions[i];
      const { data: createdQ } = await adminDb
        .from("quiz_questions")
        .insert({
          exercise_id: exercise.id,
          question_text: q.question_text,
          explanation: q.explanation,
          common_misconception: q.common_misconception,
          sort_order: i + 1,
        })
        .select("id")
        .single();

      if (createdQ) {
        await adminDb.from("quiz_options").insert(
          q.options.map((opt) => ({
            question_id: createdQ.id,
            option_label: opt.option_label,
            option_text: opt.option_text,
            is_correct: opt.is_correct,
          }))
        );
      }
    }
  }

  return NextResponse.json({ exercise }, { status: 201 });
}
