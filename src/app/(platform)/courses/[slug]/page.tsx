import Link from "next/link";
import { notFound } from "next/navigation";
import { CheckCircle2, Lock, PlayCircle, ShieldCheck } from "lucide-react";
import { requireAuth } from "@/lib/supabase/auth";
import { createServerSupabaseClient } from "@/lib/supabase/server";
import { Badge } from "@/components/ui/badge";
import { Progress } from "@/components/ui/progress";

export default async function CoursePage({
  params,
}: {
  params: { slug: string };
}) {
  const { user, profile } = await requireAuth();
  const { slug } = params;
  const supabase = await createServerSupabaseClient();

  const { data: course } = await supabase
    .from("courses")
    .select("*")
    .eq("slug", slug)
    .single();

  if (!course) notFound();

  const [{ data: chapters }, { data: lessons }, { data: progressRows }, { data: skipSetting }] =
    await Promise.all([
      supabase
        .from("chapters")
        .select("*")
        .eq("course_id", course.id)
        .eq("is_published", true)
        .order("sort_order"),
      supabase
        .from("lessons")
        .select("id, chapter_id, slug, title, summary, estimated_minutes, sort_order, verification_status")
        .eq("course_id", course.id)
        .eq("is_published", true)
        .order("sort_order"),
      supabase
        .from("lesson_progress")
        .select("lesson_id, lesson_completed, exercise_completed, best_coding_score, best_quiz_score")
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
  const orderedChapters = chapters ?? [];
  const orderedLessons = lessons ?? [];

  // Build global sequential lesson order across chapters to enforce mandatory exercise completion
  const flatLessons: typeof orderedLessons = [];
  for (const ch of orderedChapters) {
    const chLessons = orderedLessons
      .filter((l) => l.chapter_id === ch.id)
      .sort((a, b) => a.sort_order - b.sort_order);
    flatLessons.push(...chLessons);
  }

  const unlockedSet = new Set<string>();
  for (let i = 0; i < flatLessons.length; i++) {
    if (allowSkip || i === 0) {
      unlockedSet.add(flatLessons[i].id);
    } else {
      const prev = flatLessons[i - 1];
      const prevProgress = progressMap.get(prev.id);
      if (prevProgress?.exercise_completed) {
        unlockedSet.add(flatLessons[i].id);
      }
    }
  }

  const completedCount = flatLessons.filter((l) => progressMap.get(l.id)?.exercise_completed).length;
  const pct = flatLessons.length > 0 ? Math.round((completedCount / flatLessons.length) * 100) : 0;

  return (
    <div className="mx-auto max-w-5xl space-y-6">
      <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
        <div className="flex flex-wrap items-center gap-2">
          <Badge variant={course.language === "c" ? "default" : "violet"}>
            {course.language === "c" ? "C Programming" : "Python 3"}
          </Badge>
          <span className="text-xs text-slate-500">
            {orderedChapters.length} chương · {flatLessons.length} bài học
          </span>
        </div>
        <h1 className="mt-3 text-2xl font-bold text-slate-900">{course.title}</h1>
        <p className="mt-2 text-sm text-slate-600">{course.description}</p>
        <div className="mt-4 max-w-md space-y-1.5">
          <div className="flex justify-between text-xs font-medium text-slate-600">
            <span>Tiến độ khóa học</span>
            <span>
              {completedCount}/{flatLessons.length} bài ({pct}%)
            </span>
          </div>
          <Progress value={pct} />
        </div>
      </div>

      <div className="space-y-4">
        {orderedChapters.map((chapter, chIdx) => {
          const chLessons = orderedLessons
            .filter((l) => l.chapter_id === chapter.id)
            .sort((a, b) => a.sort_order - b.sort_order);

          return (
            <div key={chapter.id} className="rounded-xl border border-slate-200 bg-white shadow-sm">
              <div className="border-b border-slate-100 px-5 py-4">
                <p className="text-xs font-semibold uppercase tracking-wide text-indigo-600">
                  Chương {chIdx + 1}
                </p>
                <h2 className="mt-0.5 text-base font-bold text-slate-900">{chapter.title}</h2>
                {chapter.description && (
                  <p className="mt-1 text-xs text-slate-500">{chapter.description}</p>
                )}
              </div>

              <div className="divide-y divide-slate-100">
                {chLessons.map((lesson) => {
                  const prog = progressMap.get(lesson.id);
                  const isCompleted = Boolean(prog?.exercise_completed);
                  const isUnlocked = unlockedSet.has(lesson.id);

                  return (
                    <div
                      key={lesson.id}
                      className="flex flex-wrap items-center justify-between gap-3 px-5 py-3.5"
                    >
                      <div className="flex items-start gap-3">
                        {isCompleted ? (
                          <CheckCircle2 className="mt-0.5 h-5 w-5 shrink-0 text-emerald-600" />
                        ) : isUnlocked ? (
                          <PlayCircle className="mt-0.5 h-5 w-5 shrink-0 text-indigo-600" />
                        ) : (
                          <Lock className="mt-0.5 h-5 w-5 shrink-0 text-slate-400" />
                        )}
                        <div>
                          <div className="flex flex-wrap items-center gap-2">
                            <span className="text-sm font-semibold text-slate-900">
                              {lesson.title}
                            </span>
                            {lesson.verification_status === "verified" && (
                              <span className="inline-flex items-center gap-1 rounded-full bg-emerald-50 px-2 py-0.5 text-[10px] font-semibold text-emerald-700">
                                <ShieldCheck className="h-3 w-3" /> Verified
                              </span>
                            )}
                          </div>
                          <p className="mt-0.5 text-xs text-slate-500">
                            {lesson.summary} · ~{lesson.estimated_minutes} phút
                          </p>
                        </div>
                      </div>

                      {isUnlocked ? (
                        <Link
                          href={`/learn/${course.slug}/${lesson.slug}`}
                          className="rounded-lg bg-indigo-50 px-3.5 py-1.5 text-xs font-semibold text-indigo-700 hover:bg-indigo-100"
                        >
                          {isCompleted ? "Ôn lại bài" : "Học ngay →"}
                        </Link>
                      ) : (
                        <span className="rounded-lg bg-slate-100 px-3 py-1.5 text-xs font-medium text-slate-500">
                          Hoàn thành bài trước để mở
                        </span>
                      )}
                    </div>
                  );
                })}
              </div>
            </div>
          );
        })}
      </div>
    </div>
  );
}
