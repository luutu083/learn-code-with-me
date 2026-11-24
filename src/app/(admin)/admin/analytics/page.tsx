import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { SimpleBarChart } from "@/components/dashboard/progress-charts";

export default async function AdminAnalyticsPage() {
  await requireAdmin();
  const db = createServiceRoleClient();

  const [
    { data: courses },
    { data: lessons },
    { data: progressRows },
    { data: submissions },
    { data: quizAttempts },
  ] = await Promise.all([
    db.from("courses").select("id, title, language"),
    db.from("lessons").select("id, course_id, title"),
    db.from("lesson_progress").select("course_id, lesson_id, lesson_completed"),
    db.from("exercise_submissions").select("lesson_id, passed, error_type, score"),
    db.from("quiz_attempts").select("course_id, score, passed"),
  ]);

  // 1. Course completion rate
  const completionData = (courses ?? []).map((c) => {
    const cRows = (progressRows ?? []).filter((p) => p.course_id === c.id);
    const done = cRows.filter((p) => p.lesson_completed).length;
    const rate = cRows.length ? Math.round((done / cRows.length) * 100) : 0;
    return { label: c.language.toUpperCase(), value: rate };
  });

  // 2. Exercise pass rate (Coding vs Quiz)
  const codingTotal = (submissions ?? []).length;
  const codingPassed = (submissions ?? []).filter((s) => s.passed).length;
  const quizTotal = (quizAttempts ?? []).length;
  const quizPassed = (quizAttempts ?? []).filter((q) => q.passed).length;

  const passRateData = [
    { label: "Coding Pass %", value: codingTotal ? Math.round((codingPassed / codingTotal) * 100) : 0 },
    { label: "Quiz Pass %", value: quizTotal ? Math.round((quizPassed / quizTotal) * 100) : 0 },
  ];

  // 3. Common programming errors
  const errCounts = new Map<string, number>();
  for (const s of submissions ?? []) {
    if (s.error_type) {
      errCounts.set(s.error_type, (errCounts.get(s.error_type) ?? 0) + 1);
    }
  }
  const commonErrorsData = Array.from(errCounts.entries()).map(([label, value]) => ({
    label,
    value,
  }));

  // 4. Most difficult lessons (lowest pass rate among attempted coding lessons)
  const lessonStats = new Map<string, { total: number; failed: number }>();
  for (const s of submissions ?? []) {
    const cur = lessonStats.get(s.lesson_id) ?? { total: 0, failed: 0 };
    cur.total += 1;
    if (!s.passed) cur.failed += 1;
    lessonStats.set(s.lesson_id, cur);
  }
  const lessonNameMap = new Map((lessons ?? []).map((l) => [l.id, l.title]));
  const difficultLessons = Array.from(lessonStats.entries())
    .map(([lessonId, st]) => ({
      label: (lessonNameMap.get(lessonId) || "Lesson").slice(0, 18),
      value: Math.round((st.failed / st.total) * 100),
    }))
    .sort((a, b) => b.value - a.value)
    .slice(0, 6);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Admin Analytics</h1>
        <p className="text-sm text-slate-500">
          Đánh giá chất lượng giảng dạy, tỷ lệ đạt bài tập và các lỗi lập trình phổ biến
        </p>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Course Completion Rate (%)</CardTitle>
            <CardDescription>Tỷ lệ hoàn thành bài học theo từng khóa</CardDescription>
          </CardHeader>
          <CardContent>
            <SimpleBarChart data={completionData} color="#4f46e5" unit="%" />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Exercise Pass Rate (%)</CardTitle>
            <CardDescription>Tỷ lệ đạt của Coding Exercise và Theory Quiz</CardDescription>
          </CardHeader>
          <CardContent>
            <SimpleBarChart data={passRateData} color="#10b981" unit="%" />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Most Difficult Lessons (Fail Rate %)</CardTitle>
            <CardDescription>Các bài học có tỷ lệ nộp sai cao nhất cần cải thiện bài giảng</CardDescription>
          </CardHeader>
          <CardContent>
            <SimpleBarChart data={difficultLessons} color="#ef4444" unit="%" />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Common Programming Errors</CardTitle>
            <CardDescription>Phân bố lỗi compile, runtime, wrong answer và timeout</CardDescription>
          </CardHeader>
          <CardContent>
            <SimpleBarChart data={commonErrorsData} color="#f59e0b" unit=" lần" />
          </CardContent>
        </Card>
      </div>
    </div>
  );
}
