export function getPublicSupabaseEnv() {
  const url = process.env.NEXT_PUBLIC_SUPABASE_URL;
  const anonKey = process.env.NEXT_PUBLIC_SUPABASE_ANON_KEY;
  if (!url || !anonKey) {
    throw new Error(
      "Thiếu biến môi trường NEXT_PUBLIC_SUPABASE_URL hoặc NEXT_PUBLIC_SUPABASE_ANON_KEY. Vui lòng kiểm tra .env.local."
    );
  }
  return { url, anonKey };
}

export function getServiceRoleKey(): string {
  const key = process.env.SUPABASE_SERVICE_ROLE_KEY;
  if (!key) {
    throw new Error(
      "Thiếu biến môi trường SUPABASE_SERVICE_ROLE_KEY ở phía server."
    );
  }
  return key;
}

export function getJudge0Config() {
  const apiUrl = process.env.JUDGE0_API_URL?.trim();
  const apiKey = process.env.JUDGE0_API_KEY?.trim();
  const rapidApiHost = process.env.JUDGE0_RAPIDAPI_HOST?.trim();
  const cLanguageId = Number(process.env.JUDGE0_C_LANGUAGE_ID || "50");
  const pythonLanguageId = Number(process.env.JUDGE0_PYTHON_LANGUAGE_ID || "71");
  const cpuTimeLimit = Number(process.env.JUDGE0_CPU_TIME_LIMIT || "2.0");
  const memoryLimitKb = Number(process.env.JUDGE0_MEMORY_LIMIT_KB || "128000");

  const isRapidApi = Boolean(apiUrl && apiUrl.includes("rapidapi.com"));
  const configured = Boolean(apiUrl && (!isRapidApi || apiKey));

  return {
    configured,
    apiUrl: apiUrl || "",
    apiKey: apiKey || "",
    rapidApiHost: rapidApiHost || "",
    isRapidApi,
    cLanguageId,
    pythonLanguageId,
    cpuTimeLimit,
    memoryLimitKb,
  };
}

export function getGeminiConfig() {
  const apiKey = process.env.GEMINI_API_KEY?.trim() || "";
  const model = process.env.GEMINI_MODEL?.trim() || "gemini-2.5-flash";
  return {
    configured: Boolean(apiKey),
    apiKey,
    model,
  };
}
