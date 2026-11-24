import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";

const createCourseSchema = z.object({
  slug: z.string().trim().min(2).max(100).regex(/^[a-z0-9-]+$/),
  title: z.string().trim().min(2).max(200),
  language: z.enum(["c", "python"]),
  description: z.string().trim().min(5).max(1000),
  difficulty: z.enum(["beginner", "intermediate", "advanced"]).default("beginner"),
  is_published: z.boolean().default(true),
  sort_order: z.number().int().default(0),
});

const updateCourseSchema = createCourseSchema.partial().extend({
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

export async function GET() {
  const guard = await requireAdminApi();
  if (guard.error) return guard.error;

  const adminDb = createServiceRoleClient();
  const { data, error } = await adminDb
    .from("courses")
    .select("*, chapters(id, title, slug, sort_order, is_published)")
    .order("sort_order", { ascending: true });

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ courses: data });
}

export async function POST(request: NextRequest) {
  const guard = await requireAdminApi();
  if (guard.error) return guard.error;

  const body = await request.json().catch(() => null);
  const parsed = createCourseSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu khóa học không hợp lệ", details: parsed.error.flatten() }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();
  const { data, error } = await adminDb.from("courses").insert(parsed.data).select("*").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ course: data }, { status: 201 });
}

export async function PATCH(request: NextRequest) {
  const guard = await requireAdminApi();
  if (guard.error) return guard.error;

  const body = await request.json().catch(() => null);
  const parsed = updateCourseSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu cập nhật không hợp lệ" }, { status: 400 });
  }

  const { id, ...fields } = parsed.data;
  const adminDb = createServiceRoleClient();
  const { data, error } = await adminDb.from("courses").update(fields).eq("id", id).select("*").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ course: data });
}
