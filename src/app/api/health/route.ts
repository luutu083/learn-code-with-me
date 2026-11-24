import { NextResponse } from "next/server";
import { getGeminiConfig, getJudge0Config } from "@/lib/env";

export async function GET() {
  const judge0 = getJudge0Config();
  const gemini = getGeminiConfig();
  const supabaseConfigured = Boolean(
    process.env.NEXT_PUBLIC_SUPABASE_URL &&
      process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY &&
      process.env.SUPABASE_SERVICE_ROLE_KEY
  );

  return NextResponse.json({
    status: "ok",
    timestamp: new Date().toISOString(),
    services: {
      supabase: { configured: supabaseConfigured },
      judge0: { configured: judge0.configured },
      gemini: { configured: gemini.configured, model: gemini.model },
    },
  });
}
