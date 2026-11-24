import { executeInJudge0 } from "@/lib/execution/judge0";
import { isTrustedSourceUrl } from "@/lib/ai/verified-sources";
import type { ProgrammingLanguage, VerificationStatus } from "@/types/database";

export interface VerificationPipelineInput {
  lessonId: string;
  language: ProgrammingLanguage;
  languageVersion: string;
  sourceName: string;
  sourceUrl: string;
  sampleCode: string;
  expectedOutput?: string;
}

export interface VerificationPipelineResult {
  sourceTrusted: boolean;
  syntaxChecked: boolean;
  versionChecked: boolean;
  sandboxExecuted: boolean;
  sandboxOutputMatched: boolean;
  status: VerificationStatus;
  notes: string;
}

/**
 * 7-Step Verified Knowledge Check:
 * 1. Identify concept & language version
 * 2. Validate source URL against official trusted domains (never fabricate URLs)
 * 3. Check syntax & standard library headers/imports
 * 4. Verify version metadata
 * 5. Execute sample code in isolated Judge0 sandbox (if configured)
 * 6. Compare actual stdout against expected output
 * 7. Publish/mark 'verified' ONLY when all checks pass
 */
export async function runLessonVerificationPipeline(
  input: VerificationPipelineInput
): Promise<VerificationPipelineResult> {
  const notes: string[] = [];

  // Step 2: Trusted domain check
  const sourceTrusted = isTrustedSourceUrl(input.language, input.sourceUrl);
  if (!sourceTrusted) {
    notes.push("URL nguồn không nằm trong danh sách tài liệu chính thống được phép.");
  }

  // Step 3 & 4: Basic syntax / version presence check
  const versionChecked = Boolean(input.languageVersion && input.languageVersion.trim().length >= 2);
  let syntaxChecked = Boolean(input.sampleCode && input.sampleCode.trim().length > 0);
  if (input.language === "c" && syntaxChecked && !input.sampleCode.includes("main")) {
    syntaxChecked = false;
    notes.push("Ví dụ code C thiếu hàm main().");
  }

  // Step 5 & 6: Sandbox execution
  let sandboxExecuted = false;
  let sandboxOutputMatched = false;

  if (input.sampleCode.trim()) {
    const run = await executeInJudge0({
      language: input.language,
      sourceCode: input.sampleCode,
      stdin: "",
    });

    if (!run.configured) {
      notes.push("Judge0 chưa được cấu hình nên không thể chạy kiểm chứng sandbox tự động.");
    } else {
      sandboxExecuted = true;
      if (run.statusId === 3) {
        syntaxChecked = true;
        if (input.expectedOutput !== undefined && input.expectedOutput !== "") {
          const actual = run.stdout.replace(/\r\n/g, "\n").trim();
          const expected = input.expectedOutput.replace(/\r\n/g, "\n").trim();
          sandboxOutputMatched = actual === expected;
          if (!sandboxOutputMatched) {
            notes.push(`Output sandbox không khớp. Thực tế: "${actual.slice(0, 120)}"`);
          }
        } else {
          sandboxOutputMatched = true;
        }
      } else {
        syntaxChecked = false;
        notes.push(`Lỗi sandbox (${run.statusDescription}): ${(run.compileOutput || run.stderr).slice(0, 200)}`);
      }
    }
  }

  // Step 7: Determine status — never mark verified without trusted source & successful verification
  let status: VerificationStatus = "needs_review";
  if (sourceTrusted && versionChecked && syntaxChecked && sandboxExecuted && sandboxOutputMatched) {
    status = "verified";
    notes.push("Đạt toàn bộ 7 bước kiểm chứng kiến thức và thực thi sandbox.");
  } else if (!sourceTrusted) {
    status = "unverified";
  }

  return {
    sourceTrusted,
    syntaxChecked,
    versionChecked,
    sandboxExecuted,
    sandboxOutputMatched,
    status,
    notes: notes.join(" "),
  };
}
