import Link from "next/link";
import { BookOpen, CheckCircle2, Code2, ShieldCheck, Sparkles, Terminal } from "lucide-react";

export default function HomePage() {
  return (
    <div className="min-h-screen bg-white text-slate-900">
      <header className="sticky top-0 z-30 border-b border-slate-200 bg-white/90 backdrop-blur">
        <div className="mx-auto flex max-w-6xl items-center justify-between px-6 py-4">
          <Link href="/" className="flex items-center gap-2.5 font-bold text-indigo-600">
            <Code2 className="h-6 w-6" />
            <span className="text-lg tracking-tight text-slate-900">Learn Code With Me</span>
          </Link>
          <div className="flex items-center gap-3">
            <Link
              href="/login"
              className="rounded-lg px-4 py-2 text-sm font-medium text-slate-700 hover:bg-slate-100"
            >
              Đăng nhập
            </Link>
            <Link
              href="/register"
              className="rounded-lg bg-indigo-600 px-4 py-2 text-sm font-medium text-white shadow-sm hover:bg-indigo-700"
            >
              Bắt đầu miễn phí
            </Link>
          </div>
        </div>
      </header>

      <main>
        <section className="mx-auto max-w-6xl px-6 py-20 text-center">
          <div className="mx-auto mb-6 inline-flex items-center gap-2 rounded-full border border-indigo-200 bg-indigo-50 px-4 py-1.5 text-xs font-semibold text-indigo-700">
            <ShieldCheck className="h-4 w-4" />
            Kiến thức xác minh từ ISO C / GNU C &amp; Python Docs chính thống
          </div>
          <h1 className="mx-auto max-w-3xl text-4xl font-extrabold tracking-tight text-slate-900 sm:text-5xl">
            Học lập trình <span className="text-indigo-600">C</span> và{" "}
            <span className="text-violet-600">Python</span> từ con số 0 bằng thực hành thật
          </h1>
          <p className="mx-auto mt-6 max-w-2xl text-lg text-slate-600">
            Lộ trình bài bản gồm 15 chương C và 17 chương Python. Chạy code thật trên sandbox an
            toàn, hoàn thành bài tập sau mỗi bài học và hỏi đáp trực tiếp cùng AI Teaching Assistant
            không bịa đặt.
          </p>
          <div className="mt-8 flex flex-wrap items-center justify-center gap-4">
            <Link
              href="/register"
              className="rounded-xl bg-indigo-600 px-6 py-3 text-base font-semibold text-white shadow-md hover:bg-indigo-700"
            >
              Tạo tài khoản học ngay
            </Link>
            <Link
              href="/login"
              className="rounded-xl border border-slate-300 bg-white px-6 py-3 text-base font-semibold text-slate-700 hover:bg-slate-50"
            >
              Vào Dashboard học tập
            </Link>
          </div>
        </section>

        <section className="border-t border-slate-200 bg-slate-50 py-16">
          <div className="mx-auto grid max-w-6xl gap-6 px-6 md:grid-cols-3">
            <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
              <Terminal className="h-8 w-8 text-indigo-600" />
              <h3 className="mt-4 text-lg font-bold">Chấm bài thực thi thật</h3>
              <p className="mt-2 text-sm text-slate-600">
                Biên dịch C (GCC) và chạy Python trực tiếp trên sandbox cô lập với bộ test case
                công khai &amp; ẩn. Không bao giờ giả lập kết quả.
              </p>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
              <CheckCircle2 className="h-8 w-8 text-emerald-600" />
              <h3 className="mt-4 text-lg font-bold">Bài tập bắt buộc sau mỗi bài</h3>
              <p className="mt-2 text-sm text-slate-600">
                Mỗi bài học đều đi kèm Coding Exercise hoặc Theory Quiz đúng 5 câu hỏi để đảm bảo
                bạn thực sự nắm vững kiến thức trước khi đi tiếp.
              </p>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
              <Sparkles className="h-8 w-8 text-violet-600" />
              <h3 className="mt-4 text-lg font-bold">AI Teacher có nguồn kiểm chứng</h3>
              <p className="mt-2 text-sm text-slate-600">
                Trợ lý AI giải thích theo từng dòng code, gợi ý sửa lỗi theo trình độ cá nhân và
                luôn đối chiếu với tài liệu chính thống.
              </p>
            </div>
          </div>
        </section>

        <section className="mx-auto max-w-6xl px-6 py-16">
          <div className="grid gap-8 md:grid-cols-2">
            <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
              <div className="flex items-center gap-3">
                <span className="rounded-lg bg-indigo-100 px-3 py-1 text-sm font-bold text-indigo-700">
                  C Programming
                </span>
                <span className="text-xs font-medium text-slate-500">15 chương chuẩn hóa</span>
              </div>
              <h2 className="mt-4 text-2xl font-bold">Learn C Programming</h2>
              <p className="mt-2 text-sm text-slate-600">
                Từ Introduction to C, Variables, Control Flow, Functions, Arrays, Strings cho đến
                Pointers, Memory Management, Structures, File Handling, Recursion và Algorithms.
              </p>
              <Link
                href="/courses/learn-c"
                className="mt-6 inline-flex items-center gap-2 text-sm font-semibold text-indigo-600 hover:text-indigo-700"
              >
                <BookOpen className="h-4 w-4" />
                Xem lộ trình khóa C →
              </Link>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-white p-8 shadow-sm">
              <div className="flex items-center gap-3">
                <span className="rounded-lg bg-violet-100 px-3 py-1 text-sm font-bold text-violet-700">
                  Python 3
                </span>
                <span className="text-xs font-medium text-slate-500">17 chương chuẩn hóa</span>
              </div>
              <h2 className="mt-4 text-2xl font-bold">Learn Python Programming</h2>
              <p className="mt-2 text-sm text-slate-600">
                Từ cơ bản đến Lists, Dictionaries, File &amp; Exception Handling, OOP, Modules,
                Python Standard Library, Working with APIs và Basic Data Analysis.
              </p>
              <Link
                href="/courses/learn-python"
                className="mt-6 inline-flex items-center gap-2 text-sm font-semibold text-violet-600 hover:text-violet-700"
              >
                <BookOpen className="h-4 w-4" />
                Xem lộ trình khóa Python →
              </Link>
            </div>
          </div>
        </section>
      </main>
    </div>
  );
}
