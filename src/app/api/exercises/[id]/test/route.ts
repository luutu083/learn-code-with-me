import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { checkRateLimit } from "@/lib/rate-limit";
import { runCodingExerciseTests, validateSubmittedCode } from "@/lib/execution/runner";
import type { QuizEvaluationResponse, QuizQuestionFeedback } from "@/types/database";

const codingTestSchema = z.object({
  type: z.literal("coding"),
  code: z.string().min(1),
});

const quizTestSchema = z.object({
  type: z.literal("quiz"),
  answers: z.record(z.string(), z.string()), // questionId -> optionId
});

const requestSchema = z.discriminatedUnion("type", [codingTestSchema, quizTestSchema]);

/**
 * POST /api/exercises/[id]/test
 * Runs real sandboxed test cases (via Judge0) for coding exercises,
 * or grades a 5-question quiz in test mode without recording official submission.
 */
export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const auth = await getApiAuth();
  if (!auth) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const rate = checkRateLimit(`test:${auth.user.id}`, 15, 60_000);
  if (!rate.allowed) {
    return NextResponse.json(
      { error: `Bạn thao tác quá nhanh. Vui lòng thử lại sau ${rate.retryAfterSeconds}s.` },
      { status: 429 }
    );
  }

  const { id: exerciseId } = params;
  const body = await request.json().catch(() => null);
  const parsed = requestSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu gửi lên không hợp lệ." }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();
  const { data: exercise, error: exError } = await adminDb
    .from("exercises")
    .select("*, lessons!inner(id, course_id)")
    .eq("id", exerciseId)
    .single();

  if (exError || !exercise) {
    return NextResponse.json({ error: "Không tìm thấy bài tập." }, { status: 404 });
  }

  if (parsed.data.type !== exercise.type) {
    return NextResponse.json({ error: "Loại bài tập không khớp." }, { status: 400 });
  }

  if (parsed.data.type === "coding") {
    const validationErr = validateSubmittedCode(exercise.language, parsed.data.code);
    if (validationErr) {
      return NextResponse.json({ error: validationErr }, { status: 400 });
    }

    const { data: testCases } = await adminDb
      .from("coding_test_cases")
      .select("id, name, input_data, expected_output, is_hidden, sort_order")
      .eq("exercise_id", exerciseId)
      .order("sort_order", { ascending: true });

    if (!testCases || testCases.length === 0) {
      return NextResponse.json(
        { error: "Bài tập này chưa có test case nào được cấu hình." },
        { status: 422 }
      );
    }

    const evalResult = await runCodingExerciseTests({
      mode: "test",
      language: exercise.language,
      sourceCode: parsed.data.code,
      testCases,
      passThreshold: exercise.pass_threshold,
      timeLimitMs: exercise.time_limit_ms,
      memoryLimitKb: exercise.memory_limit_kb,
    });

    await adminDb.from("user_activities").insert({
      user_id: auth.user.id,
      course_id: exercise.lessons.course_id,
      lesson_id: exercise.lesson_id,
      exercise_id: exerciseId,
      activity_type: "code_tested",
      metadata: {
        score: evalResult.score,
        passedTests: evalResult.passedTests,
        totalTests: evalResult.totalTests,
        configured: evalResult.configured,
      },
    });

    return NextResponse.json(evalResult);
  }

  // Quiz Test Mode (exactly 5 questions)
  const { data: questions } = await adminDb
    .from("quiz_questions")
    .select("id, explanation, common_misconception, sort_order, quiz_options(id, option_label, is_correct)")
    .eq("exercise_id", exerciseId)
    .order("sort_order", { ascending: true });

  if (!questions || questions.length !== 5) {
    return NextResponse.json(
      { error: "Quiz phải có chính xác 5 câu hỏi." },
      { status: 422 }
    );
  }

  let correctCount = 0;
  const feedback: QuizQuestionFeedback[] = questions.map((q) => {
    const selectedOptionId = parsed.data.answers[q.id] ?? null;
    const options = (q.quiz_options as Array<{ id: string; option_label: "A" | "B" | "C" | "D"; is_correct: boolean }>) || [];
    const correctOption = options.find((o) => o.is_correct);
    const isCorrect = Boolean(correctOption && selectedOptionId === correctOption.id);
    if (isCorrect) correctCount += 1;

    return {
      questionId: q.id,
      selectedOptionId,
      isCorrect,
      correctOptionLabel: correctOption?.option_label ?? "A",
      explanation: q.explanation,
      commonMisconception: q.common_misconception,
    };
  });

  const score = Math.round((correctCount / 5) * 100);
  const passed = score >= exercise.pass_threshold;

  await adminDb.from("user_activities").insert({
    user_id: auth.user.id,
    course_id: exercise.lessons.course_id,
    lesson_id: exercise.lesson_id,
    exercise_id: exerciseId,
    activity_type: "quiz_tested",
    metadata: { score, correctCount, totalQuestions: 5 },
  });

  const response: QuizEvaluationResponse = {
    mode: "test",
    score,
    correctCount,
    totalQuestions: 5,
    passed,
    feedback,
  };

  return NextResponse.json(response);
}
