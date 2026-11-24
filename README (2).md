# Learn Code With Me — AI-Powered C & Python Programming Education Platform

Nền tảng giáo dục lập trình **C** và **Python** toàn diện dành cho người mới bắt đầu, xây dựng bằng **Next.js (App Router)**, **TypeScript**, **Tailwind CSS**, **Supabase (PostgreSQL + Auth + RLS)**, **Monaco Editor**, **Judge0 Sandboxed Execution**, **Recharts** và **Gemini API**.

## 1. Kiến trúc & Tính năng chính

- **2 Khóa học chuẩn hóa**:
  - **Learn C Programming**: 15 chương từ cơ bản đến nâng cao (Introduction, Variables, I/O, Operators, Conditionals, Loops, Functions, Arrays, Strings, Pointers, Memory Management, Structures & Unions, File Handling, Recursion, Algorithms).
  - **Learn Python Programming**: 17 chương từ cơ bản đến nâng cao (Introduction, Variables, I/O, Operators, Conditionals, Loops, Functions, Lists & Tuples, Dictionaries & Sets, Strings, File Handling, Exception Handling, OOP, Modules & Packages, Standard Library, Working with APIs, Basic Data Analysis).
- **Verified Knowledge System (Chống bịa đặt)**:
  - Mỗi bài giảng lưu metadata nguồn xác minh (`lesson_sources`: tên nguồn, URL chính thống, ngôn ngữ, phiên bản, ngày xác minh, trạng thái).
  - Toàn bộ ví dụ code và test case trong `supabase/seed.sql` đã được biên dịch/chạy kiểm chứng thực tế bằng GCC 12 và Python 3.11.
  - AI Teaching Assistant sử dụng prompt ràng buộc nguồn chính thống, trả về `"Chưa đủ dữ liệu đáng tin cậy để xác minh nội dung này."` nếu không đủ cơ sở.
- **Bài tập bắt buộc sau mỗi bài học**:
  - **Coding Exercise**: Monaco Editor, nút **Test** và **Submit** gọi Judge0 sandbox thực tế, trả về chi tiết từng test case, tỷ lệ %, dòng lỗi compile/runtime và gợi ý không lộ đáp án.
  - **Theory Quiz**: Bắt buộc đúng 5 câu hỏi trắc nghiệm (4 đáp án A–D, 1 đáp án đúng), có nút **Test** và **Submit**, giải thích đáp án và hiểu lầm thường gặp.
  - Học viên không thể nhảy cóc bài tiếp theo nếu chưa đạt bài tập hiện tại (trừ khi Admin bật `allow_skip_exercises` trong `/admin/settings`).
- **Bảo mật & Phân quyền**:
  - Supabase Row Level Security (RLS) trên toàn bộ 15 bảng.
  - Trigger PostgreSQL `prevent_role_escalation` chặn mọi hành vi tự nâng quyền thành `ADMIN` từ client.
  - Chấm điểm, tính streak, lưu submission và kiểm tra quyền Admin thực hiện 100% ở phía server.

## 2. Hướng dẫn cài đặt Local

### Bước 1: Giải nén và cài đặt dependencies
```bash
unzip learn-code-with-me.zip
cd learn-code-with-me
npm install
```

### Bước 2: Thiết lập Supabase (Database & Auth)
1. Tạo dự án mới trên [Supabase](https://supabase.com/).
2. Vào **SQL Editor** và chạy lần lượt 3 file SQL sau:
   - `supabase/migrations/0001_initial_schema.sql`
   - `supabase/migrations/0002_rls_and_functions.sql`
   - `supabase/seed.sql`
3. Vào **Authentication → URL Configuration**:
   - Đặt **Site URL**: `http://localhost:3000` (hoặc domain Vercel khi deploy).
   - Thêm **Redirect URL**: `http://localhost:3000/auth/callback` và `https://<your-domain>.vercel.app/auth/callback`.

### Bước 3: Cấu hình biến môi trường
```bash
cp .env.example .env.local
```
Điền đầy đủ các khóa trong `.env.local`:
- `NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY`, `SUPABASE_SERVICE_ROLE_KEY` (lấy trong Supabase Project Settings → API).
- `JUDGE0_API_URL`, `JUDGE0_API_KEY`, `JUDGE0_RAPIDAPI_HOST` (từ [Judge0 CE trên RapidAPI](https://rapidapi.com/judge0-official/api/judge0-ce) hoặc server Judge0 CE tự host theo [Judge0 CE API Docs](https://ce.judge0.com/)).
- `GEMINI_API_KEY` (từ Google AI Studio).

### Bước 4: Tạo tài khoản Admin đầu tiên
1. Đăng ký một tài khoản bình thường tại `/register`.
2. Trong Supabase SQL Editor, cấp quyền `ADMIN` cho tài khoản đó (chỉ thao tác được từ quyền quản trị database):
```sql
UPDATE public.profiles
SET role = 'ADMIN'
WHERE email = 'admin@yourdomain.com';
```

### Bước 5: Kiểm tra TypeScript & Chạy Local
```bash
npm run typecheck
npm run build
npm run dev
```
Truy cập `http://localhost:3000` và kiểm tra `/api/health` để xác nhận trạng thái cấu hình của Supabase, Judge0 và Gemini.

## 3. Hướng dẫn Deploy lên Vercel

1. Đẩy thư mục dự án lên GitHub/GitLab/Bitbucket.
2. Truy cập [Vercel Dashboard](https://vercel.com/new) và import repository.
3. Trong mục **Environment Variables**, khai báo toàn bộ các biến từ `.env.example` (nhớ cập nhật `NEXT_PUBLIC_APP_URL` thành URL production `https://<your-project>.vercel.app`).
4. Nhấn **Deploy** (hoặc chạy `npx vercel --prod` nếu bạn đã đăng nhập Vercel CLI trên máy cá nhân).
5. Cập nhật Redirect URL trong Supabase Auth thành `https://<your-project>.vercel.app/auth/callback`.
