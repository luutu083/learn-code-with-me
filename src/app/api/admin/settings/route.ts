import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";

const settingsSchema = z.object({
  allow_skip_exercises: z.boolean(),
});

export async function GET() {
  const auth = await getApiAuth();
  if (!auth) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  if (auth.profile.role !== "ADMIN") return NextResponse.json({ error: "Forbidden" }, { status: 403 });

  const adminDb = createServiceRoleClient();
  const { data } = await adminDb
    .from("platform_settings")
    .select("key, value")
    .eq("key", "allow_skip_exercises")
    .maybeSingle();

  return NextResponse.json({
    allow_skip_exercises: Boolean(data?.value === true || data?.value === "true"),
  });
}

export async function PATCH(request: NextRequest) {
  const auth = await getApiAuth();
  if (!auth) return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  if (auth.profile.role !== "ADMIN") return NextResponse.json({ error: "Forbidden" }, { status: 403 });

  const body = await request.json().catch(() => null);
  const parsed = settingsSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Cấu hình không hợp lệ." }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();
  const { error } = await adminDb.from("platform_settings").upsert({
    key: "allow_skip_exercises",
    value: parsed.data.allow_skip_exercises,
    updated_by: auth.user.id,
    updated_at: new Date().toISOString(),
  });

  if (error) return NextResponse.json({ error: error.message }, { status: 500 });
  return NextResponse.json({ allow_skip_exercises: parsed.data.allow_skip_exercises });
}
