import Link from "next/link";
import { notFound } from "next/navigation";
import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { SimpleBarChart } from "@/components/dashboard/progress-charts";
import { formatDuration, formatRelativeDate } from "@/lib/utils";

export default async function AdminUserDetailPage({
  params,
}: {
  params: Promise<{ id: string }>;
}) {
  await requireAdmin();
  const { id } = await params;
  const db = createServiceRoleClient();

  const { data: userProfile } = await db.from("profiles").select("*").eq("id", id).single();
  if (!userProfile) notFound();

  const [{ data: courses }, { data: lessons }, { data: progressRows }, { data: submissions }, { data: activities }] =
    await Promise.all([
      db.from("courses").select("id, title, language"),
      db.from("lessons").select("id, course_id, title"),
      db.from("lesson_progress").select("*").eq("user_id", id),
      db
        .from("exercise_submissions")
        .select("id, language, score, passed, attempt_number, error_type, created_at, exercises(title)")
        .eq("user_id", id)
        .order("created_at", { ascending: false })
        .limit(20),
      db
        .from("user_activities")
        .select("id, activity_type, created_at, lessons(title)")
        .eq("user_id", id)
        .order("created_at", { ascending: false })
        .limit(15),
    ]);

  const progList = progressRows ?? [];
  const completedIds = new Set(progList.filter((p) => p.lesson_completed).map((p) => p.lesson_id));
  const totalTimeSec = progList.reduce((acc, p) => acc + (p.time_spent_seconds || 0), 0);

  const chartData = (courses ?? []).map((c) => {
    const cLessons = (lessons ?? []).filter((l) => l.course_id === c.id);
    const done = cLessons.filter((l) => completedIds.has(l.id)).length;
    return {
      label: c.language.toUpperCase(),
      value: cLessons.length ? Math.round((done / cLessons.length) * 100) : 0,
    };
  });

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-3">
        <div>
          <Link href="/admin/users" className="text-xs font-semibold text-indigo-600 hover:underline">
            ← Quay lại danh sách Users
          </Link>
          <h1 className="mt-1 text-2xl font-bold text-slate-900">
            {userProfile.full_name || userProfile.email}
          </h1>
          <p className="text-sm text-slate-500">
            {userProfile.email} · Streak: {userProfile.current_streak_days} ngày · Tổng thời gian:{" "}
            {formatDuration(totalTimeSec)}
          </p>
        </div>
        <Badge variant={userProfile.role === "ADMIN" ? "violet" : "default"}>
          {userProfile.role}
        </Badge>
      </div>

      <div className="grid gap-6 lg:grid-cols-2">
        <Card>
          <CardHeader>
            <CardTitle>Tiến độ C &amp; Python (%)</CardTitle>
          </CardHeader>
          <CardContent>
            <SimpleBarChart data={chartData} color="#4f46e5" unit="%" />
          </CardContent>
        </Card>

        <Card>
          <CardHeader>
            <CardTitle>Hoạt động gần đây</CardTitle>
          </CardHeader>
          <CardContent>
            <ul className="divide-y divide-slate-100 text-xs">
              {(activities ?? []).map((a) => {
                const lObj = a.lessons as unknown as { title?: string } | null;
                return (
                  <li key={a.id} className="flex justify-between py-2">
                    <span>
                      <strong>{a.activity_type}</strong> {lObj?.title ? `· ${lObj.title}` : ""}
                    </span>
                    <span className="text-slate-400">{formatRelativeDate(a.created_at)}</span>
                  </li>
                );
              })}
              {(!activities || activities.length === 0) && (
                <li className="text-slate-500">Chưa có hoạt động nào.</li>
              )}
            </ul>
          </CardContent>
        </Card>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Lịch sử Submit Code ({submissions?.length ?? 0})</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="border-b border-slate-200 uppercase text-slate-500">
                <tr>
                  <th className="py-2 pr-4">Bài tập</th>
                  <th className="py-2 pr-4">Ngôn ngữ</th>
                  <th className="py-2 pr-4">Lần thử</th>
                  <th className="py-2 pr-4">Điểm</th>
                  <th className="py-2 pr-4">Loại lỗi</th>
                  <th className="py-2">Thời gian</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {(submissions ?? []).map((s) => {
                  const ex = s.exercises as unknown as { title?: string } | null;
                  return (
                    <tr key={s.id}>
                      <td className="py-2 pr-4 font-medium">{ex?.title || "Coding Exercise"}</td>
                      <td className="py-2 pr-4 uppercase">{s.language}</td>
                      <td className="py-2 pr-4">#{s.attempt_number}</td>
                      <td className="py-2 pr-4">
                        <Badge variant={s.passed ? "success" : "destructive"}>{s.score}%</Badge>
                      </td>
                      <td className="py-2 pr-4 text-slate-500">{s.error_type || "—"}</td>
                      <td className="py-2 text-slate-500">{formatRelativeDate(s.created_at)}</td>
                    </tr>
                  );
                })}
              </tbody>
            </table>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
