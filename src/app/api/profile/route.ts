import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServerSupabaseClient } from "@/lib/supabase/server";

const updateProfileSchema = z.object({
  full_name: z.string().trim().min(1, "Họ tên không được để trống").max(100),
  preferred_language: z.enum(["c", "python"]).optional(),
  bio: z.string().trim().max(500).optional(),
});

export async function GET() {
  const auth = await getApiAuth();
  if (!auth) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }
  return NextResponse.json({ profile: auth.profile });
}

export async function PATCH(request: NextRequest) {
  const auth = await getApiAuth();
  if (!auth) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json().catch(() => null);
  const parsed = updateProfileSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json(
      { error: "Dữ liệu không hợp lệ", details: parsed.error.flatten() },
      { status: 400 }
    );
  }

  // Security: Explicitly whitelist allowed fields — never accept `role` from client!
  const supabase = await createServerSupabaseClient();
  const { data, error } = await supabase
    .from("profiles")
    .update({
      full_name: parsed.data.full_name,
      preferred_language: parsed.data.preferred_language ?? auth.profile.preferred_language,
      bio: parsed.data.bio ?? auth.profile.bio,
    })
    .eq("id", auth.user.id)
    .select("*")
    .single();

  if (error) {
    return NextResponse.json({ error: error.message }, { status: 500 });
  }

  return NextResponse.json({ profile: data });
}
