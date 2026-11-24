import { requireAuth } from "@/lib/supabase/auth";
import { createServerSupabaseClient } from "@/lib/supabase/server";
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from "@/components/ui/card";
import { Badge } from "@/components/ui/badge";
import { formatRelativeDate } from "@/lib/utils";

export default async function HistoryPage() {
  const { user } = await requireAuth();
  const supabase = await createServerSupabaseClient();

  const [{ data: submissions }, { data: quizAttempts }] = await Promise.all([
    supabase
      .from("exercise_submissions")
      .select("id, language, score, passed, passed_tests, total_tests, attempt_number, created_at, exercises(title)")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(30),
    supabase
      .from("quiz_attempts")
      .select("id, score, correct_count, total_questions, passed, attempt_number, created_at, exercises(title)")
      .eq("user_id", user.id)
      .order("created_at", { ascending: false })
      .limit(30),
  ]);

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Lịch sử bài tập</h1>
        <p className="text-sm text-slate-500">Toàn bộ lịch sử nộp bài Coding và làm Quiz của bạn</p>
      </div>

      <Card>
        <CardHeader>
          <CardTitle>Bài nộp Coding ({submissions?.length ?? 0})</CardTitle>
          <CardDescription>Kết quả thực thi từ Judge0 sandbox</CardDescription>
        </CardHeader>
        <CardContent>
          {!submissions || submissions.length === 0 ? (
            <p className="text-sm text-slate-500">Chưa có lần nộp code nào.</p>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left text-sm">
                <thead className="border-b border-slate-200 text-xs uppercase text-slate-500">
                  <tr>
                    <th className="py-2 pr-4">Bài tập</th>
                    <th className="py-2 pr-4">Ngôn ngữ</th>
                    <th className="py-2 pr-4">Lần thử</th>
                    <th className="py-2 pr-4">Test Cases</th>
                    <th className="py-2 pr-4">Điểm</th>
                    <th className="py-2">Thời gian</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {submissions.map((s) => {
                    const ex = s.exercises as unknown as { title?: string } | null;
                    return (
                      <tr key={s.id}>
                        <td className="py-2.5 pr-4 font-medium text-slate-900">{ex?.title || "Coding Exercise"}</td>
                        <td className="py-2.5 pr-4 uppercase">{s.language}</td>
                        <td className="py-2.5 pr-4">#{s.attempt_number}</td>
                        <td className="py-2.5 pr-4">{s.passed_tests}/{s.total_tests}</td>
                        <td className="py-2.5 pr-4">
                          <Badge variant={s.passed ? "success" : "destructive"}>{s.score}%</Badge>
                        </td>
                        <td className="py-2.5 text-xs text-slate-500">{formatRelativeDate(s.created_at)}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </CardContent>
      </Card>

      <Card>
        <CardHeader>
          <CardTitle>Lịch sử làm Quiz ({quizAttempts?.length ?? 0})</CardTitle>
          <CardDescription>Các bài kiểm tra trắc nghiệm 5 câu đã nộp</CardDescription>
        </CardHeader>
        <CardContent>
          {!quizAttempts || quizAttempts.length === 0 ? (
            <p className="text-sm text-slate-500">Chưa có lượt nộp Quiz nào.</p>
          ) : (
            <div className="overflow-x-auto">
              <table className="w-full text-left text-sm">
                <thead className="border-b border-slate-200 text-xs uppercase text-slate-500">
                  <tr>
                    <th className="py-2 pr-4">Quiz</th>
                    <th className="py-2 pr-4">Lần thử</th>
                    <th className="py-2 pr-4">Số câu đúng</th>
                    <th className="py-2 pr-4">Điểm</th>
                    <th className="py-2">Thời gian</th>
                  </tr>
                </thead>
                <tbody className="divide-y divide-slate-100">
                  {quizAttempts.map((q) => {
                    const ex = q.exercises as unknown as { title?: string } | null;
                    return (
                      <tr key={q.id}>
                        <td className="py-2.5 pr-4 font-medium text-slate-900">{ex?.title || "Theory Quiz"}</td>
                        <td className="py-2.5 pr-4">#{q.attempt_number}</td>
                        <td className="py-2.5 pr-4">{q.correct_count}/{q.total_questions}</td>
                        <td className="py-2.5 pr-4">
                          <Badge variant={q.passed ? "success" : "destructive"}>{q.score}%</Badge>
                        </td>
                        <td className="py-2.5 text-xs text-slate-500">{formatRelativeDate(q.created_at)}</td>
                      </tr>
                    );
                  })}
                </tbody>
              </table>
            </div>
          )}
        </CardContent>
      </Card>
    </div>
  );
}
