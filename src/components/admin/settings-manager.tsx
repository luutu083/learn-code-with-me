"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2 } from "lucide-react";
import { Button } from "@/components/ui/button";

export function SkipExerciseToggle({ initialValue }: { initialValue: boolean }) {
  const router = useRouter();
  const [enabled, setEnabled] = useState(initialValue);
  const [saving, setSaving] = useState(false);

  async function toggle() {
    setSaving(true);
    const next = !enabled;
    const res = await fetch("/api/admin/settings", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ allow_skip_exercises: next }),
    });
    if (res.ok) {
      setEnabled(next);
      router.refresh();
    }
    setSaving(false);
  }

  return (
    <div className="flex items-center justify-between rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
      <div>
        <h3 className="text-sm font-bold text-slate-900">
          Cho phép bỏ qua bài tập (Allow Skip Exercises)
        </h3>
        <p className="mt-1 text-xs text-slate-500">
          Mặc định TẮT: Học viên bắt buộc hoàn thành bài tập sau mỗi bài học để mở khóa bài tiếp theo.
        </p>
      </div>
      <Button
        type="button"
        variant={enabled ? "destructive" : "outline"}
        disabled={saving}
        onClick={toggle}
      >
        {saving ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : null}
        {enabled ? "Đang BẬT (Nhấn để Tắt)" : "Đang TẮT (Nhấn để Bật)"}
      </Button>
    </div>
  );
}
