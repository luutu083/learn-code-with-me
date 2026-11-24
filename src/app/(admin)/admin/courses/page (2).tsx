import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { CourseCreateForm } from "@/components/admin/course-manager";

export default async function AdminCoursesPage() {
  await requireAdmin();
  const db = createServiceRoleClient();

  const { data: courses } = await db
    .from("courses")
    .select("*, chapters(id, title, sort_order)")
    .order("sort_order");

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Quản lý Khóa học &amp; Chương học</h1>
        <p className="text-sm text-slate-500">Tạo và quản lý lộ trình học C &amp; Python</p>
      </div>

      <CourseCreateForm />

      <div className="grid gap-4 md:grid-cols-2">
        {(courses ?? []).map((c) => {
          const chapters = (c.chapters as Array<{ id: string; title: string; sort_order: number }>) ?? [];
          return (
            <Card key={c.id}>
              <CardHeader>
                <div className="flex items-center justify-between">
                  <Badge variant={c.language === "c" ? "default" : "violet"}>
                    {c.language.toUpperCase()}
                  </Badge>
                  <Badge variant={c.is_published ? "success" : "outline"}>
                    {c.is_published ? "Published" : "Hidden"}
                  </Badge>
                </div>
                <CardTitle className="pt-2">{c.title}</CardTitle>
              </CardHeader>
              <CardContent className="space-y-2 text-xs text-slate-600">
                <p>{c.description}</p>
                <p className="font-semibold text-slate-800">
                  Số chương hiện tại: {chapters.length}
                </p>
              </CardContent>
            </Card>
          );
        })}
      </div>
    </div>
  );
}
