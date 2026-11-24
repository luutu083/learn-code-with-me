import { executeInJudge0 } from "@/lib/execution/judge0";
import type {
  CodingEvaluationResponse,
  ProgrammingLanguage,
  TestCaseExecutionResult,
} from "@/types/database";

export interface RawTestCase {
  id: string;
  name: string;
  input_data: string;
  expected_output: string;
  is_hidden: boolean;
}

const MAX_CODE_LENGTH = 32_000;

/**
 * Static safety pre-check to reject obviously abusive patterns before sending to sandbox.
 * Real isolation is enforced by Judge0's container sandbox (no network, CPU/memory/process caps).
 */
export function validateSubmittedCode(language: ProgrammingLanguage, code: string): string | null {
  if (!code || !code.trim()) {
    return "Vui lòng nhập mã nguồn trước khi chạy kiểm tra.";
  }
  if (code.length > MAX_CODE_LENGTH) {
    return `Mã nguồn vượt quá giới hạn ${MAX_CODE_LENGTH} ký tự.`;
  }
  if (language === "c") {
    const blocked = [/\bsystem\s*\(/, /\bpopen\s*\(/, /\bfork\s*\(/, /\bexec[lv]p?\s*\(/];
    if (blocked.some((rx) => rx.test(code))) {
      return "Mã nguồn C chứa lời gọi tiến trình hệ thống không được phép (system/popen/fork/exec).";
    }
  } else {
    const blocked = [/\bsubprocess\b/, /\bos\.system\s*\(/, /\bos\.popen\s*\(/, /\bsocket\b/];
    if (blocked.some((rx) => rx.test(code))) {
      return "Mã nguồn Python chứa module hệ thống hoặc mạng không được phép trong bài tập cơ bản.";
    }
  }
  return null;
}

function normalizeOutput(value: string): string {
  return value
    .replace(/\r\n/g, "\n")
    .split("\n")
    .map((line) => line.trimEnd())
    .join("\n")
    .trim();
}

function extractLineNumber(language: ProgrammingLanguage, errorText: string): number | null {
  if (!errorText) return null;
  if (language === "c") {
    // GCC format: main.c:12:5: error: ...
    const match = errorText.match(/:(\d+):\d+:\s*(?:error|warning|fatal error)/i) || errorText.match(/:(\d+):/);
    return match ? Number(match[1]) : null;
  }
  // Python traceback format: File "...", line 7
  const matches = Array.from(errorText.matchAll(/line\s+(\d+)/gi));
  if (matches.length > 0) {
    return Number(matches[matches.length - 1][1]);
  }
  return null;
}

function buildDiagnostic(
  language: ProgrammingLanguage,
  results: TestCaseExecutionResult[],
  compileErrorText: string | null,
  runtimeErrorText: string | null,
  timeLimitHit: boolean
): CodingEvaluationResponse["diagnostic"] {
  if (compileErrorText) {
    const lineNumber = extractLineNumber(language, compileErrorText);
    return {
      errorType: "compile_error",
      lineNumber,
      errorMessage: compileErrorText.trim().slice(0, 800),
      explanation:
        language === "c"
          ? "Trình biên dịch GCC phát hiện lỗi cú pháp hoặc kiểu dữ liệu trước khi chương trình có thể chạy."
          : "Trình thông dịch Python phát hiện lỗi cú pháp (SyntaxError).",
      hint:
        lineNumber !== null
          ? `Hãy kiểm tra kỹ dòng ${lineNumber} và các dòng ngay trước đó (dấu chấm phẩy, ngoặc nhọn/tròn, tên biến hoặc thư viện #include).`
          : "Hãy rà soát lại cú pháp, dấu ngoặc, dấu chấm phẩy và khai báo biến.",
    };
  }

  if (timeLimitHit) {
    return {
      errorType: "time_limit",
      lineNumber: null,
      errorMessage: "Time Limit Exceeded (vượt quá thời gian thực thi cho phép).",
      explanation: "Chương trình chạy quá lâu, thường do vòng lặp vô hạn hoặc thuật toán chưa tối ưu.",
      hint: "Kiểm tra điều kiện dừng của các vòng lặp while/for và đảm bảo biến điều kiện luôn thay đổi về phía điều kiện dừng.",
    };
  }

  if (runtimeErrorText) {
    const lineNumber = extractLineNumber(language, runtimeErrorText);
    return {
      errorType: "runtime_error",
      lineNumber,
      errorMessage: runtimeErrorText.trim().slice(0, 800),
      explanation:
        "Chương trình gặp lỗi trong quá trình chạy (ví dụ: chia cho 0, truy cập ngoài phạm vi mảng/con trỏ, hoặc sai kiểu dữ liệu đầu vào).",
      hint:
        lineNumber !== null
          ? `Kiểm tra logic tại dòng ${lineNumber}, đặc biệt là giá trị đầu vào, chỉ số mảng và phép chia.`
          : "Kiểm tra cách đọc dữ liệu đầu vào (scanf/input) và các trường hợp biên.",
    };
  }

  const firstFailed = results.find((r) => !r.passed);
  if (firstFailed) {
    return {
      errorType: "wrong_answer",
      lineNumber: null,
      errorMessage: firstFailed.isHidden
        ? `Không đạt ở ${firstFailed.name} (Hidden Test Case).`
        : `Output thực tế chưa khớp với output mong đợi ở ${firstFailed.name}.`,
      explanation:
        "Chương trình biên dịch và chạy thành công, nhưng kết quả in ra chưa trùng khớp hoàn toàn với yêu cầu đề bài.",
      hint:
        "Kiểm tra định dạng in ra (khoảng trắng, xuống dòng, chữ hoa/thường) và thử tự chạy nhẩm lại công thức với input mẫu cũng như các giá trị biên (0, số âm, chuỗi rỗng).",
    };
  }

  return undefined;
}

export async function runCodingExerciseTests(params: {
  mode: "test" | "submit";
  language: ProgrammingLanguage;
  sourceCode: string;
  testCases: RawTestCase[];
  passThreshold: number;
  timeLimitMs: number;
  memoryLimitKb: number;
}): Promise<CodingEvaluationResponse> {
  const { mode, language, sourceCode, testCases, passThreshold, timeLimitMs, memoryLimitKb } = params;
  const cpuTimeLimitSec = Math.max(1, timeLimitMs / 1000);

  const results: TestCaseExecutionResult[] = [];
  let compileErrorText: string | null = null;
  let runtimeErrorText: string | null = null;
  let timeLimitHit = false;

  for (let i = 0; i < testCases.length; i++) {
    const tc = testCases[i];
    const run = await executeInJudge0({
      language,
      sourceCode,
      stdin: tc.input_data,
      cpuTimeLimitSec,
      memoryLimitKb,
    });

    if (!run.configured) {
      return {
        mode,
        configured: false,
        score: 0,
        passed: false,
        passedTests: 0,
        totalTests: testCases.length,
        results: [],
        diagnostic: {
          errorType: null,
          lineNumber: null,
          errorMessage: run.error || "Judge0 chưa được cấu hình.",
          explanation: "Chưa kết nối được dịch vụ thực thi code cô lập.",
          hint: "Cấu hình JUDGE0_API_URL và JUDGE0_API_KEY trong biến môi trường để kích hoạt chấm bài thực tế.",
        },
      };
    }

    // Status 6 = Compilation Error in Judge0 CE
    if (run.statusId === 6 || (run.compileOutput && run.statusId !== 3)) {
      compileErrorText = run.compileOutput || run.stderr || run.statusDescription;
      // Fill remaining test cases as failed due to compilation error without redundant calls
      for (let j = i; j < testCases.length; j++) {
        const rem = testCases[j];
        results.push({
          testCaseId: rem.id,
          name: rem.name,
          isHidden: rem.is_hidden,
          passed: false,
          status: "Compilation Error",
          stdout: "",
          stderr: rem.is_hidden ? "" : compileErrorText,
          expectedOutput: rem.is_hidden ? undefined : rem.expected_output,
          actualOutput: rem.is_hidden ? undefined : "",
          executionTimeMs: null,
          memoryKb: null,
        });
      }
      break;
    }

    // Status 5 = Time Limit Exceeded
    if (run.statusId === 5) {
      timeLimitHit = true;
    }

    // Status 7..12 = Runtime Errors in Judge0 CE
    if (run.statusId >= 7 && run.statusId <= 12) {
      if (!runtimeErrorText) {
        runtimeErrorText = run.stderr || run.statusDescription;
      }
    }

    const actualNorm = normalizeOutput(run.stdout);
    const expectedNorm = normalizeOutput(tc.expected_output);
    const passed = run.statusId === 3 && actualNorm === expectedNorm;

    results.push({
      testCaseId: tc.id,
      name: tc.name,
      isHidden: tc.is_hidden,
      passed,
      status: passed ? "Passed" : run.statusId === 3 ? "Wrong Answer" : run.statusDescription,
      stdout: tc.is_hidden ? "" : run.stdout,
      stderr: tc.is_hidden ? "" : run.stderr,
      expectedOutput: tc.is_hidden ? undefined : tc.expected_output,
      actualOutput: tc.is_hidden ? undefined : run.stdout,
      executionTimeMs: run.executionTimeMs,
      memoryKb: run.memoryKb,
    });
  }

  const passedTests = results.filter((r) => r.passed).length;
  const totalTests = testCases.length;
  const score = totalTests > 0 ? Math.round((passedTests / totalTests) * 100) : 0;
  const passed = totalTests > 0 && score >= passThreshold;

  const diagnostic = passed
    ? undefined
    : buildDiagnostic(language, results, compileErrorText, runtimeErrorText, timeLimitHit);

  return {
    mode,
    configured: true,
    score,
    passed,
    passedTests,
    totalTests,
    results,
    diagnostic,
  };
}
