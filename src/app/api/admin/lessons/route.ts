import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";

const createLessonSchema = z.object({
  course_id: z.string().uuid(),
  chapter_id: z.string().uuid(),
  slug: z.string().trim().min(2).max(140).regex(/^[a-z0-9-]+$/),
  title: z.string().trim().min(2).max(200),
  summary: z.string().trim().max(500).default(""),
  content_markdown: z.string().trim().min(10),
  code_example: z.string().default(""),
  code_explanation: z.string().default(""),
  common_mistakes: z.string().default(""),
  key_takeaways: z.string().default(""),
  language: z.enum(["c", "python"]),
  language_version: z.string().trim().min(2).max(60).default("C11 / GCC 12"),
  difficulty: z.enum(["beginner", "intermediate", "advanced"]).default("beginner"),
  estimated_minutes: z.number().int().min(1).max(180).default(15),
  sort_order: z.number().int().default(1),
  is_published: z.boolean().default(false),
});

const updateLessonSchema = createLessonSchema.partial().extend({
  id: z.string().uuid(),
});

async function requireAdminApi() {
  const auth = await getApiAuth();
  if (!auth) return { error: NextResponse.json({ error: "Unauthorized" }, { status: 401 }) };
  if (auth.profile.role !== "ADMIN") {
    return { error: NextResponse.json({ error: "Forbidden" }, { status: 403 }) };
  }
  return { auth };
}

export async function POST(request: NextRequest) {
  const guard = await requireAdminApi();
  if (guard.error) return guard.error;

  const body = await request.json().catch(() => null);
  const parsed = createLessonSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu bài học không hợp lệ", details: parsed.error.flatten() }, { status: 400 });
  }

  // New lessons start as 'pending' until verified by the Verified Knowledge pipeline
  const adminDb = createServiceRoleClient();
  const { data, error } = await adminDb
    .from("lessons")
    .insert({ ...parsed.data, verification_status: "pending" })
    .select("*")
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ lesson: data }, { status: 201 });
}

export async function PATCH(request: NextRequest) {
  const guard = await requireAdminApi();
  if (guard.error) return guard.error;

  const body = await request.json().catch(() => null);
  const parsed = updateLessonSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu cập nhật bài học không hợp lệ" }, { status: 400 });
  }

  const { id, ...fields } = parsed.data;
  const adminDb = createServiceRoleClient();

  // If content or code changed, mark status as needs_review so verified content is never silently altered
  const contentEdited =
    fields.content_markdown !== undefined || fields.code_example !== undefined;

  const updatePayload = contentEdited
    ? { ...fields, verification_status: "needs_review" as const }
    : fields;

  const { data, error } = await adminDb
    .from("lessons")
    .update(updatePayload)
    .eq("id", id)
    .select("*")
    .single();

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ lesson: data });
}
