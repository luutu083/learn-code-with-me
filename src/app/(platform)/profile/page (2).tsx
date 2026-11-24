import { requireAuth } from "@/lib/supabase/auth";
import { ProfileForm } from "@/components/profile/profile-form";

export default async function ProfilePage() {
  const { profile } = await requireAuth();

  return (
    <div className="space-y-6">
      <div>
        <h1 className="text-2xl font-bold text-slate-900">Hồ sơ cá nhân</h1>
        <p className="text-sm text-slate-500">Cập nhật thông tin tài khoản và lộ trình ưu tiên của bạn</p>
      </div>
      <ProfileForm profile={profile} />
    </div>
  );
}
