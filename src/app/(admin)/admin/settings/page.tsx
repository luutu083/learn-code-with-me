import { requireAdmin } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { getGeminiConfig, getJudge0Config } from "@/lib/env";
import { Badge } from "@/components/ui/badge";
import { Card, CardContent, CardHeader, CardTitle } from "@/components/ui/card";
import { SkipExerciseToggle } from "@/components/admin/settings-manager";

export default async function AdminSettingsPage() {
  await requireAdmin();
  const db = createServiceRoleClient();
  const { data: skipRow } = await db
    .from("platform_settings")
    .select("value")
    .eq("key", "allow_skip_exercises")
    .maybeSingle();

  const allowSkip = Boolean(skipRow?.value === true || skipRow?.value === "true");
  const judge0 = getJudge0Config();
  const gemini = getGeminiConfig();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Cài đặt Hệ thống</h1>
        <p className="text-sm text-slate-500">Quản lý quy tắc học tập và kiểm tra tích hợp dịch vụ</p>
      </div>

      <SkipExerciseToggle initialValue={allowSkip} />

      <Card>
        <CardHeader>
          <CardTitle>Trạng thái tích hợp dịch vụ bên ngoài</CardTitle>
        </CardHeader>
        <CardContent className="space-y-3 text-sm">
          <div className="flex items-center justify-between">
            <span>Supabase PostgreSQL &amp; Auth</span>
            <Badge variant="success">Đã kết nối</Badge>
          </div>
          <div className="flex items-center justify-between">
            <span>Judge0 Sandboxed Execution Engine (C &amp; Python)</span>
            <Badge variant={judge0.configured ? "success" : "warning"}>
              {judge0.configured ? "Đã cấu hình" : "Chưa cấu hình (thiếu ENV)"}
            </Badge>
          </div>
          <div className="flex items-center justify-between">
            <span>Gemini AI Teaching Engine ({gemini.model})</span>
            <Badge variant={gemini.configured ? "success" : "warning"}>
              {gemini.configured ? "Đã cấu hình" : "Chưa cấu hình (thiếu GEMINI_API_KEY)"}
            </Badge>
          </div>
        </CardContent>
      </Card>
    </div>
  );
}
