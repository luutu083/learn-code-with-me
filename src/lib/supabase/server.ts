import { createServerClient } from "@supabase/ssr";
import { createClient as createSupabaseClient } from "@supabase/supabase-js";
import { cookies } from "next/headers";
import { getPublicSupabaseEnv, getServiceRoleKey } from "@/lib/env";

export async function createServerSupabaseClient() {
  const cookieStore = await cookies();
  const { url, anonKey } = getPublicSupabaseEnv();

  return createServerClient(url, anonKey, {
    cookies: {
      getAll() {
        return cookieStore.getAll();
      },
      setAll(cookiesToSet) {
        try {
          cookiesToSet.forEach(({ name, value, options }) =>
            cookieStore.set(name, value, options)
          );
        } catch {
          // Ignored when called from a Server Component where cookies are read-only
        }
      },
    },
  });
}

/**
 * Server-only privileged Supabase client using SUPABASE_SERVICE_ROLE_KEY.
 * MUST ONLY be called after verifying user identity / ADMIN role on the server.
 */
export function createServiceRoleClient() {
  const { url } = getPublicSupabaseEnv();
  const serviceKey = getServiceRoleKey();
  return createSupabaseClient(url, serviceKey, {
    auth: {
      autoRefreshToken: false,
      persistSession: false,
    },
  });
}
