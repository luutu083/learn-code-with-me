import Link from "next/link";
import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { formatDuration, formatRelativeDate } from "@/lib/utils";

export default async function AdminUsersPage({
  searchParams,
}: {
  searchParams: { q?: string };
}) {
  await requireAdmin();
  const { q } = searchParams;
  const query = (q || "").trim().toLowerCase();

  const db = createServiceRoleClient();
  const [{ data: profiles }, { data: progressRows }] = await Promise.all([
    db.from("profiles").select("*").order("created_at", { ascending: false }),
    db.from("lesson_progress").select("user_id, lesson_completed, time_spent_seconds"),
  ]);

  const filtered = (profiles ?? []).filter(
    (p) =>
      !query ||
      p.email.toLowerCase().includes(query) ||
      (p.full_name || "").toLowerCase().includes(query)
  );

  const progByUser = new Map<string, { completed: number; seconds: number }>();
  for (const r of progressRows ?? []) {
    const cur = progByUser.get(r.user_id) ?? { completed: 0, seconds: 0 };
    if (r.lesson_completed) cur.completed += 1;
    cur.seconds += r.time_spent_seconds || 0;
    progByUser.set(r.user_id, cur);
  }

  return (
    <div className="space-y-6">
      <div className="flex flex-wrap items-center justify-between gap-4">
        <div>
          <h1 className="text-2xl font-bold text-slate-900">Quản lý người dùng</h1>
          <p className="text-sm text-slate-500">Tổng số: {filtered.length} tài khoản</p>
        </div>

        <form method="GET" className="flex gap-2">
          <input
            type="text"
            name="q"
            defaultValue={q || ""}
            placeholder="Tìm theo tên hoặc email..."
            className="rounded-lg border border-slate-300 bg-white px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none"
          />
          <button
            type="submit"
            className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white hover:bg-indigo-700"
          >
            Tìm kiếm
          </button>
        </form>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Danh sách học viên &amp; quản trị viên</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left text-sm">
              <thead className="border-b border-slate-200 text-xs uppercase text-slate-500">
                <tr>
                  <th className="py-2 pr-4">Người dùng</th>
                  <th className="py-2 pr-4">Role</th>
                  <th className="py-2 pr-4">Ưu tiên</th>
                  <th className="py-2 pr-4">Bài hoàn thành</th>
                  <th className="py-2 pr-4">Thời gian học</th>
                  <th className="py-2 pr-4">Hoạt động cuối</th>
                  <th className="py-2">Chi tiết</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {filtered.map((u) => {
                  const stat = progByUser.get(u.id) ?? { completed: 0, seconds: 0 };
                  return (
                    <tr key={u.id}>
                      <td className="py-3 pr-4">
                        <p className="font-semibold text-slate-900">{u.full_name || "(Chưa đặt tên)"}</p>
                        <p className="text-xs text-slate-500">{u.email}</p>
                      </td>
                      <td className="py-3 pr-4">
                        <Badge variant={u.role === "ADMIN" ? "violet" : "outline"}>{u.role}</Badge>
                      </td>
                      <td className="py-3 pr-4 uppercase">{u.preferred_language || "c"}</td>
                      <td className="py-3 pr-4 font-semibold">{stat.completed}</td>
                      <td className="py-3 pr-4">{formatDuration(stat.seconds)}</td>
                      <td className="py-3 pr-4 text-xs text-slate-500">
                        {formatRelativeDate(u.updated_at)}
                      </td>
                      <td className="py-3">
                        <Link
                          href={`/admin/users/${u.id}`}
                          className="text-xs font-semibold text-indigo-600 hover:underline"
                        >
                          Xem chi tiết →
                        </Link>
                      </td>
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
