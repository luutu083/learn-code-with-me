import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { checkRateLimit } from "@/lib/rate-limit";
import { runCodingExerciseTests, validateSubmittedCode } from "@/lib/execution/runner";
import type { QuizEvaluationResponse, QuizQuestionFeedback } from "@/types/database";

const codingSubmitSchema = z.object({
  type: z.literal("coding"),
  code: z.string().min(1),
});

const quizSubmitSchema = z.object({
  type: z.literal("quiz"),
  answers: z.record(z.string(), z.string()),
});

const requestSchema = z.discriminatedUnion("type", [codingSubmitSchema, quizSubmitSchema]);

/**
 * POST /api/exercises/[id]/submit
 * Official server-side grading: executes all official test cases (including hidden),
 * persists submission/quiz attempt, increments attempt counter, and unlocks next lesson
 * ONLY when official pass threshold is met.
 */
export async function POST(
  request: NextRequest,
  { params }: { params: { id: string } }
) {
  const auth = await getApiAuth();
  if (!auth) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const rate = checkRateLimit(`submit:${auth.user.id}`, 10, 60_000);
  if (!rate.allowed) {
    return NextResponse.json(
      { error: `Vui lòng chờ ${rate.retryAfterSeconds}s trước khi nộp bài tiếp.` },
      { status: 429 }
    );
  }

  const { id: exerciseId } = params;
  const body = await request.json().catch(() => null);
  const parsed = requestSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu nộp bài không hợp lệ." }, { status: 400 });
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

  const courseId: string = exercise.lessons.course_id;
  const lessonId: string = exercise.lesson_id;

  // Fetch existing progress to update atomically
  const { data: existingProgress } = await adminDb
    .from("lesson_progress")
    .select("*")
    .eq("user_id", auth.user.id)
    .eq("lesson_id", lessonId)
    .maybeSingle();

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
      return NextResponse.json({ error: "Bài tập chưa có test case chính thức." }, { status: 422 });
    }

    const evalResult = await runCodingExerciseTests({
      mode: "submit",
      language: exercise.language,
      sourceCode: parsed.data.code,
      testCases,
      passThreshold: exercise.pass_threshold,
      timeLimitMs: exercise.time_limit_ms,
      memoryLimitKb: exercise.memory_limit_kb,
    });

    // If Judge0 is not configured, do NOT mark exercise as passed or fake a submission!
    if (!evalResult.configured) {
      return NextResponse.json(evalResult, { status: 503 });
    }

    const { count: prevAttempts } = await adminDb
      .from("exercise_submissions")
      .select("id", { count: "exact", head: true })
      .eq("user_id", auth.user.id)
      .eq("exercise_id", exerciseId);

    const attemptNumber = (prevAttempts ?? 0) + 1;
    const totalExecMs = evalResult.results.reduce((acc, r) => acc + (r.executionTimeMs ?? 0), 0);

    const { data: submission } = await adminDb
      .from("exercise_submissions")
      .insert({
        user_id: auth.user.id,
        course_id: courseId,
        lesson_id: lessonId,
        exercise_id: exerciseId,
        language: exercise.language,
        submitted_code: parsed.data.code,
        score: evalResult.score,
        passed: evalResult.passed,
        passed_tests: evalResult.passedTests,
        total_tests: evalResult.totalTests,
        attempt_number: attemptNumber,
        execution_time_ms: totalExecMs,
        error_type: evalResult.diagnostic?.errorType ?? null,
        error_message: evalResult.diagnostic?.errorMessage ?? null,
        test_results_json: evalResult.results,
      })
      .select("id")
      .single();

    const nowIso = new Date().toISOString();
    const nextCompleted = Boolean(existingProgress?.exercise_completed || evalResult.passed);
    const bestCodingScore = Math.max(existingProgress?.best_coding_score ?? 0, evalResult.score);

    await adminDb.from("lesson_progress").upsert(
      {
        user_id: auth.user.id,
        course_id: courseId,
        lesson_id: lessonId,
        lesson_completed: nextCompleted,
        exercise_completed: nextCompleted,
        best_coding_score: bestCodingScore,
        best_quiz_score: existingProgress?.best_quiz_score ?? 0,
        attempts_count: (existingProgress?.attempts_count ?? 0) + 1,
        time_spent_seconds: existingProgress?.time_spent_seconds ?? 0,
        last_accessed_at: nowIso,
        completed_at: nextCompleted ? existingProgress?.completed_at ?? nowIso : null,
      },
      { onConflict: "user_id,lesson_id" }
    );

    await adminDb.from("user_activities").insert({
      user_id: auth.user.id,
      course_id: courseId,
      lesson_id: lessonId,
      exercise_id: exerciseId,
      activity_type: "code_submitted",
      metadata: {
        score: evalResult.score,
        passed: evalResult.passed,
        attemptNumber,
      },
    });

    return NextResponse.json({
      ...evalResult,
      submissionId: submission?.id,
      attemptNumber,
      lessonUnlocked: nextCompleted,
    });
  }

  // Official Quiz Submit (strictly 5 questions)
  const { data: questions } = await adminDb
    .from("quiz_questions")
    .select("id, explanation, common_misconception, sort_order, quiz_options(id, option_label, is_correct)")
    .eq("exercise_id", exerciseId)
    .order("sort_order", { ascending: true });

  if (!questions || questions.length !== 5) {
    return NextResponse.json({ error: "Quiz phải có chính xác 5 câu hỏi." }, { status: 422 });
  }

  const submittedAnswers = parsed.data.answers;
  let correctCount = 0;
  const feedback: QuizQuestionFeedback[] = questions.map((q) => {
    const selectedOptionId = submittedAnswers[q.id] ?? null;
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

  const { count: prevAttempts } = await adminDb
    .from("quiz_attempts")
    .select("id", { count: "exact", head: true })
    .eq("user_id", auth.user.id)
    .eq("exercise_id", exerciseId);

  const attemptNumber = (prevAttempts ?? 0) + 1;

  const { data: attempt } = await adminDb
    .from("quiz_attempts")
    .insert({
      user_id: auth.user.id,
      course_id: courseId,
      lesson_id: lessonId,
      exercise_id: exerciseId,
      answers_json: parsed.data.answers,
      score,
      correct_count: correctCount,
      total_questions: 5,
      passed,
      attempt_number: attemptNumber,
    })
    .select("id")
    .single();

  const nowIso = new Date().toISOString();
  const nextCompleted = Boolean(existingProgress?.exercise_completed || passed);
  const bestQuizScore = Math.max(existingProgress?.best_quiz_score ?? 0, score);

  await adminDb.from("lesson_progress").upsert(
    {
      user_id: auth.user.id,
      course_id: courseId,
      lesson_id: lessonId,
      lesson_completed: nextCompleted,
      exercise_completed: nextCompleted,
      best_coding_score: existingProgress?.best_coding_score ?? 0,
      best_quiz_score: bestQuizScore,
      attempts_count: (existingProgress?.attempts_count ?? 0) + 1,
      time_spent_seconds: existingProgress?.time_spent_seconds ?? 0,
      last_accessed_at: nowIso,
      completed_at: nextCompleted ? existingProgress?.completed_at ?? nowIso : null,
    },
    { onConflict: "user_id,lesson_id" }
  );

  await adminDb.from("user_activities").insert({
    user_id: auth.user.id,
    course_id: courseId,
    lesson_id: lessonId,
    exercise_id: exerciseId,
    activity_type: "quiz_submitted",
    metadata: { score, correctCount, passed, attemptNumber },
  });

  const response: QuizEvaluationResponse = {
    mode: "submit",
    score,
    correctCount,
    totalQuestions: 5,
    passed,
    feedback,
    attemptId: attempt?.id,
    attemptNumber,
    lessonUnlocked: nextCompleted,
  };

  return NextResponse.json(response);
}
