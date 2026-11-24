import { getJudge0Config } from "@/lib/env";
import type { ProgrammingLanguage } from "@/types/database";

export interface Judge0RunRequest {
  language: ProgrammingLanguage;
  sourceCode: string;
  stdin: string;
  cpuTimeLimitSec?: number;
  memoryLimitKb?: number;
}

export interface Judge0RunResult {
  configured: boolean;
  statusId: number;
  statusDescription: string;
  stdout: string;
  stderr: string;
  compileOutput: string;
  exitCode: number | null;
  executionTimeMs: number | null;
  memoryKb: number | null;
  error?: string;
}

function toBase64(value: string): string {
  return Buffer.from(value, "utf-8").toString("base64");
}

function fromBase64(value: string | null | undefined): string {
  if (!value) return "";
  return Buffer.from(value, "base64").toString("utf-8");
}

/**
 * Executes C or Python source code strictly in an isolated Judge0 sandbox.
 * Never executes user code on the Next.js / Vercel server runtime.
 * If Judge0 is not configured, returns configured=false honestly without simulating execution.
 */
export async function executeInJudge0(req: Judge0RunRequest): Promise<Judge0RunResult> {
  const cfg = getJudge0Config();

  if (!cfg.configured) {
    return {
      configured: false,
      statusId: 0,
      statusDescription: "Execution Engine Not Configured",
      stdout: "",
      stderr: "",
      compileOutput: "",
      exitCode: null,
      executionTimeMs: null,
      memoryKb: null,
      error:
        "Dịch vụ thực thi code Judge0 chưa được cấu hình (thiếu JUDGE0_API_URL hoặc JUDGE0_API_KEY). Hệ thống không giả lập kết quả chạy code. Vui lòng cấu hình Judge0 trong biến môi trường.",
    };
  }

  const languageId =
    req.language === "c" ? cfg.cLanguageId : cfg.pythonLanguageId;

  const cpuLimit = Math.min(req.cpuTimeLimitSec ?? cfg.cpuTimeLimit, 5.0);
  const memoryLimit = Math.min(req.memoryLimitKb ?? cfg.memoryLimitKb, 256000);

  const endpoint = `${cfg.apiUrl.replace(/\/+$/, "")}/submissions?base64_encoded=true&wait=true`;

  const headers: Record<string, string> = {
    "Content-Type": "application/json",
  };

  if (cfg.isRapidApi) {
    headers["X-RapidAPI-Key"] = cfg.apiKey;
    if (cfg.rapidApiHost) {
      headers["X-RapidAPI-Host"] = cfg.rapidApiHost;
    }
  } else if (cfg.apiKey) {
    headers["X-Auth-Token"] = cfg.apiKey;
  }

  const payload = {
    language_id: languageId,
    source_code: toBase64(req.sourceCode),
    stdin: toBase64(req.stdin),
    cpu_time_limit: cpuLimit,
    wall_time_limit: Math.min(cpuLimit * 2 + 2, 10),
    memory_limit: memoryLimit,
    enable_network: false,
    max_processes_and_or_threads: 30,
  };

  try {
    const response = await fetch(endpoint, {
      method: "POST",
      headers,
      body: JSON.stringify(payload),
      cache: "no-store",
    });

    if (!response.ok) {
      const errText = await response.text().catch(() => "");
      return {
        configured: true,
        statusId: 13,
        statusDescription: `Judge0 HTTP ${response.status}`,
        stdout: "",
        stderr: errText.slice(0, 500),
        compileOutput: "",
        exitCode: null,
        executionTimeMs: null,
        memoryKb: null,
        error: `Lỗi kết nối đến Judge0 API (HTTP ${response.status}).`,
      };
    }

    const data = await response.json();
    const statusId = Number(data?.status?.id ?? 13);
    const statusDescription = String(data?.status?.description ?? "Unknown");
    const timeSec = data?.time ? Number(data.time) : null;

    return {
      configured: true,
      statusId,
      statusDescription,
      stdout: fromBase64(data?.stdout),
      stderr: fromBase64(data?.stderr),
      compileOutput: fromBase64(data?.compile_output),
      exitCode: typeof data?.exit_code === "number" ? data.exit_code : null,
      executionTimeMs: timeSec !== null && !Number.isNaN(timeSec) ? Math.round(timeSec * 1000) : null,
      memoryKb: typeof data?.memory === "number" ? data.memory : null,
    };
  } catch (err) {
    return {
      configured: true,
      statusId: 13,
      statusDescription: "Execution Service Unreachable",
      stdout: "",
      stderr: "",
      compileOutput: "",
      exitCode: null,
      executionTimeMs: null,
      memoryKb: null,
      error: `Không thể kết nối đến Judge0 execution service: ${err instanceof Error ? err.message : "Network error"}`,
    };
  }
}
