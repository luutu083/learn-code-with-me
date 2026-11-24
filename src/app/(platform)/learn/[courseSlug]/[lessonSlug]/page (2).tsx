import Link from "next/link";
import { notFound, redirect } from "next/navigation";
import {
  AlertCircle,
  ArrowRight,
  BookCheck,
  CheckCircle2,
  ExternalLink,
  Lock,
  ShieldCheck,
} from "lucide-react";
import { requireAuth } from "@/lib/supabase/auth";
import { createServerSupabaseClient } from "@/lib/supabase/server";
import { Badge } from "@/components/ui/badge";
import { LessonWorkspace } from "@/components/learning/lesson-workspace";
import type { PublicExercise, PublicQuizQuestion, PublicTestCase } from "@/types/database";

export default async function LearnLessonPage({
  params,
}: {
  params: { courseSlug: string; lessonSlug: string };
}) {
  const { user, profile } = await requireAuth();
  const { courseSlug, lessonSlug } = params;
  const supabase = await createServerSupabaseClient();

  const { data: course } = await supabase
    .from("courses")
    .select("*")
    .eq("slug", courseSlug)
    .single();

  if (!course) notFound();

  const [{ data: chapters }, { data: allLessons }, { data: progressRows }, { data: skipSetting }] =
    await Promise.all([
      supabase
        .from("chapters")
        .select("id, title, sort_order")
        .eq("course_id", course.id)
        .eq("is_published", true)
        .order("sort_order"),
      supabase
        .from("lessons")
        .select("*")
        .eq("course_id", course.id)
        .eq("is_published", true)
        .order("sort_order"),
      supabase
        .from("lesson_progress")
        .select("lesson_id, exercise_completed")
        .eq("user_id", user.id)
        .eq("course_id", course.id),
      supabase
        .from("platform_settings")
        .select("value")
        .eq("key", "allow_skip_exercises")
        .maybeSingle(),
    ]);

  const allowSkip = Boolean(
    profile.role === "ADMIN" || skipSetting?.value === true || skipSetting?.value === "true"
  );

  const progressMap = new Map((progressRows ?? []).map((p) => [p.lesson_id, p]));
  const flatLessons: NonNullable<typeof allLessons> = [];
  for (const ch of chapters ?? []) {
    const chLessons = (allLessons ?? [])
      .filter((l) => l.chapter_id === ch.id)
      .sort((a, b) => a.sort_order - b.sort_order);
    flatLessons.push(...chLessons);
  }

  const currentIdx = flatLessons.findIndex((l) => l.slug === lessonSlug);
  if (currentIdx === -1) notFound();

  // Server-side guard: block jumping ahead if previous lesson's exercise is not completed
  if (!allowSkip && currentIdx > 0) {
    const prevLesson = flatLessons[currentIdx - 1];
    if (!progressMap.get(prevLesson.id)?.exercise_completed) {
      redirect(`/courses/${course.slug}`);
    }
  }

  const lesson = flatLessons[currentIdx];
  const nextLesson = flatLessons[currentIdx + 1] ?? null;
  const isCurrentCompleted = Boolean(progressMap.get(lesson.id)?.exercise_completed);

  const [{ data: sources }, { data: exercises }] = await Promise.all([
    supabase.from("lesson_sources").select("*").eq("lesson_id", lesson.id),
    supabase
      .from("exercises")
      .select(
        "id, lesson_id, title, type, instructions, language, starter_code, sample_input, sample_output, pass_threshold, time_limit_ms, memory_limit_kb, is_required, sort_order"
      )
      .eq("lesson_id", lesson.id)
      .order("sort_order")
      .limit(1),
  ]);

  const exercise = (exercises?.[0] as PublicExercise | undefined) ?? null;
  let visibleTestCases: PublicTestCase[] = [];
  let quizQuestions: PublicQuizQuestion[] = [];

  if (exercise?.type === "coding") {
    const { data: tcs } = await supabase
      .from("coding_test_cases")
      .select("id, exercise_id, name, input_data, expected_output, is_hidden, sort_order")
      .eq("exercise_id", exercise.id)
      .eq("is_hidden", false)
      .order("sort_order");
    visibleTestCases = (tcs as PublicTestCase[]) ?? [];
  } else if (exercise?.type === "quiz") {
    const { data: qs } = await supabase
      .from("quiz_questions")
      .select("id, exercise_id, question_text, sort_order, quiz_options(id, question_id, option_label, option_text)")
      .eq("exercise_id", exercise.id)
      .order("sort_order");

    quizQuestions = (qs ?? []).map((q) => ({
      id: q.id,
      exercise_id: q.exercise_id,
      question_text: q.question_text,
      sort_order: q.sort_order,
      options: ((q.quiz_options as PublicQuizQuestion["options"]) ?? []).sort((a, b) =>
        a.option_label.localeCompare(b.option_label)
      ),
    }));
  }

  const lessonContent = (
    <article className="space-y-6 rounded-xl border border-slate-200 bg-white p-6 shadow-sm">
      <div className="space-y-2 border-b border-slate-100 pb-4">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant={lesson.language === "c" ? "default" : "violet"}>
            {lesson.language.toUpperCase()} · {lesson.language_version}
          </Badge>
          <Badge variant={lesson.verification_status === "verified" ? "success" : "warning"}>
            <ShieldCheck className="mr-1 h-3.5 w-3.5" />
            {lesson.verification_status === "verified" ? "Kiến thức đã xác minh" : "Đang chờ kiểm chứng"}
          </Badge>
        </div>
        <h1 className="text-2xl font-bold text-slate-900">{lesson.title}</h1>
        <p className="text-sm text-slate-600">{lesson.summary}</p>
      </div>

      {/* Main Concept */}
      <div className="prose prose-slate max-w-none whitespace-pre-line text-sm leading-7 text-slate-800">
        {lesson.content_markdown}
      </div>

      {/* Code Example & Line-by-line explanation */}
      {lesson.code_example && (
        <div className="space-y-3 rounded-xl border border-slate-200 bg-slate-950 p-4 text-slate-100">
          <p className="text-xs font-semibold uppercase tracking-wider text-indigo-300">
            Ví dụ Code chuẩn ({lesson.language.toUpperCase()})
          </p>
          <pre className="overflow-x-auto font-mono text-xs leading-6">
            <code>{lesson.code_example}</code>
          </pre>
        </div>
      )}

      {lesson.code_explanation && (
        <div className="rounded-xl border border-indigo-100 bg-indigo-50/60 p-4">
          <h2 className="text-sm font-bold text-indigo-900">Giải thích từng dòng code</h2>
          <div className="mt-2 whitespace-pre-line text-sm leading-6 text-slate-700">
            {lesson.code_explanation}
          </div>
        </div>
      )}

      {/* Common Mistakes */}
      {lesson.common_mistakes && (
        <div className="rounded-xl border border-amber-200 bg-amber-50/70 p-4">
          <h2 className="flex items-center gap-1.5 text-sm font-bold text-amber-900">
            <AlertCircle className="h-4 w-4 text-amber-600" />
            Lỗi người mới thường mắc
          </h2>
          <div className="mt-2 whitespace-pre-line text-sm leading-6 text-amber-950">
            {lesson.common_mistakes}
          </div>
        </div>
      )}

      {/* Key Takeaways */}
      {lesson.key_takeaways && (
        <div className="rounded-xl border border-emerald-200 bg-emerald-50/70 p-4">
          <h2 className="flex items-center gap-1.5 text-sm font-bold text-emerald-900">
            <BookCheck className="h-4 w-4 text-emerald-600" />
            Tóm tắt kiến thức cuối bài
          </h2>
          <div className="mt-2 whitespace-pre-line text-sm leading-6 text-emerald-950">
            {lesson.key_takeaways}
          </div>
        </div>
      )}

      {/* Verified Sources Metadata */}
      <div className="rounded-xl border border-slate-200 bg-slate-50 p-4">
        <h2 className="text-xs font-bold uppercase tracking-wider text-slate-600">
          Nguồn tài liệu chính thống đã kiểm chứng
        </h2>
        {!sources || sources.length === 0 ? (
          <p className="mt-2 text-xs text-amber-700">
            Chưa đủ dữ liệu đáng tin cậy để xác minh nội dung này.
          </p>
        ) : (
          <ul className="mt-2 space-y-1.5 text-xs">
            {sources.map((src) => (
              <li key={src.id} className="flex flex-wrap items-center justify-between gap-2">
                <a
                  href={src.source_url}
                  target="_blank"
                  rel="noopener noreferrer"
                  className="inline-flex items-center gap-1 font-medium text-indigo-600 hover:underline"
                >
                  {src.source_name} ({src.version})
                  <ExternalLink className="h-3 w-3" />
                </a>
                <span className="text-slate-500">
                  Xác minh ngày: {src.last_verified_date} · {src.verification_status}
                </span>
              </li>
            ))}
          </ul>
        )}
      </div>

      {/* Next Lesson Navigation */}
      {nextLesson && (
        <div className="flex items-center justify-between border-t border-slate-100 pt-4">
          <span className="text-xs text-slate-500">
            {isCurrentCompleted || allowSkip
              ? "Bạn đã đủ điều kiện chuyển sang bài tiếp theo."
              : "Hoàn thành bài tập bên dưới để mở khóa bài học tiếp theo."}
          </span>
          {isCurrentCompleted || allowSkip ? (
            <Link
              href={`/learn/${course.slug}/${nextLesson.slug}`}
              className="inline-flex items-center gap-1.5 rounded-lg bg-emerald-600 px-4 py-2 text-xs font-semibold text-white hover:bg-emerald-700"
            >
              Bài tiếp theo: {nextLesson.title}
              <ArrowRight className="h-3.5 w-3.5" />
            </Link>
          ) : (
            <span className="inline-flex items-center gap-1.5 rounded-lg bg-slate-100 px-4 py-2 text-xs font-semibold text-slate-400">
              <Lock className="h-3.5 w-3.5" />
              Đang khóa bài tiếp theo
            </span>
          )}
        </div>
      )}
    </article>
  );

  return (
    <div className="grid gap-6 2xl:grid-cols-[240px_minmax(0,1fr)]">
      {/* Left Chapter/Lesson Navigator on wide screens */}
      <aside className="hidden rounded-xl border border-slate-200 bg-white p-3 shadow-sm 2xl:block 2xl:sticky 2xl:top-6 2xl:max-h-[calc(100vh-3rem)] 2xl:overflow-y-auto">
        <Link
          href={`/courses/${course.slug}`}
          className="mb-3 block text-xs font-bold uppercase tracking-wide text-indigo-600 hover:underline"
        >
          ← {course.title}
        </Link>
        <div className="space-y-3">
          {(chapters ?? []).map((ch, idx) => {
            const chLessons = flatLessons.filter((l) => l.chapter_id === ch.id);
            return (
              <div key={ch.id}>
                <p className="px-2 text-[11px] font-bold text-slate-500">
                  {idx + 1}. {ch.title}
                </p>
                <ul className="mt-1 space-y-0.5">
                  {chLessons.map((l) => {
                    const lIdx = flatLessons.findIndex((x) => x.id === l.id);
                    const done = Boolean(progressMap.get(l.id)?.exercise_completed);
                    const unlocked =
                      allowSkip ||
                      lIdx === 0 ||
                      Boolean(progressMap.get(flatLessons[lIdx - 1]?.id)?.exercise_completed);
                    const active = l.id === lesson.id;

                    return (
                      <li key={l.id}>
                        {unlocked ? (
                          <Link
                            href={`/learn/${course.slug}/${l.slug}`}
                            className={`flex items-center gap-2 rounded-md px-2 py-1.5 text-xs ${
                              active
                                ? "bg-indigo-50 font-semibold text-indigo-700"
                                : "text-slate-600 hover:bg-slate-50"
                            }`}
                          >
                            {done ? (
                              <CheckCircle2 className="h-3.5 w-3.5 shrink-0 text-emerald-600" />
                            ) : (
                              <span className="h-2 w-2 shrink-0 rounded-full bg-indigo-400" />
                            )}
                            <span className="truncate">{l.title}</span>
                          </Link>
                        ) : (
                          <span className="flex items-center gap-2 px-2 py-1.5 text-xs text-slate-400">
                            <Lock className="h-3 w-3 shrink-0" />
                            <span className="truncate">{l.title}</span>
                          </span>
                        )}
                      </li>
                    );
                  })}
                </ul>
              </div>
            );
          })}
        </div>
      </aside>

      <LessonWorkspace
        courseId={course.id}
        lessonId={lesson.id}
        lessonTitle={lesson.title}
        exercise={exercise}
        visibleTestCases={visibleTestCases}
        quizQuestions={quizQuestions}
        exerciseCompleted={isCurrentCompleted}
        lessonContentSlot={lessonContent}
      />
    </div>
  );
}
