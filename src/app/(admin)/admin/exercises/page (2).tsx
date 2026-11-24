import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";

export default async function AdminExercisesPage() {
  await requireAdmin();
  const db = createServiceRoleClient();

  const { data: exercises } = await db
    .from("exercises")
    .select(
      "id, title, type, language, pass_threshold, lessons(title), coding_test_cases(id, is_hidden), quiz_questions(id)"
    )
    .order("created_at", { ascending: true });

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Quản lý Bài tập &amp; Quiz</h1>
        <p className="text-sm text-slate-500">
          Kiểm tra cấu hình test case (Coding) và chuẩn 5 câu hỏi bắt buộc (Theory Quiz)
        </p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Danh sách bài tập ({exercises?.length ?? 0})</CardTitle>
        </CardHeader>
        <CardContent>
          <div className="overflow-x-auto">
            <table className="w-full text-left text-xs">
              <thead className="border-b border-slate-200 uppercase text-slate-500">
                <tr>
                  <th className="py-2 pr-4">Bài tập</th>
                  <th className="py-2 pr-4">Bài học</th>
                  <th className="py-2 pr-4">Loại</th>
                  <th className="py-2 pr-4">Ngôn ngữ</th>
                  <th className="py-2 pr-4">Kiểm tra cấu trúc</th>
                  <th className="py-2">Ngưỡng đạt</th>
                </tr>
              </thead>
              <tbody className="divide-y divide-slate-100">
                {(exercises ?? []).map((ex) => {
                  const lessonObj = ex.lessons as unknown as { title?: string } | null;
                  const tcs = (ex.coding_test_cases as Array<{ id: string; is_hidden: boolean }>) ?? [];
                  const qs = (ex.quiz_questions as Array<{ id: string }>) ?? [];
                  const hiddenCount = tcs.filter((t) => t.is_hidden).length;

                  return (
                    <tr key={ex.id}>
                      <td className="py-2.5 pr-4 font-semibold text-slate-900">{ex.title}</td>
                      <td className="py-2.5 pr-4 text-slate-600">{lessonObj?.title}</td>
                      <td className="py-2.5 pr-4">
                        <Badge variant={ex.type === "coding" ? "default" : "violet"}>
                          {ex.type.toUpperCase()}
                        </Badge>
                      </td>
                      <td className="py-2.5 pr-4 uppercase">{ex.language}</td>
                      <td className="py-2.5 pr-4">
                        {ex.type === "coding" ? (
                          <span>
                            {tcs.length} test cases ({hiddenCount} hidden)
                          </span>
                        ) : (
                          <Badge variant={qs.length === 5 ? "success" : "destructive"}>
                            {qs.length}/5 câu hỏi
                          </Badge>
                        )}
                      </td>
                      <td className="py-2.5 font-semibold">{ex.pass_threshold}%</td>
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
