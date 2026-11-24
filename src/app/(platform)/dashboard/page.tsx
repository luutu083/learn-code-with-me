import Link from "next/link";
import { ArrowRight, CheckCircle2, Flame, GraduationCap, Target, Trophy } from "lucide-react";
import { requireAuth } from "@/lib/supabase/auth";
import { createServerSupabaseClient } from "@/lib/supabase/server";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Progress } from "@/components/ui/progress";
import { Badge } from "@/components/ui/badge";
import { formatRelativeDate } from "@/lib/utils";

export default async function DashboardPage() {
  const { user, profile } = await requireAuth();
  const supabase = await createServerSupabaseClient();

  const [{ data: courses }, { data: lessons }, { data: progressRows }, { data: activities }] =
    await Promise.all([
      supabase.from("courses").select("*").eq("is_published", true).order("sort_order"),
      supabase.from("lessons").select("id, course_id, slug, title, sort_order").eq("is_published", true),
      supabase.from("lesson_progress").select("*").eq("user_id", user.id),
      supabase
        .from("user_activities")
        .select("id, activity_type, metadata, created_at, lessons(title)")
        .eq("user_id", user.id)
        .order("created_at", { ascending: false })
        .limit(8),
    ]);

  const allLessons = lessons ?? [];
  const progressList = progressRows ?? [];
  const completedLessonIds = new Set(
    progressList.filter((p) => p.lesson_completed).map((p) => p.lesson_id)
  );

  const totalLessons = allLessons.length;
  const completedLessons = completedLessonIds.size;
  const remainingLessons = Math.max(0, totalLessons - completedLessons);
  const overallProgress = totalLessons > 0 ? Math.round((completedLessons / totalLessons) * 100) : 0;

  const cCourse = (courses ?? []).find((c) => c.language === "c");
  const pyCourse = (courses ?? []).find((c) => c.language === "python");

  const cLessons = allLessons.filter((l) => l.course_id === cCourse?.id);
  const pyLessons = allLessons.filter((l) => l.course_id === pyCourse?.id);

  const cCompleted = cLessons.filter((l) => completedLessonIds.has(l.id)).length;
  const pyCompleted = pyLessons.filter((l) => completedLessonIds.has(l.id)).length;

  const cProgress = cLessons.length > 0 ? Math.round((cCompleted / cLessons.length) * 100) : 0;
  const pyProgress = pyLessons.length > 0 ? Math.round((pyCompleted / pyLessons.length) * 100) : 0;

  const quizScores = progressList.map((p) => p.best_quiz_score).filter((s) => s > 0);
  const codingScores = progressList.map((p) => p.best_coding_score).filter((s) => s > 0);
  const avgQuizScore = quizScores.length
    ? Math.round(quizScores.reduce((a, b) => a + b, 0) / quizScores.length)
    : 0;
  const codingAccuracy = codingScores.length
    ? Math.round(codingScores.reduce((a, b) => a + b, 0) / codingScores.length)
    : 0;

  // Find last accessed or first uncompleted lesson for "Continue Learning"
  const sortedProgress = [...progressList].sort(
    (a, b) => new Date(b.last_accessed_at).getTime() - new Date(a.last_accessed_at).getTime()
  );
  const lastAccessed = sortedProgress[0];
  const continueLesson =
    allLessons.find((l) => l.id === lastAccessed?.lesson_id) ||
    allLessons.find((l) => !completedLessonIds.has(l.id)) ||
    allLessons[0];

  const continueCourse = (courses ?? []).find((c) => c.id === continueLesson?.course_id);
  const continueHref =
    continueCourse && continueLesson
      ? `/learn/${continueCourse.slug}/${continueLesson.slug}`
      : "/courses/learn-c";

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">
            Xin chào, {profile.full_name || "Học viên"}
          </h1>
          <p className="text-sm text-slate-500">
            Tiếp tục hành trình chinh phục C và Python với bài giảng đã xác minh.
          </p>
        </div>
        <Link
          href={continueHref}
          className="inline-flex items-center gap-2 rounded-xl bg-indigo-600 px-5 py-2.5 text-sm font-semibold text-white shadow-sm hover:bg-indigo-700"
        >
          Continue Learning
          <ArrowRight className="h-4 w-4" />
        </Link>
      </div>

      {/* KPI Row */}
      <div className="grid gap-4 sm:grid-cols-2 xl:grid-cols-4">
        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-slate-500">Overall Progress</CardTitle>
            <GraduationCap className="h-4 w-4 text-indigo-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{overallProgress}%</div>
            <p className="mt-1 text-xs text-slate-500">
              {completedLessons} hoàn thành · {remainingLessons} bài còn lại
            </p>
            <Progress value={overallProgress} className="mt-3" />
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-slate-500">Average Quiz Score</CardTitle>
            <Trophy className="h-4 w-4 text-violet-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{avgQuizScore}%</div>
            <p className="mt-1 text-xs text-slate-500">
              Dựa trên {quizScores.length} bài quiz đã làm
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-slate-500">Coding Accuracy</CardTitle>
            <Target className="h-4 w-4 text-emerald-600" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{codingAccuracy}%</div>
            <p className="mt-1 text-xs text-slate-500">
              Dựa trên {codingScores.length} bài tập lập trình
            </p>
          </CardContent>
        </Card>

        <Card>
          <CardHeader className="flex flex-row items-center justify-between pb-2">
            <CardTitle className="text-sm font-medium text-slate-500">Learning Streak</CardTitle>
            <Flame className="h-4 w-4 text-amber-500" />
          </CardHeader>
          <CardContent>
            <div className="text-2xl font-bold">{profile.current_streak_days} ngày</div>
            <p className="mt-1 text-xs text-slate-500">
              Kỷ lục: {profile.longest_streak_days} ngày liên tiếp
            </p>
          </CardContent>
        </Card>
      </div>

      {/* Course Progress Cards */}
      <div className="grid gap-6 md:grid-cols-2">
        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <Badge variant="default">C Programming</Badge>
              <span className="text-sm font-bold text-indigo-600">{cProgress}%</span>
            </div>
            <CardTitle className="pt-2">Learn C Programming</CardTitle>
            <CardDescription>
              {cCompleted}/{cLessons.length} bài học đã hoàn thành
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <Progress value={cProgress} />
            <Link
              href="/courses/learn-c"
              className="inline-flex items-center gap-1.5 text-sm font-semibold text-indigo-600 hover:underline"
            >
              Mở khóa học C <ArrowRight className="h-4 w-4" />
            </Link>
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <div className="flex items-center justify-between">
              <Badge variant="violet">Python 3</Badge>
              <span className="text-sm font-bold text-violet-600">{pyProgress}%</span>
            </div>
            <CardTitle className="pt-2">Learn Python Programming</CardTitle>
            <CardDescription>
              {pyCompleted}/{pyLessons.length} bài học đã hoàn thành
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <Progress value={pyProgress} />
            <Link
              href="/courses/learn-python"
              className="inline-flex items-center gap-1.5 text-sm font-semibold text-violet-600 hover:underline"
            >
              Mở khóa học Python <ArrowRight className="h-4 w-4" />
            </Link>
          </CardContent>
        </Card>
      </div>

      {/* Recent Activities */}
      <Card>
        <CardHeader>
          <CardTitle>Hoạt động gần đây</CardTitle>
          <CardDescription>Lịch sử học tập và nộp bài được lưu trực tiếp trong database</CardDescription>
        </CardHeader>
        <CardContent>
          {!activities || activities.length === 0 ? (
            <p className="text-sm text-slate-500">
              Bạn chưa có hoạt động nào. Hãy chọn khóa học C hoặc Python để bắt đầu!
            </p>
          ) : (
            <ul className="divide-y divide-slate-100">
              {activities.map((act) => {
                const lessonObj = act.lessons as unknown as { title?: string } | null;
                return (
                  <li key={act.id} className="flex items-center justify-between py-3 text-sm">
                    <div className="flex items-center gap-2.5">
                      <CheckCircle2 className="h-4 w-4 text-indigo-500" />
                      <div>
                        <span className="font-medium text-slate-800">{act.activity_type}</span>
                        {lessonObj?.title && (
                          <span className="text-slate-500"> · {lessonObj.title}</span>
                        )}
                      </div>
                    </div>
                    <span className="text-xs text-slate-400">
                      {formatRelativeDate(act.created_at)}
                    </span>
                  </li>
                );
              })}
            </ul>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
