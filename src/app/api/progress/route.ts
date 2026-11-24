import { NextRequest, NextResponse } from "next/server";
import { z } from "zod";
import { getApiAuth } from "@/lib/supabase/auth";
import { createServiceRoleClient } from "@/lib/supabase/server";

const heartbeatSchema = z.object({
  courseId: z.string().uuid(),
  lessonId: z.string().uuid(),
  deltaSeconds: z.number().int().min(5).max(300),
});

/**
 * Updates user's time spent on a lesson and maintains daily learning streak on server.
 * Cannot be used to forge lesson completion or scores.
 */
export async function POST(request: NextRequest) {
  const auth = await getApiAuth();
  if (!auth) {
    return NextResponse.json({ error: "Unauthorized" }, { status: 401 });
  }

  const body = await request.json().catch(() => null);
  const parsed = heartbeatSchema.safeParse(body);
  if (!parsed.success) {
    return NextResponse.json({ error: "Invalid payload" }, { status: 400 });
  }

  const adminDb = createServiceRoleClient();
  const { courseId, lessonId, deltaSeconds } = parsed.data;

  const { data: existing } = await adminDb
    .from("lesson_progress")
    .select("id, time_spent_seconds")
    .eq("user_id", auth.user.id)
    .eq("lesson_id", lessonId)
    .maybeSingle();

  if (existing) {
    await adminDb
      .from("lesson_progress")
      .update({
        time_spent_seconds: (existing.time_spent_seconds || 0) + deltaSeconds,
        last_accessed_at: new Date().toISOString(),
      })
      .eq("id", existing.id);
  } else {
    await adminDb.from("lesson_progress").insert({
      user_id: auth.user.id,
      course_id: courseId,
      lesson_id: lessonId,
      time_spent_seconds: deltaSeconds,
      last_accessed_at: new Date().toISOString(),
    });
  }

  // Update daily streak safely on server
  const today = new Date().toISOString().slice(0, 10);
  const lastDate = auth.profile.last_active_date;
  if (lastDate !== today) {
    const yesterday = new Date(Date.now() - 86_400_000).toISOString().slice(0, 10);
    const nextStreak = lastDate === yesterday ? auth.profile.current_streak_days + 1 : 1;
    const longest = Math.max(auth.profile.longest_streak_days, nextStreak);

    await adminDb
      .from("profiles")
      .update({
        current_streak_days: nextStreak,
        longest_streak_days: longest,
        last_active_date: today,
      })
      .eq("id", auth.user.id);
  }

  return NextResponse.json({ ok: true });
}
