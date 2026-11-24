"use client";

import { useState } from "react";
import { useRouter } from "next/navigation";
import { CheckCircle2, Loader2, Play, Send, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import type {
  PublicExercise,
  PublicQuizQuestion,
  QuizEvaluationResponse,
} from "@/types/database";

interface QuizRunnerProps {
  exercise: PublicExercise;
  questions: PublicQuizQuestion[];
  initialCompleted: boolean;
}

export function QuizRunner({ exercise, questions, initialCompleted }: QuizRunnerProps) {
  const router = useRouter();
  const [answers, setAnswers] = useState<Record<string, string>>({});
  const [loadingMode, setLoadingMode] = useState<"test" | "submit" | null>(null);
  const [result, setResult] = useState<QuizEvaluationResponse | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [completed, setCompleted] = useState(initialCompleted);

  const allAnswered = questions.length === 5 && questions.every((q) => Boolean(answers[q.id]));

  async function evaluate(mode: "test" | "submit") {
    setLoadingMode(mode);
    setErrorMsg(null);
    try {
      const res = await fetch(`/api/exercises/${exercise.id}/${mode}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ type: "quiz", answers }),
      });
      const data = await res.json();
      if (!res.ok) {
        setErrorMsg(data.error || "Không thể chấm Quiz.");
        setLoadingMode(null);
        return;
      }
      setResult(data as QuizEvaluationResponse);
      if (mode === "submit" && data.lessonUnlocked) {
        setCompleted(true);
        router.refresh();
      }
    } catch {
      setErrorMsg("Lỗi kết nối máy chủ.");
    } finally {
      setLoadingMode(null);
    }
  }

  return (
    <div className="space-y-5 rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div>
          <div className="flex items-center gap-2">
            <Badge variant="violet">Theory Quiz (5 câu hỏi)</Badge>
            {completed && <Badge variant="success">Đã hoàn thành</Badge>}
            <span className="text-xs text-slate-500">Yêu cầu đạt: {exercise.pass_threshold}%</span>
          </div>
          <h3 className="mt-2 text-lg font-bold text-slate-900">{exercise.title}</h3>
        </div>
      </div>

      <p className="text-sm text-slate-600">{exercise.instructions}</p>

      <div className="space-y-4">
        {questions.map((q, idx) => {
          const fb = result?.feedback.find((f) => f.questionId === q.id);
          return (
            <div key={q.id} className="rounded-lg border border-slate-200 p-4">
              <p className="text-sm font-semibold text-slate-900">
                Câu {idx + 1}: {q.question_text}
              </p>
              <div className="mt-3 grid gap-2">
                {q.options.map((opt) => {
                  const selected = answers[q.id] === opt.id;
                  return (
                    <label
                      key={opt.id}
                      className={`flex cursor-pointer items-center gap-3 rounded-lg border px-3 py-2 text-sm transition-colors ${
                        selected
                          ? "border-indigo-500 bg-indigo-50 text-indigo-900"
                          : "border-slate-200 bg-white hover:bg-slate-50"
                      }`}
                    >
                      <input
                        type="radio"
                        name={q.id}
                        checked={selected}
                        onChange={() => setAnswers((prev) => ({ ...prev, [q.id]: opt.id }))}
                        className="accent-indigo-600"
                      />
                      <span className="font-semibold">{opt.option_label}.</span>
                      <span>{opt.option_text}</span>
                    </label>
                  );
                })}
              </div>

              {fb && (
                <div
                  className={`mt-3 rounded-lg p-3 text-xs ${
                    fb.isCorrect
                      ? "border border-emerald-200 bg-emerald-50 text-emerald-900"
                      : "border border-red-200 bg-red-50 text-red-900"
                  }`}
                >
                  <div className="flex items-center gap-1.5 font-semibold">
                    {fb.isCorrect ? (
                      <CheckCircle2 className="h-4 w-4 text-emerald-600" />
                    ) : (
                      <XCircle className="h-4 w-4 text-red-600" />
                    )}
                    {fb.isCorrect
                      ? "Chính xác!"
                      : `Chưa đúng — Đáp án đúng là ${fb.correctOptionLabel}.`}
                  </div>
                  <p className="mt-1">
                    <strong>Giải thích:</strong> {fb.explanation}
                  </p>
                  {fb.commonMisconception && (
                    <p className="mt-1">
                      <strong>Hiểu lầm thường gặp:</strong> {fb.commonMisconception}
                    </p>
                  )}
                </div>
              )}
            </div>
          );
        })}
      </div>

      {errorMsg && (
        <div className="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-700">
          {errorMsg}
        </div>
      )}

      {result && (
        <div className="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-slate-200 bg-slate-50 px-4 py-3">
          <p className="text-sm font-bold text-slate-900">
            {result.mode === "submit" ? "Kết quả Submit" : "Kết quả Test"}: {result.score}% (
            {result.correctCount}/{result.totalQuestions} câu đúng)
          </p>
          <Badge variant={result.passed ? "success" : "destructive"}>
            {result.passed ? "ĐẠT YÊU CẦU" : "CHƯA ĐẠT — HÃY ÔN LẠI"}
          </Badge>
        </div>
      )}

      <div className="flex flex-wrap items-center gap-3">
        <Button
          type="button"
          variant="outline"
          disabled={!allAnswered || loadingMode !== null}
          onClick={() => evaluate("test")}
        >
          {loadingMode === "test" ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Play className="mr-2 h-4 w-4" />
          )}
          Test (Kiểm tra thử)
        </Button>

        <Button
          type="button"
          disabled={!allAnswered || loadingMode !== null}
          onClick={() => evaluate("submit")}
        >
          {loadingMode === "submit" ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Send className="mr-2 h-4 w-4" />
          )}
          Submit (Lưu điểm chính thức)
        </Button>
      </div>
    </div>
  );
}
