import { GoogleGenerativeAI } from "@google/generative-ai";
import { getGeminiConfig } from "@/lib/env";
import type { Lesson, LessonSource, ProgrammingLanguage } from "@/types/database";

export const UNVERIFIED_FALLBACK_MESSAGE =
  "Chưa đủ dữ liệu đáng tin cậy để xác minh nội dung này.";

export interface AiTeacherContext {
  lesson: Pick<
    Lesson,
    "title" | "language" | "language_version" | "difficulty" | "content_markdown" | "code_example" | "common_mistakes"
  >;
  sources: Pick<LessonSource, "source_name" | "source_url" | "version" | "verification_status">[];
  userLevelSummary: string;
  recentErrors: string[];
  userCode?: string;
  question: string;
}

export interface AiTeacherReply {
  configured: boolean;
  answer: string;
  verifiedSourcesUsed: { name: string; url: string; version: string }[];
  containsUnverifiedNotice: boolean;
}

export async function askAiTeacher(ctx: AiTeacherContext): Promise<AiTeacherReply> {
  const cfg = getGeminiConfig();
  const verifiedSources = ctx.sources.filter((s) => s.verification_status === "verified");

  if (!cfg.configured) {
    return {
      configured: false,
      answer:
        "AI Teaching Assistant (Gemini API) chưa được cấu hình (thiếu GEMINI_API_KEY trong biến môi trường). Vui lòng thêm GEMINI_API_KEY vào .env.local hoặc Vercel Environment Variables để sử dụng tính năng hỏi đáp AI.",
      verifiedSourcesUsed: verifiedSources.map((s) => ({
        name: s.source_name,
        url: s.source_url,
        version: s.version,
      })),
      containsUnverifiedNotice: false,
    };
  }

  const genAI = new GoogleGenerativeAI(cfg.apiKey);
  const model = genAI.getGenerativeModel({ model: cfg.model });

  const sourcesBlock =
    verifiedSources.length > 0
      ? verifiedSources
          .map((s) => `- ${s.source_name} (${s.version}): ${s.source_url}`)
          .join("\n")
      : "KHÔNG CÓ NGUỒN ĐÃ XÁC MINH CHO BÀI HỌC NÀY.";

  const systemPrompt = `Bạn là AI Programming Teacher của nền tảng Learn Code With Me, chuyên dạy lập trình ${ctx.lesson.language.toUpperCase()} (${ctx.lesson.language_version}) cho người mới bắt đầu.

NGUYÊN TẮC BẮT BUỘC CHỐNG BỊA ĐẶT:
1. Chỉ sử dụng cú pháp, hàm chuẩn và kiến thức có thật trong tiêu chuẩn ${ctx.lesson.language.toUpperCase()} (${ctx.lesson.language_version}) và các nguồn đã xác minh bên dưới.
2. TUYỆT ĐỐI KHÔNG tự tạo URL, không bịa tên hàm/thư viện, không khẳng định "đã xác minh" nếu nguồn không nằm trong danh sách nguồn dưới đây.
3. Nếu câu hỏi nằm ngoài kiến thức đã xác minh hoặc bạn không chắc chắn về độ chính xác theo tài liệu chính thống, bắt buộc phải trả lời chính xác câu sau ở đầu phản hồi: "${UNVERIFIED_FALLBACK_MESSAGE}"
4. Phân biệt rõ: thông tin từ bài học/tài liệu đã xác minh và các gợi ý thực hành.
5. Nếu người học hỏi về bài tập đang làm, hãy giải thích nguyên nhân lỗi và gợi ý hướng sửa — KHÔNG tự động tiết lộ toàn bộ đáp án hoàn chỉnh trừ khi họ chỉ hỏi giải thích khái niệm.
6. Dạy dễ hiểu, không giả định người học đã biết lập trình trước đó, giải thích từng dòng code khi cần.

NGUỒN TÀI LIỆU ĐÃ XÁC MINH CHO BÀI NÀY:
${sourcesBlock}

THÔNG TIN NGƯỜI HỌC:
${ctx.userLevelSummary}
Các lỗi người học thường gặp gần đây: ${ctx.recentErrors.length > 0 ? ctx.recentErrors.join("; ") : "Chưa ghi nhận lỗi lặp lại."}

NỘI DUNG BÀI HỌC HIỆN TẠI (${ctx.lesson.title}):
${ctx.lesson.content_markdown.slice(0, 3500)}

VÍ DỤ CODE TRONG BÀI:
\`\`\`${ctx.lesson.language}
${ctx.lesson.code_example.slice(0, 1500)}
\`\`\`
`;

  const userPrompt = ctx.userCode
    ? `Câu hỏi của học viên: ${ctx.question}\n\nĐoạn code hiện tại của học viên:\n\`\`\`${ctx.lesson.language}\n${ctx.userCode.slice(0, 3000)}\n\`\`\``
    : `Câu hỏi của học viên: ${ctx.question}`;

  try {
    const result = await model.generateContent([systemPrompt, userPrompt]);
    const text = result.response.text().trim() || UNVERIFIED_FALLBACK_MESSAGE;

    return {
      configured: true,
      answer: text,
      verifiedSourcesUsed: verifiedSources.map((s) => ({
        name: s.source_name,
        url: s.source_url,
        version: s.version,
      })),
      containsUnverifiedNotice: text.includes(UNVERIFIED_FALLBACK_MESSAGE),
    };
  } catch (err) {
    return {
      configured: true,
      answer: `Không thể kết nối đến Gemini API: ${err instanceof Error ? err.message : "Unknown error"}. ${UNVERIFIED_FALLBACK_MESSAGE}`,
      verifiedSourcesUsed: [],
      containsUnverifiedNotice: true,
    };
  }
}

export function buildLearnerLevelSummary(params: {
  completedLessons: number;
  avgQuizScore: number;
  avgCodingScore: number;
  language: ProgrammingLanguage;
}): string {
  const { completedLessons, avgQuizScore, avgCodingScore, language } = params;
  const level =
    completedLessons < 3 || avgCodingScore < 60
      ? "Mới bắt đầu (cần giải thích rất cơ bản, từng bước)"
      : completedLessons < 10
        ? "Cơ bản vững (có thể kết hợp ví dụ thực tế)"
        : "Trung cấp (có thể đi sâu vào edge cases và tối ưu)";

  return `Ngôn ngữ đang học: ${language.toUpperCase()} | Bài đã hoàn thành: ${completedLessons} | Điểm Quiz TB: ${avgQuizScore}% | Độ chính xác Coding TB: ${avgCodingScore}% | Mức độ gợi ý: ${level}`;
}
