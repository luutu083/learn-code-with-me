import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { LessonRowActions } from "@/components/admin/lesson-actions";

export default async function AdminLessonsPage() {
  await requireAdmin();
  const db = createServiceRoleClient();

  const { data: lessons } = await db
    .from("lessons")
    .select("id, title, slug, language, language_version, is_published, verification_status, courses(title)")
    .order("created_at", { ascending: true });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Quản lý Bài giảng &amp; Kiểm chứng</h1>
        <p className="text-sm text-slate-500">
          Tổng số: {lessons?.length ?? 0} bài học. Chạy kiểm chứng 7 bước trước khi xuất bản.
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Danh sách bài giảng</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="border-b border-slate-200 uppercase text-slate-500">
                <tr>
                  <th className="py-2 pr-4">Bài học</th>
                  <th className="py-2 pr-4">Khóa học</th>
                  <th className="py-2 pr-4">Phiên bản</th>
                  <th className="py-2 pr-4">Xác minh</th>
                  <th className="py-2 pr-4">Trạng thái</th>
                  <th className="py-2">Hành động</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {(lessons ?? []).map((l) => {
                  const courseObj = l.courses as unknown as { title?: string } | null;
                  return (
                    <tr key={l.id}>
                      <td className="py-2.5 pr-4 font-semibold text-slate-900">{l.title}</td>
                      <td className="py-2.5 pr-4 text-slate-600">{courseObj?.title}</td>
                      <td className="py-2.5 pr-4 text-slate-500">{l.language_version}</td>
                      <td className="py-2.5 pr-4">
                        <Badge
                          variant={
                            l.verification_status === "verified"
                              ? "success"
                              : l.verification_status === "unverified"
                                ? "destructive"
                                : "warning"
                          }
                        >
                          {l.verification_status}
                        </Badge>
                      </td>
                      <td className="py-2.5 pr-4">
                        <Badge variant={l.is_published ? "default" : "outline"}>
                          {l.is_published ? "Published" : "Hidden"}
                        </Badge>
                      </td>
                      <td className="py-2.5">
                        <LessonRowActions
                          lessonId={l.id}
                          language={l.language}
                          isPublished={l.is_published}
                        />
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
