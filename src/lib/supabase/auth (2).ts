import { redirect } from "next/navigation";
import { createServerSupabaseClient, createServiceRoleClient } from "@/lib/supabase/server";
import type { Profile } from "@/types/database";

export async function getCurrentUserWithProfile(): Promise<{
  user: { id: string; email: string } | null;
  profile: Profile | null;
  errorMessage?: string;
}> {
  const supabase = await createServerSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return { user: null, profile: null };
  }

  // First try reading via authenticated user client
  const { data: userProfile, error: userErr } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .maybeSingle();

  if (userProfile) {
    return {
      user: { id: user.id, email: user.email ?? "" },
      profile: userProfile as Profile,
    };
  }

  // Fallback: read or auto-provision via server-only service_role client (after user.id is verified by auth.getUser())
  try {
    const adminDb = createServiceRoleClient();
    const { data: adminProfile } = await adminDb
      .from("profiles")
      .select("*")
      .eq("id", user.id)
      .maybeSingle();

    if (adminProfile) {
      return {
        user: { id: user.id, email: user.email ?? "" },
        profile: adminProfile as Profile,
      };
    }

    const email = user.email ?? "";
    const fullName =
      (typeof user.user_metadata?.full_name === "string" && user.user_metadata.full_name.trim()) ||
      email.split("@")[0] ||
      "Học viên";

    const { data: created, error: createErr } = await adminDb
      .from("profiles")
      .upsert(
        {
          id: user.id,
          email,
          full_name: fullName,
          role: "USER",
        },
        { onConflict: "id" }
      )
      .select("*")
      .single();

    if (created) {
      return {
        user: { id: user.id, email },
        profile: created as Profile,
      };
    }

    return {
      user: { id: user.id, email },
      profile: null,
      errorMessage: createErr?.message || userErr?.message || "Không thể tải hoặc tạo hồ sơ người dùng.",
    };
  } catch (err) {
    return {
      user: { id: user.id, email: user.email ?? "" },
      profile: null,
      errorMessage:
        (err instanceof Error ? err.message : null) ||
        userErr?.message ||
        "Lỗi kết nối Supabase khi tải hồ sơ.",
    };
  }
}

/**
 * Server-component guard requiring an authenticated user.
 */
export async function requireAuth(): Promise<{
  user: { id: string; email: string };
  profile: Profile;
}> {
  const { user, profile, errorMessage } = await getCurrentUserWithProfile();
  if (!user) {
    redirect("/login");
  }
  if (!profile) {
    const detail = encodeURIComponent(errorMessage || "profile_missing");
    redirect(`/login?error=profile_load_failed&detail=${detail}`);
  }
  return { user, profile };
}

/**
 * Server-component guard strictly requiring ADMIN role verified from database.
 */
export async function requireAdmin(): Promise<{
  user: { id: string; email: string };
  profile: Profile;
}> {
  const { user, profile } = await requireAuth();
  if (profile.role !== "ADMIN") {
    redirect("/dashboard");
  }
  return { user, profile };
}

/**
 * API route guard returning authenticated user + profile or null (caller returns 401/403).
 */
export async function getApiAuth(): Promise<{
  user: { id: string; email: string };
  profile: Profile;
} | null> {
  const { user, profile } = await getCurrentUserWithProfile();
  if (!user || !profile) return null;
  return { user, profile };
}
