"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2, ShieldCheck } from "lucide-react";
import { Button } from "@/components/ui/button";

export function LessonRowActions({
  lessonId,
  language,
  isPublished,
}: {
  lessonId: string;
  language: "c" | "python";
  isPublished: boolean;
}) {
  const router = useRouter();
  const [busy, setBusy] = useState(false);

  async function togglePublish() {
    setBusy(true);
    await fetch("/api/admin/lessons", {
      method: "PATCH",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ id: lessonId, is_published: !isPublished }),
    });
    router.refresh();
    setBusy(false);
  }

  async function runVerification() {
    setBusy(true);
    const defaultSource =
      language === "c"
        ? {
            sourceName: "The GNU C Reference Manual",
            sourceUrl: "https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html",
          }
        : {
            sourceName: "The Python Tutorial — Official Python Documentation",
            sourceUrl: "https://docs.python.org/3/tutorial/index.html",
          };

    await fetch("/api/ai/verify", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({
        lessonId,
        ...defaultSource,
      }),
    });
    router.refresh();
    setBusy(false);
  }

  return (
    <div className="flex items-center gap-2">
      <Button type="button" size="sm" variant="outline" disabled={busy} onClick={togglePublish}>
        {busy ? <Loader2 className="h-3.5 w-3.5 animate-spin" /> : isPublished ? "Ẩn bài" : "Xuất bản"}
      </Button>
      <Button type="button" size="sm" variant="secondary" disabled={busy} onClick={runVerification}>
        <ShieldCheck className="mr-1 h-3.5 w-3.5" />
        Kiểm chứng
      </Button>
    </div>
  );
}
