import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";
import { runLessonVerificationPipeline } from "@/lib/ai/verifier";

const verifySchema = z.object({
  lessonId: z.string().uuid(),
  sourceName: z.string().trim().min(2).max(200),
  sourceUrl: z.string().url(),
  expectedOutput: z.string().optional(),
});

/**
 * POST /api/ai/verify (ADMIN only)
 * Runs the 7-step Verified Knowledge check for a lesson and records an audit entry
 * in ai_verification_logs. Updates lesson verification_status ONLY when checks pass.
 */
export async function POST(request: NextRequest) {
  const auth = await getApiAuth();
  if (!auth) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  if (auth.profile.role !== "ADMIN") {
    return NextResponse.json({ error: "Forbidden: Admin access required" }, { status: 403 });
  }

  const body = await request.json().catch(() => null);
  const parsed = verifySchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu kiểm chứng không hợp lệ." }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();
  const { data: lesson, error } = await adminDb
    .from("lessons")
    .select("id, language, language_version, code_example")
    .eq("id", parsed.data.lessonId)
    .single();

  if (error || !lesson) {
    return NextResponse.json({ error: "Không tìm thấy bài học." }, { status: 404 });
  }

  const result = await runLessonVerificationPipeline({
    lessonId: lesson.id,
    language: lesson.language,
    languageVersion: lesson.language_version,
    sourceName: parsed.data.sourceName,
    sourceUrl: parsed.data.sourceUrl,
    sampleCode: lesson.code_example,
    expectedOutput: parsed.data.expectedOutput,
  });

  await adminDb.from("ai_verification_logs").insert({
    lesson_id: lesson.id,
    verified_by: auth.user.id,
    programming_language: lesson.language,
    source_name: parsed.data.sourceName,
    source_url: parsed.data.sourceUrl,
    syntax_checked: result.syntaxChecked,
    version_checked: result.versionChecked,
    sandbox_executed: result.sandboxExecuted,
    sandbox_output_matched: result.sandboxOutputMatched,
    status: result.status,
    notes: result.notes,
  });

  if (result.status === "verified") {
    await adminDb
      .from("lessons")
      .update({
        verification_status: "verified",
        last_verified_at: new Date().toISOString(),
      })
      .eq("id", lesson.id);

    await adminDb.from("lesson_sources").insert({
      lesson_id: lesson.id,
      source_name: parsed.data.sourceName,
      source_url: parsed.data.sourceUrl,
      programming_language: lesson.language,
      version: lesson.language_version,
      last_verified_date: new Date().toISOString().slice(0, 10),
      verification_status: "verified",
      notes: result.notes,
    });
  } else {
    await adminDb
      .from("lessons")
      .update({ verification_status: result.status })
      .eq("id", lesson.id);
  }

  return NextResponse.json({ result });
}
