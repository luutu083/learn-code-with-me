import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { checkRateLimit } from "@/lib/rate-limit";
import { askAiTeacher, buildLearnerLevelSummary } from "@/lib/ai/gemini";

const chatSchema = z.object({
  lessonId: z.string().uuid(),
  question: z.string().trim().min(2, "Câu hỏi quá ngắn").max(1500),
  userCode: z.string().max(10000).optional(),
});

export async function POST(request: NextRequest) {
  const auth = await getApiAuth();
  if (!auth) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const rate = checkRateLimit(`ai:${auth.user.id}`, 12, 60_000);
  if (!rate.allowed) {
    return NextResponse.json(
      { error: `Bạn hỏi AI quá nhanh. Vui lòng đợi ${rate.retryAfterSeconds}s.` },
      { status: 429 }
    );
  }

  const body = await request.json().catch(() => null);
  const parsed = chatSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Câu hỏi không hợp lệ." }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();

  const { data: lesson, error: lessonErr } = await adminDb
    .from("lessons")
    .select(
      "id, course_id, title, language, language_version, difficulty, content_markdown, code_example, common_mistakes, lesson_sources(source_name, source_url, version, verification_status)"
    )
    .eq("id", parsed.data.lessonId)
    .single();

  if (lessonErr || !lesson) {
    return NextResponse.json({ error: "Không tìm thấy bài học." }, { status: 404 });
  }

  // Fetch user learning history to adapt explanation difficulty & surface recurring mistakes
  const [{ data: progressRows }, { data: recentSubmissions }] = await Promise.all([
    adminDb
      .from("lesson_progress")
      .select("lesson_completed, best_quiz_score, best_coding_score")
      .eq("user_id", auth.user.id)
      .eq("course_id", lesson.course_id),
    adminDb
      .from("exercise_submissions")
      .select("error_type, error_message")
      .eq("user_id", auth.user.id)
      .eq("language", lesson.language)
      .eq("passed", false)
      .order("created_at", { ascending: false })
      .limit(5),
  ]);

  const completedLessons = (progressRows ?? []).filter((p) => p.lesson_completed).length;
  const quizScores = (progressRows ?? []).map((p) => p.best_quiz_score).filter((s) => s > 0);
  const codingScores = (progressRows ?? []).map((p) => p.best_coding_score).filter((s) => s > 0);
  const avgQuizScore = quizScores.length
    ? Math.round(quizScores.reduce((a, b) => a + b, 0) / quizScores.length)
    : 0;
  const avgCodingScore = codingScores.length
    ? Math.round(codingScores.reduce((a, b) => a + b, 0) / codingScores.length)
    : 0;

  const recentErrors = (recentSubmissions ?? [])
    .map((s) => (s.error_type ? `${s.error_type}: ${(s.error_message || "").slice(0, 100)}` : null))
    .filter((v): v is string => Boolean(v));

  const reply = await askAiTeacher({
    lesson,
    sources: lesson.lesson_sources ?? [],
    userLevelSummary: buildLearnerLevelSummary({
      completedLessons,
      avgQuizScore,
      avgCodingScore,
      language: lesson.language,
    }),
    recentErrors,
    userCode: parsed.data.userCode,
    question: parsed.data.question,
  });

  await adminDb.from("user_activities").insert({
    user_id: auth.user.id,
    course_id: lesson.course_id,
    lesson_id: lesson.id,
    activity_type: "ai_question",
    metadata: {
      configured: reply.configured,
      containsUnverifiedNotice: reply.containsUnverifiedNotice,
    },
  });

  return NextResponse.json(reply);
}
