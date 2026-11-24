import { redirect } from "next/navigation";
import { createServerSupabaseClient, createServiceRoleClient } from "@/lib/supabase/server";
import type { Profile } from "@/types/database";

export async function getCurrentUserWithProfile(): Promise<{
  user: { id: string; email: string } | null;
  profile: Profile | null;
}> {
  const supabase = await createServerSupabaseClient();
  const {
    data: { user },
  } = await supabase.auth.getUser();

  if (!user) {
    return { user: null, profile: null };
  }

  const { data: existingProfile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .maybeSingle();

  if (existingProfile) {
    return {
      user: { id: user.id, email: user.email ?? "" },
      profile: existingProfile as Profile,
    };
  }

  // Fallback: auto-create profile if auth user exists before trigger ran (prevents /dashboard <-> /login redirect loop)
  try {
    const adminDb = createServiceRoleClient();
    const email = user.email ?? "";
    const fullName =
      (typeof user.user_metadata?.full_name === "string" && user.user_metadata.full_name.trim()) ||
      email.split("@")[0] ||
      "Học viên";

    const { data: created } = await adminDb
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

    return {
      user: { id: user.id, email },
      profile: (created as Profile | null) ?? null,
    };
  } catch {
    return {
      user: { id: user.id, email: user.email ?? "" },
      profile: null,
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
  const { user, profile } = await getCurrentUserWithProfile();
  if (!user || !profile) {
    redirect("/login");
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
