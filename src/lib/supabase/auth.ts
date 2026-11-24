import { redirect } from "next/navigation";
import { createServerSupabaseClient } from "@/lib/supabase/server";
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

  const { data: profile } = await supabase
    .from("profiles")
    .select("*")
    .eq("id", user.id)
    .single();

  return {
    user: { id: user.id, email: user.email ?? "" },
    profile: (profile as Profile | null) ?? null,
  };
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
