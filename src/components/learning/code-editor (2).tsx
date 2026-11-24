"use client";

import { useState } from "react";
import dynamic from "next/dynamic";
import { useRouter } from "next/navigation";
import { AlertTriangle, CheckCircle2, Loader2, Play, RotateCcw, Send, XCircle } from "lucide-react";
import { Button } from "@/components/ui/button";
import { Badge } from "@/components/ui/badge";
import type {
  CodingEvaluationResponse,
  PublicExercise,
  PublicTestCase,
} from "@/types/database";

const MonacoEditor = dynamic(() => import("@monaco-editor/react"), {
  ssr: false,
  loading: () => (
    <div className="flex h-[340px] items-center justify-center rounded-lg border border-slate-200 bg-slate-900 text-sm text-slate-300">
      Đang tải Monaco Code Editor...
    </div>
  ),
});

interface CodingExerciseRunnerProps {
  exercise: PublicExercise;
  visibleTestCases: PublicTestCase[];
  initialCompleted: boolean;
  onCodeChange?: (code: string) => void;
}

export function CodingExerciseRunner({
  exercise,
  visibleTestCases,
  initialCompleted,
  onCodeChange,
}: CodingExerciseRunnerProps) {
  const router = useRouter();
  const [code, setCode] = useState(exercise.starter_code || "");
  const [runningMode, setRunningMode] = useState<"test" | "submit" | null>(null);
  const [result, setResult] = useState<CodingEvaluationResponse | null>(null);
  const [errorMsg, setErrorMsg] = useState<string | null>(null);
  const [completed, setCompleted] = useState(initialCompleted);

  function handleEditorChange(val: string | undefined) {
    const next = val ?? "";
    setCode(next);
    onCodeChange?.(next);
  }

  async function runAction(mode: "test" | "submit") {
    setRunningMode(mode);
    setErrorMsg(null);

    try {
      const res = await fetch(`/api/exercises/${exercise.id}/${mode}`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({ type: "coding", code }),
      });

      const data = await res.json();
      if (!res.ok && data?.configured !== false) {
        setErrorMsg(data.error || "Có lỗi xảy ra khi chấm bài.");
        setRunningMode(null);
        return;
      }

      setResult(data as CodingEvaluationResponse);
      if (mode === "submit" && data.lessonUnlocked) {
        setCompleted(true);
        router.refresh();
      }
    } catch {
      setErrorMsg("Không thể kết nối đến máy chủ chấm bài.");
    } finally {
      setRunningMode(null);
    }
  }

  return (
    <div className="space-y-4 rounded-xl border border-slate-200 bg-white p-5 shadow-sm">
      <div className="flex flex-wrap items-center justify-between gap-2">
        <div>
          <div className="flex items-center gap-2">
            <Badge variant="default">Coding Exercise ({exercise.language.toUpperCase()})</Badge>
            {completed && <Badge variant="success">Đã hoàn thành</Badge>}
            <span className="text-xs text-slate-500">Yêu cầu đạt: {exercise.pass_threshold}%</span>
          </div>
          <h3 className="mt-2 text-lg font-bold text-slate-900">{exercise.title}</h3>
        </div>
        <Button
          type="button"
          variant="outline"
          size="sm"
          onClick={() => handleEditorChange(exercise.starter_code || "")}
        >
          <RotateCcw className="mr-1.5 h-3.5 w-3.5" />
          Khôi phục mẫu
        </Button>
      </div>

      <p className="whitespace-pre-line text-sm text-slate-700">{exercise.instructions}</p>

      {(exercise.sample_input || exercise.sample_output) && (
        <div className="grid gap-3 sm:grid-cols-2">
          <div className="rounded-lg bg-slate-50 p-3">
            <p className="text-xs font-semibold uppercase text-slate-500">Input mẫu</p>
            <pre className="mt-1 overflow-x-auto font-mono text-xs text-slate-800">
              {exercise.sample_input || "(Không có input)"}
            </pre>
          </div>
          <div className="rounded-lg bg-slate-50 p-3">
            <p className="text-xs font-semibold uppercase text-slate-500">Output mẫu</p>
            <pre className="mt-1 overflow-x-auto font-mono text-xs text-slate-800">
              {exercise.sample_output}
            </pre>
          </div>
        </div>
      )}

      {visibleTestCases.length > 0 && (
        <div className="rounded-lg border border-slate-200 bg-slate-50/70 p-3">
          <p className="text-xs font-semibold uppercase text-slate-500">
            Test Cases công khai ({visibleTestCases.length} test + các hidden test case khi Submit)
          </p>
          <div className="mt-2 grid gap-2 sm:grid-cols-2">
            {visibleTestCases.map((tc) => (
              <div key={tc.id} className="rounded-md border border-slate-200 bg-white p-2.5 text-xs">
                <p className="font-semibold text-slate-800">{tc.name}</p>
                <p className="mt-1 text-slate-500">
                  Input: <code className="font-mono text-slate-800">{tc.input_data || "(trống)"}</code>
                </p>
                <p className="text-slate-500">
                  Expected: <code className="font-mono text-slate-800">{tc.expected_output}</code>
                </p>
              </div>
            ))}
          </div>
        </div>
      )}

      <div className="overflow-hidden rounded-lg border border-slate-300">
        <MonacoEditor
          height="340px"
          language={exercise.language === "c" ? "c" : "python"}
          theme="vs-dark"
          value={code}
          onChange={handleEditorChange}
          options={{
            minimap: { enabled: false },
            fontSize: 14,
            fontFamily: "var(--font-jetbrains-mono), monospace",
            scrollBeyondLastLine: false,
            automaticLayout: true,
            tabSize: exercise.language === "c" ? 4 : 4,
          }}
        />
      </div>

      <div className="flex flex-wrap items-center gap-3">
        <Button
          type="button"
          variant="outline"
          disabled={runningMode !== null}
          onClick={() => runAction("test")}
        >
          {runningMode === "test" ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Play className="mr-2 h-4 w-4" />
          )}
          Test (Chạy thử)
        </Button>

        <Button
          type="button"
          variant="default"
          disabled={runningMode !== null}
          onClick={() => runAction("submit")}
        >
          {runningMode === "submit" ? (
            <Loader2 className="mr-2 h-4 w-4 animate-spin" />
          ) : (
            <Send className="mr-2 h-4 w-4" />
          )}
          Submit (Nộp bài chính thức)
        </Button>
      </div>

      {errorMsg && (
        <div className="rounded-lg border border-red-200 bg-red-50 p-3 text-sm text-red-700">
          {errorMsg}
        </div>
      )}

      {result && (
        <div className="space-y-3 rounded-xl border border-slate-200 bg-slate-50 p-4">
          {!result.configured ? (
            <div className="flex items-start gap-3 rounded-lg border border-amber-300 bg-amber-50 p-3 text-sm text-amber-900">
              <AlertTriangle className="mt-0.5 h-5 w-5 shrink-0 text-amber-600" />
              <div>
                <p className="font-semibold">Dịch vụ thực thi code chưa được cấu hình</p>
                <p className="mt-1">{result.diagnostic?.errorMessage}</p>
              </div>
            </div>
          ) : (
            <>
              <div className="flex flex-wrap items-center justify-between gap-2">
                <p className="text-base font-bold text-slate-900">
                  {result.mode === "submit" ? "Submit Result" : "Test Result"}: {result.score}% Correct (
                  {result.passedTests}/{result.totalTests} passed)
                </p>
                <Badge variant={result.passed ? "success" : "destructive"}>
                  {result.passed ? "ĐẠT YÊU CẦU" : "CHƯA ĐẠT"}
                </Badge>
              </div>

              <div className="space-y-1.5">
                {result.results.map((r, idx) => (
                  <div
                    key={r.testCaseId}
                    className="flex flex-wrap items-center justify-between gap-2 rounded-lg border border-slate-200 bg-white px-3 py-2 text-xs"
                  >
                    <div className="flex items-center gap-2">
                      {r.passed ? (
                        <CheckCircle2 className="h-4 w-4 text-emerald-600" />
                      ) : (
                        <XCircle className="h-4 w-4 text-red-600" />
                      )}
                      <span className="font-semibold text-slate-800">
                        Test Case {idx + 1} ({r.name}
                        {r.isHidden ? " — Hidden" : ""}): {r.passed ? "Passed" : r.status}
                      </span>
                    </div>
                    {r.executionTimeMs !== null && (
                      <span className="text-slate-500">{r.executionTimeMs} ms</span>
                    )}
                    {!r.passed && !r.isHidden && (
                      <div className="mt-1 w-full rounded bg-slate-50 p-2 font-mono text-[11px] text-slate-700">
                        <div>Expected: {r.expectedOutput}</div>
                        <div>Actual: {r.actualOutput || "(trống)"}</div>
                      </div>
                    )}
                  </div>
                ))}
              </div>

              {result.diagnostic && (
                <div className="rounded-lg border border-amber-200 bg-amber-50 p-3 text-sm text-amber-950">
                  <p className="font-semibold">
                    Phân tích lỗi
                    {result.diagnostic.lineNumber ? ` (Dòng ${result.diagnostic.lineNumber})` : ""}:
                  </p>
                  <pre className="mt-1 overflow-x-auto whitespace-pre-wrap rounded bg-white/80 p-2 font-mono text-xs text-red-700">
                    {result.diagnostic.errorMessage}
                  </pre>
                  <p className="mt-2 text-xs">
                    <strong>Nguyên nhân:</strong> {result.diagnostic.explanation}
                  </p>
                  <p className="mt-1 text-xs">
                    <strong>Gợi ý sửa lỗi:</strong> {result.diagnostic.hint}
                  </p>
                </div>
              )}
            </>
          )}
        </div>
      )}
    </div>
  );
}
