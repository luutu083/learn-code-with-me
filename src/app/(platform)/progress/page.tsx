import { requireAuth } from "@/lib/supabase/auth";
import { createServerSupabaseClient } from "@/lib/supabase/server";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { SimpleBarChart } from "@/components/dashboard/progress-charts";
import { formatDuration } from "@/lib/utils";

export default async function ProgressPage() {
  const { user } = await requireAuth();
  const supabase = await createServerSupabaseClient();

  const [{ data: courses }, { data: lessons }, { data: progressRows }] = await Promise.all([
    supabase.from("courses").select("id, title, language").eq("is_published", true),
    supabase.from("lessons").select("id, course_id, title").eq("is_published", true),
    supabase.from("lesson_progress").select("*").eq("user_id", user.id),
  ]);

  const progList = progressRows ?? [];
  const totalTimeSec = progList.reduce((acc, p) => acc + (p.time_spent_seconds || 0), 0);
  const completedIds = new Set(progList.filter((p) => p.lesson_completed).map((p) => p.lesson_id));

  const courseChartData = (courses ?? []).map((c) => {
    const cLessons = (lessons ?? []).filter((l) => l.course_id === c.id);
    const done = cLessons.filter((l) => completedIds.has(l.id)).length;
    const pct = cLessons.length > 0 ? Math.round((done / cLessons.length) * 100) : 0;
    return { label: c.language.toUpperCase(), value: pct };
  });

  const scoreChartData = progList
    .filter((p) => p.best_coding_score > 0 || p.best_quiz_score > 0)
    .slice(0, 10)
    .map((p, idx) => ({
      label: `Bài ${idx + 1}`,
      value: Math.max(p.best_coding_score, p.best_quiz_score),
    }));

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Tiến độ học tập của tôi</h1>
        <p className="text-sm text-slate-500">
          Tổng thời gian học đã ghi nhận: <strong>{formatDuration(totalTimeSec)}</strong>
        </p>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Tỷ lệ hoàn thành theo khóa học</CardTitle>
            <CardDescription>Phần trăm bài học đã hoàn thành trên C và Python</CardDescription>
          </CardHeader>
          <CardContent>
            <SimpleBarChart data={courseChartData} color="#4f46e5" unit="%" />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Điểm số bài tập gần đây</CardTitle>
            <CardDescription>Điểm cao nhất trên các bài tập Coding &amp; Quiz</CardDescription>
          </CardHeader>
          <CardContent>
            <SimpleBarChart data={scoreChartData} color="#7c3aed" unit="%" />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
