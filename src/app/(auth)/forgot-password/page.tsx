"use client";

import { useState } from "react";
import Link from "next/link";
import { Code2, Loader2 } from "lucide-react";
import { createClient } from "@/lib/supabase/client";
import { Button } from "@/components/ui/button";

export default function ForgotPasswordPage() {
  const [email, setEmail] = useState("");
  const [loading, setLoading] = useState(false);
  const [message, setMessage] = useState<string | null>(null);
  const [error, setError] = useState<string | null>(null);

  async function handleSubmit(e: React.FormEvent) {
    e.preventDefault();
    setLoading(true);
    setError(null);
    setMessage(null);

    const supabase = createClient();
    const { error: resetErr } = await supabase.auth.resetPasswordForEmail(email.trim(), {
      redirectTo: `${window.location.origin}/auth/callback?next=/reset-password`,
    });

    if (resetErr) {
      setError(resetErr.message);
    } else {
      setMessage("Đã gửi liên kết đặt lại mật khẩu đến email của bạn.");
    }
    setLoading(false);
  }

  return (
    <div className="flex min-h-screen items-center justify-center bg-slate-50 px-4">
      <div className="w-full max-w-md rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
        <div className="mb-6 flex flex-col items-center text-center">
          <Link href="/" className="flex items-center gap-2 font-bold text-indigo-600">
            <Code2 className="h-7 w-7" />
            <span className="text-xl text-slate-900">Quên mật khẩu</span>
          </Link>
          <p className="mt-2 text-sm text-slate-500">
            Nhập email tài khoản để nhận liên kết đặt lại mật khẩu
          </p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          {error && <div className="rounded-lg bg-red-50 p-3 text-sm text-red-700">{error}</div>}
          {message && <div className="rounded-lg bg-emerald-50 p-3 text-sm text-emerald-800">{message}</div>}

          <div>
            <label className="mb-1 block text-sm font-medium text-slate-700">Email</label>
            <input
              type="email"
              required
              value={email}
              onChange={(e) => setEmail(e.target.value)}
              className="w-full rounded-lg border border-slate-300 px-3 py-2 text-sm focus:border-indigo-500 focus:outline-none focus:ring-2 focus:ring-indigo-200"
            />
          </div>

          <Button type="submit" disabled={loading} className="w-full">
            {loading ? <Loader2 className="mr-2 h-4 w-4 animate-spin" /> : null}
            Gửi liên kết khôi phục
          </Button>
        </form>

        <p className="mt-6 text-center text-sm text-slate-600">
          <Link href="/login" className="font-semibold text-indigo-600 hover:underline">
            ← Quay lại đăng nhập
          </Link>
        </p>
      </div>
    </div>
  );
}
