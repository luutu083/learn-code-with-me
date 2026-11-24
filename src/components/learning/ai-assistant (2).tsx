"use client";

import { useState } from "react";
import { ExternalLink, Loader2, Send, ShieldCheck, Sparkles } from "lucide-react";
import { Button } from "@/components/ui/button";

interface ChatMessage {
  role: "user" | "assistant";
  content: string;
  sources?: { name: string; url: string; version: string }[];
  containsUnverifiedNotice?: boolean;
}

const QUICK_PROMPTS = [
  "Giải thích lại kiến thức này đơn giản hơn",
  "Tại sao đoạn code ví dụ hoạt động như vậy?",
  "Cho tôi một ví dụ thực tế khác",
  "Gợi ý giúp tôi nhưng đừng tiết lộ đáp án",
];

export function AiAssistantPanel({
  lessonId,
  lessonTitle,
  currentCode,
}: {
  lessonId: string;
  lessonTitle: string;
  currentCode?: string;
}) {
  const [messages, setMessages] = useState<ChatMessage[]>([
    {
      role: "assistant",
      content: `Xin chào! Mình là AI Teaching Assistant cho bài "${lessonTitle}". Mình chỉ giải thích dựa trên tài liệu lập trình đã kiểm chứng và sẽ gợi ý hướng tư duy chứ không làm thay bài tập của bạn. Bạn cần hỏi điều gì?`,
    },
  ]);
  const [input, setInput] = useState("");
  const [loading, setLoading] = useState(false);

  async function sendQuestion(questionText: string) {
    const trimmed = questionText.trim();
    if (!trimmed || loading) return;

    setMessages((prev) => [...prev, { role: "user", content: trimmed }]);
    setInput("");
    setLoading(true);

    try {
      const res = await fetch("/api/ai/chat", {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
          lessonId,
          question: trimmed,
          userCode: currentCode,
        }),
      });

      const data = await res.json();
      if (!res.ok) {
        setMessages((prev) => [
          ...prev,
          { role: "assistant", content: data.error || "Không thể gửi câu hỏi lúc này." },
        ]);
      } else {
        setMessages((prev) => [
          ...prev,
          {
            role: "assistant",
            content: data.answer,
            sources: data.verifiedSourcesUsed,
            containsUnverifiedNotice: data.containsUnverifiedNotice,
          },
        ]);
      }
    } catch {
      setMessages((prev) => [
        ...prev,
        { role: "assistant", content: "Lỗi kết nối đến AI Teaching Assistant." },
      ]);
    } finally {
      setLoading(false);
    }
  }

  return (
    <div className="flex h-[calc(100vh-5rem)] flex-col rounded-xl border border-slate-200 bg-white shadow-sm">
      <div className="border-b border-slate-200 p-4">
        <div className="flex items-center gap-2">
          <Sparkles className="h-5 w-5 text-violet-600" />
          <h3 className="text-sm font-bold text-slate-900">AI Teaching Assistant</h3>
        </div>
        <p className="mt-1 flex items-center gap-1 text-[11px] text-emerald-700">
          <ShieldCheck className="h-3.5 w-3.5" />
          Chống bịa đặt · Đối chiếu tài liệu chuẩn
        </p>
      </div>

      <div className="flex-1 space-y-3 overflow-y-auto p-4">
        {messages.map((m, idx) => (
          <div
            key={idx}
            className={`rounded-xl p-3 text-xs leading-relaxed ${
              m.role === "user"
                ? "ml-6 bg-indigo-600 text-white"
                : "mr-4 border border-slate-200 bg-slate-50 text-slate-800"
            }`}
          >
            <div className="whitespace-pre-wrap">{m.content}</div>
            {m.sources && m.sources.length > 0 && (
              <div className="mt-2 border-t border-slate-200 pt-2">
                <p className="text-[10px] font-semibold uppercase text-slate-500">
                  Nguồn đã xác minh:
                </p>
                <ul className="mt-1 space-y-0.5">
                  {m.sources.map((s) => (
                    <li key={s.url}>
                      <a
                        href={s.url}
                        target="_blank"
                        rel="noopener noreferrer"
                        className="inline-flex items-center gap-1 text-[11px] font-medium text-indigo-600 hover:underline"
                      >
                        {s.name} ({s.version})
                        <ExternalLink className="h-3 w-3" />
                      </a>
                    </li>
                  ))}
                </ul>
              </div>
            )}
          </div>
        ))}
        {loading && (
          <div className="flex items-center gap-2 text-xs text-slate-500">
            <Loader2 className="h-4 w-4 animate-spin text-violet-600" />
            AI đang đối chiếu tài liệu...
          </div>
        )}
      </div>

      <div className="border-t border-slate-200 p-3">
        <div className="mb-2 flex flex-wrap gap-1.5">
          {QUICK_PROMPTS.map((prompt) => (
            <button
              key={prompt}
              type="button"
              onClick={() => sendQuestion(prompt)}
              disabled={loading}
              className="rounded-full border border-slate-200 bg-slate-50 px-2.5 py-1 text-[11px] text-slate-700 hover:border-indigo-300 hover:bg-indigo-50"
            >
              {prompt}
            </button>
          ))}
        </div>
        <form
          onSubmit={(e) => {
            e.preventDefault();
            sendQuestion(input);
          }}
          className="flex gap-2"
        >
          <input
            type="text"
            value={input}
            onChange={(e) => setInput(e.target.value)}
            placeholder="Đặt câu hỏi về bài học..."
            className="flex-1 rounded-lg border border-slate-300 px-3 py-2 text-xs focus:border-indigo-500 focus:outline-none"
          />
          <Button type="submit" size="sm" disabled={loading || !input.trim()}>
            <Send className="h-3.5 w-3.5" />
          </Button>
        </form>
      </div>
    </div>
  );
}
