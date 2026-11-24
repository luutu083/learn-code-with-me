import Link from "next/link";
import { Activity, BookOpen, CheckSquare, FileCode2, TrendingUp, Users } from "lucide-react";
import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default async function AdminOverviewPage() {
  await requireAdmin();
  const db = createServiceRoleClient();

  const sevenDaysAgo = new Date(Date.now() - 7 * 86_400_000).toISOString().slice(0, 10);

  const [
    { count: totalUsers },
    { count: activeUsers },
    { count: totalLessons },
    { count: totalExercises },
    { count: totalCodingSubs },
    { count: totalQuizAttempts },
    { data: progressRows },
    { data: codingScores },
    { data: quizScores },
  ] = await Promise.all([
    db.from("profiles").select("id", { count: "exact", head: true }),
    db.from("profiles").select("id", { count: "exact", head: true }).gte("last_active_date", sevenDaysAgo),
    db.from("lessons").select("id", { count: "exact", head: true }),
    db.from("exercises").select("id", { count: "exact", head: true }),
    db.from("exercise_submissions").select("id", { count: "exact", head: true }),
    db.from("quiz_attempts").select("id", { count: "exact", head: true }),
    db.from("lesson_progress").select("user_id, lesson_completed"),
    db.from("exercise_submissions").select("score"),
    db.from("quiz_attempts").select("score"),
  ]);

  const totalSubmissions = (totalCodingSubs ?? 0) + (totalQuizAttempts ?? 0);

  const completedCount = (progressRows ?? []).filter((p) => p.lesson_completed).length;
  const totalPossible = Math.max(1, (totalUsers ?? 1) * (totalLessons ?? 1));
  const avgProgress = Math.min(100, Math.round((completedCount / totalPossible) * 100));

  const allScores = [
    ...(codingScores ?? []).map((r) => r.score),
    ...(quizScores ?? []).map((r) => r.score),
  ];
  const avgExerciseScore = allScores.length
    ? Math.round(allScores.reduce((a, b) => a + b, 0) / allScores.length)
    : 0;

  const cards = [
    { title: "Total Users", value: totalUsers ?? 0, icon: Users, href: "/admin/users" },
    { title: "Active Users (7d)", value: activeUsers ?? 0, icon: Activity, href: "/admin/users" },
    { title: "Total Lessons", value: totalLessons ?? 0, icon: BookOpen, href: "/admin/lessons" },
    { title: "Total Exercises", value: totalExercises ?? 0, icon: CheckSquare, href: "/admin/exercises" },
    { title: "Total Submissions", value: totalSubmissions, icon: FileCode2, href: "/admin/analytics" },
    { title: "Avg Learning Progress", value: `${avgProgress}%`, icon: TrendingUp, href: "/admin/analytics" },
    { title: "Avg Exercise Score", value: `${avgExerciseScore}%`, icon: CheckSquare, href: "/admin/analytics" },
  ];

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Admin Overview</h1>
        <p className="text-sm text-slate-500">Tổng quan hệ thống Learn Code With Me</p>
      </div>

      <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3 xl:grid-cols-4">
        {cards.map((c) => {
          const Icon = c.icon;
          return (
            <Link key={c.title} href={c.href}>
              <Card className="transition-colors hover:border-indigo-300">
                <CardHeader className="flex flex-row items-center justify-between pb-2">
                  <CardTitle className="text-xs font-semibold uppercase text-slate-500">
                    {c.title}
                  </CardTitle>
                  <Icon className="h-4 w-4 text-violet-600" />
                </CardHeader>
                <CardContent>
                  <div className="text-2xl font-bold text-slate-900">{c.value}</div>
                </CardContent>
              </Card>
            </Link>
          );
        })}
      </div>
    </div>
  );
}
