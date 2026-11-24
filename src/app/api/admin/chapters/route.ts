import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";

const chapterSchema = z.object({
  course_id: z.string().uuid(),
  slug: z.string().trim().min(2).max(120).regex(/^[a-z0-9-]+$/),
  title: z.string().trim().min(2).max(200),
  description: z.string().trim().max(1000).default(""),
  sort_order: z.number().int().default(1),
  is_published: z.boolean().default(true),
});

export async function POST(request: NextRequest) {
  const auth = await getApiAuth();
  if (!auth) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  if (auth.profile.role !== "ADMIN") return NextResponse.json({ error: "Forbidden" }, { status: 403 });

  const body = await request.json().catch(() => null);
  const parsed = chapterSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Dữ liệu chương học không hợp lệ", details: parsed.error.flatten() }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();
  const { data, error } = await adminDb.from("chapters").insert(parsed.data).select("*").single();
  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ chapter: data }, { status: 201 });
}
