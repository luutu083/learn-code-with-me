"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { Loader2, Plus } from "lucide-react";
import { Button } from "@/components/ui/button";

export function CourseCreateForm() {
  const router = useRouter();
  const [title, setTitle] = useState("");
  const [slug, setSlug] = useState("");
  const [language, setLanguage] = useState<"c" | "python">("c");
  const [description, setDescription] = useState("");
  const [saving, setSaving] = useState(false);
  const [msg, setMsg] = useState<string | null>(null);

  async function handleCreate(e: React.FormEvent) {
    e.preventDefault();
    setSaving(true);
    setMsg(null);
    const res = await fetch("/api/admin/courses", {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ title, slug, language, description }),
    });
    if (res.ok) {
      setTitle("");
      setSlug("");
      setDescription("");
      setMsg("Đã tạo khóa học mới.");
      router.refresh();
    } else {
      const data = await res.json().catch(() => ({}));
      setMsg(data.error || "Không thể tạo khóa học.");
    }
    setSaving(false);
  }

  return (
    <form onSubmit={handleCreate} className="space-y-3 rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
      <h2 className="text-sm font-bold text-slate-900">Tạo khóa học mới</h2>
      {msg && <p className="text-xs text-indigo-700">{msg}</p>}
      <div className="grid gap-3 sm:grid-cols-3">
        <input
          required
          placeholder="Tên khóa học"
          value={title}
          onChange={(e) => setTitle(e.target.value)}
          className="rounded-lg border border-slate-300 px-3 py-2 text-sm"
        />
        <input
          required
          placeholder="slug-khoa-hoc"
          value={slug}
          onChange={(e) => setSlug(e.target.value)}
          className="rounded-lg border border-slate-300 px-3 py-2 text-sm"
        />
        <select
          value={language}
          onChange={(e) => setLanguage(e.target.value as "c" | "python")}
          className="rounded-lg border border-slate-300 px-3 py-2 text-sm"
        >
          <option value="c">C</option>
          <option value="python">Python</option>
        </select>
      </div>
      <textarea
        required
        rows={2}
        placeholder="Mô tả khóa học..."
        value={description}
        onChange={(e) => setDescription(e.target.value)}
        className="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm"
      />
      <Button type="submit" size="sm" disabled={saving}>
        {saving ? <Loader2 className="mr-1.5 h-3.5 w-3.5 animate-spin" /> : <Plus className="mr-1.5 h-3.5 w-3.5" />}
        Tạo khóa học
      </Button>
    </form>
  );
}
