-- ============================================================================
-- Learn Code With Me — Verified Curriculum Seed Data (C: 15 ch, Python: 17 ch)
-- Generated & 100% verified by real GCC 12.2 & Python 3.11 execution
-- ============================================================================

INSERT INTO public.courses (id, slug, title, language, description, difficulty, is_published, sort_order) VALUES ('7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'learn-c', 'Learn C Programming', 'c', 'Lộ trình học lập trình C chuẩn hóa gồm 15 chương từ cơ bản đến con trỏ, quản lý bộ nhớ và thuật toán.', 'beginner', TRUE, 1), ('fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'learn-python', 'Learn Python Programming', 'python', 'Lộ trình học Python 3 thực chiến gồm 17 chương từ cú pháp cơ bản đến OOP, API và phân tích dữ liệu.', 'beginner', TRUE, 2) ON CONFLICT (slug) DO NOTHING;

INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('fc7fb222-1d42-5997-ad8b-8fcd0eb1991d', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch01', 'Introduction to Programming and C', 'Cấu trúc chương trình C chuẩn, hàm main(), #include <stdio.h> và quy trình biên dịch GCC.', 1, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('af694c10-3c7d-5e87-aeb5-f839f0980d9d', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'fc7fb222-1d42-5997-ad8b-8fcd0eb1991d', 'c-ch01-lesson-1', 'Chương trình C đầu tiên và cấu trúc hàm main()', 'Hiểu cách trình biên dịch GCC chuyển mã nguồn C thành chương trình thực thi và cách dùng printf.', 'Ngôn ngữ C là ngôn ngữ lập trình biên dịch. Mọi chương trình C chuẩn đều bắt đầu thực thi từ hàm `int main(void)`. Để in văn bản ra màn hình, ta nạp thư viện chuẩn `<stdio.h>` và gọi hàm `printf()`.', '#include <stdio.h>

int main(void) {
    printf("Hello, Learn Code With Me!\n");
    return 0;
}
', '- Dòng 1: `#include <stdio.h>` nạp khai báo hàm `printf` từ thư viện chuẩn I/O.
- Dòng 3: `int main(void)` là điểm vào chính của chương trình, trả về số nguyên.
- Dòng 4: `printf(...)` in chuỗi kèm ký tự xuống dòng `\n`.
- Dòng 5: `return 0;` báo cho hệ điều hành chương trình kết thúc thành công.', '- Quên dấu chấm phẩy `;` ở cuối câu lệnh.
- Quên `#include <stdio.h>` khiến trình biên dịch cảnh báo implicit declaration.
- Dùng nháy đơn `''...''` thay vì nháy kép `"..."` cho chuỗi ký tự.', 'Mọi câu lệnh C kết thúc bằng `;`, hàm `main` trả về `0` khi thành công, và `stdio.h` cung cấp `printf`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('4120454c-a21d-5efa-a5df-0f960ce7df56', 'af694c10-3c7d-5e87-aeb5-f839f0980d9d', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('de99109f-f352-5897-ba71-6d6bd73d4917', 'af694c10-3c7d-5e87-aeb5-f839f0980d9d', 'In lời chào chuẩn bằng C', 'coding', 'Viết chương trình C in ra đúng một dòng:
Welcome to C Programming', 'c', '#include <stdio.h>

int main(void) {
    // Viết lệnh printf tại đây
    return 0;
}
', '#include <stdio.h>

int main(void) {
    printf("Welcome to C Programming\n");
    return 0;
}
', '', 'Welcome to C Programming', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('aee10f97-7006-59c2-a465-78a64c925f5b', 'de99109f-f352-5897-ba71-6d6bd73d4917', 'Kiểm tra đầu ra chuẩn', '', 'Welcome to C Programming', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('c9e909ca-46d1-57fd-a317-d749ffe4e999', 'de99109f-f352-5897-ba71-6d6bd73d4917', 'Kiểm tra không có ký tự thừa', '', 'Welcome to C Programming', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('b32787ff-94db-5cfd-9de0-06a1cda5ad1e', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch02', 'Variables and Data Types', 'Các kiểu dữ liệu cơ bản trong C: int, float, double, char và toán tử sizeof.', 2, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('04867bb3-a1b2-5387-80a4-3a8366c4102c', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'b32787ff-94db-5cfd-9de0-06a1cda5ad1e', 'c-ch02-lesson-1', 'Biến và các kiểu dữ liệu cơ bản trong C', 'Khai báo biến, chọn kiểu dữ liệu phù hợp và in giá trị bằng format specifier.', 'Trong C, mỗi biến phải được khai báo kiểu dữ liệu trước khi sử dụng. `int` lưu số nguyên, `double` lưu số thực độ chính xác kép, `char` lưu một ký tự đơn.', '#include <stdio.h>

int main(void) {
    int age = 20;
    double gpa = 3.75;
    char grade = ''A'';
    printf("Age=%d GPA=%.2f Grade=%c\n", age, gpa, grade);
    return 0;
}
', '- `int age = 20;` cấp phát vùng nhớ lưu số nguyên 20.
- `double gpa = 3.75;` lưu số thực với độ chính xác cao hơn `float`.
- `char grade = ''A'';` lưu một ký tự đặt trong dấu nháy đơn.
- `%d`, `%.2f`, `%c` là các định dạng tương ứng với `int`, `double` (2 chữ số thập phân) và `char`.', '- Dùng sai format specifier (ví dụ dùng `%d` cho `double`) gây hành vi không xác định (undefined behavior).
- Không khởi tạo giá trị biến cục bộ trước khi đọc (chứa giá trị rác).', 'Luôn khởi tạo biến khi khai báo và khớp đúng format specifier trong `printf`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('6ca1a34b-c89c-53e3-aa81-7b2f78c3616c', '04867bb3-a1b2-5387-80a4-3a8366c4102c', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, pass_threshold, is_required, sort_order) VALUES ('c5afdd00-e297-565c-ae9b-8807e5d4a368', '04867bb3-a1b2-5387-80a4-3a8366c4102c', 'Quiz: Kiểu dữ liệu cơ bản trong C', 'quiz', 'Trả lời đủ 5 câu hỏi trắc nghiệm về biến và kiểu dữ liệu C.', 'c', 80, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('0804e523-23c1-5796-99d8-f98c037a6879', 'c5afdd00-e297-565c-ae9b-8807e5d4a368', 'Kiểu dữ liệu nào trong C được dùng để lưu số nguyên có dấu?', '`int` là kiểu số nguyên có dấu chuẩn trong C.', 'Nhiều người nhầm `float` dùng cho mọi loại số, nhưng `float` là số thực dấu phẩy động.', 1) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('2caf5ef0-afd9-50ae-b56f-907272efacf4', '0804e523-23c1-5796-99d8-f98c037a6879', 'A', 'float', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f5581716-edca-560c-91ef-5402158a3fab', '0804e523-23c1-5796-99d8-f98c037a6879', 'B', 'int', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('62e684eb-b269-526e-9362-243907f411f5', '0804e523-23c1-5796-99d8-f98c037a6879', 'C', 'char*', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('6d27da88-7fca-549e-9582-a1ec4fd9c0c1', '0804e523-23c1-5796-99d8-f98c037a6879', 'D', 'double', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('61e93008-bde8-5dba-9bac-16e4998b5c56', 'c5afdd00-e297-565c-ae9b-8807e5d4a368', 'Format specifier nào dùng để in một biến kiểu `int` trong `printf`?', '`%d` (decimal integer) dùng để in số nguyên hệ thập phân.', 'Dùng `%f` cho `int` sẽ gây undefined behavior.', 2) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('60be1e37-2c5e-509f-91a7-6de3fc7de1ce', '61e93008-bde8-5dba-9bac-16e4998b5c56', 'A', '%c', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('5ccb9bd3-3a56-52f4-a31a-b10b803034c6', '61e93008-bde8-5dba-9bac-16e4998b5c56', 'B', '%f', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('fcdc887f-0784-585e-b88e-4be1d7ead003', '61e93008-bde8-5dba-9bac-16e4998b5c56', 'C', '%d', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('38cba1cb-0f30-5898-b7eb-93ef7dd903f9', '61e93008-bde8-5dba-9bac-16e4998b5c56', 'D', '%s', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('ef2ec56b-f2eb-57a3-be1a-2837728cb553', 'c5afdd00-e297-565c-ae9b-8807e5d4a368', 'Ký tự đơn trong C được viết bằng dấu nào?', 'Hằng ký tự (`char`) đặt trong cặp nháy đơn `''A''`.', 'Nháy kép `"A"` tạo ra một chuỗi kết thúc bằng `''\0''`, không phải một `char`.', 3) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('805b8dfd-9d9f-5fac-b992-daf1c5859d08', 'ef2ec56b-f2eb-57a3-be1a-2837728cb553', 'A', 'Nháy đơn ''A''', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('3d8cf501-6795-5e4c-bbcb-e0b04fcb18b9', 'ef2ec56b-f2eb-57a3-be1a-2837728cb553', 'B', 'Nháy kép "A"', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('a4329229-ff38-5075-a7f6-ecf89d7d4f5e', 'ef2ec56b-f2eb-57a3-be1a-2837728cb553', 'C', 'Ngoặc vuông [A]', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('058b5ffc-f5bf-5b45-89d2-0f415d90c9fa', 'ef2ec56b-f2eb-57a3-be1a-2837728cb553', 'D', 'Dấu backtick `A`', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('9c5bb238-03be-5214-959a-25e70e8ff658', 'c5afdd00-e297-565c-ae9b-8807e5d4a368', 'Điều gì xảy ra nếu đọc một biến cục bộ chưa được khởi tạo trong C?', 'Biến cục bộ không khởi tạo chứa giá trị bất định trong bộ nhớ stack.', 'Khác với một số ngôn ngữ bậc cao, C không tự động đặt biến cục bộ về 0.', 4) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('b7304941-ccd8-5f61-9ac3-6ce8ca482487', '9c5bb238-03be-5214-959a-25e70e8ff658', 'A', 'Luôn có giá trị 0', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('d50a1ee6-3b44-5e03-8d9a-ffad9b2c53e1', '9c5bb238-03be-5214-959a-25e70e8ff658', 'B', 'Hành vi không xác định (giá trị rác)', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('79320b74-0657-500f-bd11-e1bb0a3844b8', '9c5bb238-03be-5214-959a-25e70e8ff658', 'C', 'Trình biên dịch luôn gán 1', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('9357ef37-04ed-5040-876a-2ee25255c3ac', '9c5bb238-03be-5214-959a-25e70e8ff658', 'D', 'Tự động chuyển thành NULL', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('91fb9355-ee8f-5342-8c29-ad9071b14a0e', 'c5afdd00-e297-565c-ae9b-8807e5d4a368', 'Giữa `float` và `double`, kiểu nào có độ chính xác cao hơn theo chuẩn C?', '`double` (double-precision) thường dùng 64-bit IEEE 754, chính xác hơn `float` 32-bit.', 'Người mới hay dùng `float` mặc định rồi gặp sai số làm tròn khi tính toán.', 5) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('7ec18bee-c3d2-5536-9dc1-ce89733dd726', '91fb9355-ee8f-5342-8c29-ad9071b14a0e', 'A', 'float', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('78d25b7a-f519-5234-8b6c-3cb86e219ed5', '91fb9355-ee8f-5342-8c29-ad9071b14a0e', 'B', 'Cả hai luôn giống hệt nhau', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('af0fa36b-57e5-55d6-9a6f-60b4437d5bd8', '91fb9355-ee8f-5342-8c29-ad9071b14a0e', 'C', 'double', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('bc41f69e-a27c-541b-ac3b-7c75bb0f1c76', '91fb9355-ee8f-5342-8c29-ad9071b14a0e', 'D', 'char', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('50473295-f2ce-5ecd-a45a-dd0897c0a15c', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch03', 'Input and Output', 'Đọc dữ liệu từ bàn phím bằng scanf() và định dạng đầu ra bằng printf().', 3, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('65693978-bb4c-5e8f-b362-e99ec78c782d', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '50473295-f2ce-5ecd-a45a-dd0897c0a15c', 'c-ch03-lesson-1', 'Nhập xuất chuẩn với scanf() và printf()', 'Đọc số nguyên từ stdin bằng scanf và kiểm tra giá trị trả về.', 'Hàm `scanf()` đọc dữ liệu từ đầu vào chuẩn (`stdin`). Khi truyền biến cơ bản vào `scanf()`, ta phải dùng toán tử lấy địa chỉ `&` để `scanf` ghi giá trị vào đúng ô nhớ của biến.', '#include <stdio.h>

int main(void) {
    int a = 0, b = 0;
    if (scanf("%d %d", &a, &b) == 2) {
        printf("%d\n", a + b);
    }
    return 0;
}
', '- `&a, &b` truyền địa chỉ bộ nhớ của `a` và `b` cho `scanf`.
- `scanf(...) == 2` xác nhận đã đọc thành công đúng 2 số nguyên.', '- Quên dấu `&` trước tên biến trong `scanf("%d", a)` gây lỗi segmentation fault.', 'Luôn dùng `&` với biến đơn trong `scanf` và kiểm tra số lượng mục đọc thành công.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('daef324b-59a6-5f91-9151-886819ffbbfc', '65693978-bb4c-5e8f-b362-e99ec78c782d', 'The GNU C Library (glibc) Manual', 'https://sourceware.org/glibc/manual/', 'c', 'glibc 2.x / ISO C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('f6ba906d-e15e-5b51-9e5d-c491ac1b6949', '65693978-bb4c-5e8f-b362-e99ec78c782d', 'Tính tổng hai số nguyên', 'coding', 'Đọc hai số nguyên a và b từ đầu vào chuẩn (cách nhau bởi dấu cách) và in ra tổng a + b.', 'c', '#include <stdio.h>

int main(void) {
    int a, b;
    // Đọc a, b và in a + b
    return 0;
}
', '#include <stdio.h>

int main(void) {
    int a = 0, b = 0;
    if (scanf("%d %d", &a, &b) == 2) {
        printf("%d\n", a + b);
    }
    return 0;
}
', '7 5', '12', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('57abd2f0-8644-5ff6-9e0f-c1d0819ebdfb', 'f6ba906d-e15e-5b51-9e5d-c491ac1b6949', 'Số dương cơ bản', '7 5
', '12', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('ea90e863-c673-5666-b202-fb9554d6b133', 'f6ba906d-e15e-5b51-9e5d-c491ac1b6949', 'Số âm và số dương', '-4 10
', '6', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('c1ba0601-9c71-58f9-8723-cf096eae4e73', 'f6ba906d-e15e-5b51-9e5d-c491ac1b6949', 'Hai số 0', '0 0
', '0', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('da536c54-3b39-52aa-bab4-98bcf862d101', 'f6ba906d-e15e-5b51-9e5d-c491ac1b6949', 'Số lớn', '100000 250000
', '350000', TRUE, 4) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('4f1239ac-a63f-5e4c-9116-f494b146eada', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch04', 'Operators and Expressions', 'Toán tử số học, chia nguyên, chia lấy dư %, so sánh và logic.', 4, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('8ce1db14-14df-5c46-8b23-064f93d93445', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '4f1239ac-a63f-5e4c-9116-f494b146eada', 'c-ch04-lesson-1', 'Toán tử số học và chia lấy dư trong C', 'Phân biệt phép chia nguyên (/) và chia lấy dư (%) trong C.', 'Khi cả hai toán hạng của `/` đều là `int`, C thực hiện phép chia nguyên (bỏ phần thập phân). Toán tử `%` trả về số dư của phép chia hai số nguyên.', '#include <stdio.h>

int main(void) {
    int x = 17, y = 5;
    printf("Quotient=%d Remainder=%d\n", x / y, x % y);
    return 0;
}
', '- `17 / 5` cho kết quả `3`.
- `17 % 5` cho kết quả `2`.', '- Tưởng `5 / 2` bằng `2.5` trong khi cả hai đều là `int` nên kết quả là `2`.', 'Muốn chia số thực, cần ép kiểu ít nhất một toán hạng sang `double`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('b7cb4266-7ad7-5c13-a70b-5808e814a415', '8ce1db14-14df-5c46-8b23-064f93d93445', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('81f57574-160f-558e-aaf9-72e47d6177cb', '8ce1db14-14df-5c46-8b23-064f93d93445', 'Tính thương và số dư', 'coding', 'Đọc hai số nguyên dương a và b (b > 0). In ra hai số trên cùng một dòng cách nhau bởi dấu cách: thương nguyên (a / b) và số dư (a % b).', 'c', '#include <stdio.h>

int main(void) {
    int a, b;
    scanf("%d %d", &a, &b);
    // In thương và số dư
    return 0;
}
', '#include <stdio.h>

int main(void) {
    int a = 0, b = 1;
    if (scanf("%d %d", &a, &b) == 2 && b != 0) {
        printf("%d %d\n", a / b, a % b);
    }
    return 0;
}
', '17 5', '3 2', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('655e8b18-5b58-5e53-b89a-36a177f2ce13', '81f57574-160f-558e-aaf9-72e47d6177cb', 'Test mẫu', '17 5
', '3 2', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('e326a275-2f4b-5e2b-930b-5dfa97fdf743', '81f57574-160f-558e-aaf9-72e47d6177cb', 'Chia hết', '20 4
', '5 0', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('af395c9c-59cd-5810-b0cc-5f9b868d4133', '81f57574-160f-558e-aaf9-72e47d6177cb', 'Số bị chia nhỏ hơn số chia', '3 7
', '0 3', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('0535fded-cb0d-5d60-a4a6-ac22d9f495b3', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch05', 'Conditional Statements', 'Cấu trúc rẽ nhánh if, else if, else và switch-case.', 5, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('96fc2101-caa5-5d4b-839d-24350d82a732', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '0535fded-cb0d-5d60-a4a6-ac22d9f495b3', 'c-ch05-lesson-1', 'Câu lệnh điều kiện if / else', 'Kiểm tra điều kiện và rẽ nhánh thực thi trong C.', 'Trong C, giá trị `0` được xem là sai (false) và mọi giá trị khác `0` là đúng (true). Dùng `==` để so sánh bằng, không dùng `=`.', '#include <stdio.h>

int main(void) {
    int n = 8;
    if (n % 2 == 0) {
        printf("EVEN\n");
    } else {
        printf("ODD\n");
    }
    return 0;
}
', '- `n % 2 == 0` kiểm tra số chẵn.
- Nếu đúng in `EVEN`, ngược lại in `ODD`.', '- Viết nhầm `if (x = 5)` (phép gán) thay vì `if (x == 5)` (phép so sánh).', 'Luôn dùng `==` để so sánh bằng và đặt khối lệnh trong ngoặc nhọn `{}`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('edf06a9b-b87a-565e-be41-6683f8a5f454', '96fc2101-caa5-5d4b-839d-24350d82a732', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('bd5a656c-7aa3-5efb-a98e-956fd2ac7c0f', '96fc2101-caa5-5d4b-839d-24350d82a732', 'Kiểm tra số chẵn hay lẻ', 'coding', 'Đọc một số nguyên n. Nếu n là số chẵn in EVEN, nếu lẻ in ODD.', 'c', '#include <stdio.h>

int main(void) {
    int n;
    scanf("%d", &n);
    // Kiểm tra chẵn lẻ
    return 0;
}
', '#include <stdio.h>

int main(void) {
    int n = 0;
    if (scanf("%d", &n) == 1) {
        printf("%s\n", (n % 2 == 0) ? "EVEN" : "ODD");
    }
    return 0;
}
', '4', 'EVEN', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('9974086d-e9db-5a1c-98f4-1027b5400197', 'bd5a656c-7aa3-5efb-a98e-956fd2ac7c0f', 'Số chẵn dương', '4
', 'EVEN', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('2e6968c6-aa46-55ed-9834-2080fe422ee4', 'bd5a656c-7aa3-5efb-a98e-956fd2ac7c0f', 'Số lẻ dương', '9
', 'ODD', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('6a6c5fba-9d47-5071-90b9-8e8ab8450491', 'bd5a656c-7aa3-5efb-a98e-956fd2ac7c0f', 'Số 0', '0
', 'EVEN', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('7a40045d-f57e-562e-bcaa-caad738f1f30', 'bd5a656c-7aa3-5efb-a98e-956fd2ac7c0f', 'Số lẻ âm', '-7
', 'ODD', TRUE, 4) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('3d1d7f4e-92dc-5f75-82e1-142c7f897bb3', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch06', 'Loops', 'Vòng lặp for, while, do-while và lệnh break/continue.', 6, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('40a95e4d-52b9-5c33-8102-5b1bcc994f6a', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '3d1d7f4e-92dc-5f75-82e1-142c7f897bb3', 'c-ch06-lesson-1', 'Vòng lặp for và tính tổng dãy số', 'Lặp qua khoảng giá trị bằng vòng lặp for chuẩn trong C.', 'Vòng lặp `for (khởi_tạo; điều_kiện; bước_nhảy)` giúp lặp chính xác số lần biết trước.', '#include <stdio.h>

int main(void) {
    int sum = 0;
    for (int i = 1; i <= 5; i++) {
        sum += i;
    }
    printf("%d\n", sum);
    return 0;
}
', '- `i` chạy từ 1 đến 5, cộng dồn vào `sum`.
- Kết quả in ra là `15`.', '- Lỗi off-by-one (`i < n` thay vì `i <= n`).
- Đặt nhầm dấu `;` ngay sau `for (...)` tạo vòng lặp rỗng.', 'Kiểm tra kỹ giá trị khởi đầu, điều kiện dừng và bước tăng của biến lặp.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('0997a0bf-78f9-5159-a1ad-be63a36fb63c', '40a95e4d-52b9-5c33-8102-5b1bcc994f6a', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('174474fe-25e3-5bab-a3d8-600092e14a9a', '40a95e4d-52b9-5c33-8102-5b1bcc994f6a', 'Tính tổng từ 1 đến N', 'coding', 'Đọc số nguyên dương N (1 <= N <= 10000) và in ra tổng 1 + 2 + ... + N.', 'c', '#include <stdio.h>

int main(void) {
    int n;
    scanf("%d", &n);
    // Tính tổng 1..n
    return 0;
}
', '#include <stdio.h>

int main(void) {
    int n = 0;
    if (scanf("%d", &n) == 1) {
        long long sum = 0;
        for (int i = 1; i <= n; i++) sum += i;
        printf("%lld\n", sum);
    }
    return 0;
}
', '5', '15', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('cc12ca93-243b-5397-9b13-674f9e561bde', '174474fe-25e3-5bab-a3d8-600092e14a9a', 'N = 5', '5
', '15', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('90fcff92-3e21-5a77-a011-22da13bf82c8', '174474fe-25e3-5bab-a3d8-600092e14a9a', 'N = 1', '1
', '1', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('2099c08c-c287-58d0-aca0-041bb8f9dd27', '174474fe-25e3-5bab-a3d8-600092e14a9a', 'N = 100', '100
', '5050', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('79b1d1c3-6c98-5695-b16e-0b2f77c71c7e', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch07', 'Functions', 'Định nghĩa hàm, truyền tham trị (pass-by-value) và khai báo prototype.', 7, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('ae5a5706-9a76-53fb-afe4-88333e7db093', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '79b1d1c3-6c98-5695-b16e-0b2f77c71c7e', 'c-ch07-lesson-1', 'Xây dựng và gọi hàm trong C', 'Tách logic thành hàm có kiểu trả về rõ ràng.', 'Hàm giúp chia nhỏ bài toán và tái sử dụng mã nguồn. Trong C, tham số mặc định được truyền theo giá trị (pass-by-value).', '#include <stdio.h>

int max_two(int a, int b) {
    return (a > b) ? a : b;
}

int main(void) {
    printf("%d\n", max_two(10, 25));
    return 0;
}
', '- `max_two` nhận hai số nguyên và trả về số lớn hơn.
- Hàm `main` gọi `max_two(10, 25)` và in `25`.', '- Quên lệnh `return` trong hàm không phải `void`.', 'Khai báo nguyên mẫu (prototype) hoặc định nghĩa hàm trước khi gọi trong `main`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('b5845dcc-9bba-537c-bd19-ccb02deac6d9', 'ae5a5706-9a76-53fb-afe4-88333e7db093', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('10d559a3-8782-5602-a4a8-d4d7f0d82818', 'ae5a5706-9a76-53fb-afe4-88333e7db093', 'Tìm số lớn hơn trong 2 số', 'coding', 'Viết hàm `max_two(int a, int b)` và dùng nó để đọc hai số nguyên từ stdin rồi in ra số lớn hơn.', 'c', '#include <stdio.h>

int max_two(int a, int b) {
    // Trả về số lớn hơn
    return a;
}

int main(void) {
    int a, b;
    scanf("%d %d", &a, &b);
    printf("%d\n", max_two(a, b));
    return 0;
}
', '#include <stdio.h>

int max_two(int a, int b) {
    return (a > b) ? a : b;
}

int main(void) {
    int a = 0, b = 0;
    if (scanf("%d %d", &a, &b) == 2) {
        printf("%d\n", max_two(a, b));
    }
    return 0;
}
', '12 30', '30', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('31ac8d0d-0ad8-5335-b176-ac080807b367', '10d559a3-8782-5602-a4a8-d4d7f0d82818', 'Số thứ hai lớn hơn', '12 30
', '30', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('a4205360-15be-595b-bfae-b4bd15c4184f', '10d559a3-8782-5602-a4a8-d4d7f0d82818', 'Số âm', '-5 -2
', '-2', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('36d05df3-5c45-5c1b-a962-67d8072418fe', '10d559a3-8782-5602-a4a8-d4d7f0d82818', 'Hai số bằng nhau', '8 8
', '8', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('e83f5b63-797b-529b-b964-691e5f9a5dda', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch08', 'Arrays', 'Mảng một chiều, chỉ số bắt đầu từ 0 và duyệt mảng an toàn.', 8, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('e9960274-1084-59e3-aa33-168b0b71dff4', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'e83f5b63-797b-529b-b964-691e5f9a5dda', 'c-ch08-lesson-1', 'Mảng một chiều và duyệt phần tử', 'Lưu trữ tập hợp phần tử cùng kiểu liên tiếp trong bộ nhớ.', 'Mảng có `n` phần tử trong C có chỉ số hợp lệ từ `0` đến `n - 1`. Truy cập ngoài phạm vi gây undefined behavior.', '#include <stdio.h>

int main(void) {
    int arr[3] = {4, 7, 9};
    int total = 0;
    for (int i = 0; i < 3; i++) total += arr[i];
    printf("%d\n", total);
    return 0;
}
', '- `arr[0]` là 4, `arr[1]` là 7, `arr[2]` là 9.
- Vòng lặp chạy `i < 3` để không vượt giới hạn mảng.', '- Truy cập `arr[n]` khi mảng chỉ có `n` phần tử.', 'Chỉ số mảng C luôn bắt đầu từ 0 và kết thúc ở `n - 1`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('a50dfb7e-ef4f-5b43-82ae-22041039e5e8', 'e9960274-1084-59e3-aa33-168b0b71dff4', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('4689578b-d0f2-58cb-bc21-5728b0bed0fd', 'e9960274-1084-59e3-aa33-168b0b71dff4', 'Tổng các phần tử trong mảng', 'coding', 'Dòng 1 nhập số nguyên N (1 <= N <= 100). Dòng 2 nhập N số nguyên. In ra tổng N số đó.', 'c', '#include <stdio.h>

int main(void) {
    int n;
    scanf("%d", &n);
    int a[100];
    // Đọc mảng và tính tổng
    return 0;
}
', '#include <stdio.h>

int main(void) {
    int n = 0;
    if (scanf("%d", &n) == 1) {
        int a[100];
        int sum = 0;
        for (int i = 0; i < n; i++) {
            scanf("%d", &a[i]);
            sum += a[i];
        }
        printf("%d\n", sum);
    }
    return 0;
}
', '4
1 2 3 4', '10', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('3009a80f-e27c-5e4e-b483-9d02af577d79', '4689578b-d0f2-58cb-bc21-5728b0bed0fd', '4 phần tử', '4
1 2 3 4
', '10', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('29318598-a477-5292-a9de-1aaac42653c1', '4689578b-d0f2-58cb-bc21-5728b0bed0fd', 'Có số âm', '3
-5 10 2
', '7', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('949f1ef4-bd6a-5d5e-8a65-171a4fc998d9', '4689578b-d0f2-58cb-bc21-5728b0bed0fd', '1 phần tử', '1
42
', '42', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('40a64c11-756c-5e5a-80c4-195e046fb1da', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch09', 'Strings', 'Chuỗi ký tự kết thúc bằng ký tự null ''\0'' và thư viện <string.h>.', 9, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('fab1dffb-c2d6-5cee-b308-92dd52a1f1fc', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '40a64c11-756c-5e5a-80c4-195e046fb1da', 'c-ch09-lesson-1', 'Chuỗi ký tự và hàm strlen trong <string.h>', 'Hiểu cách C biểu diễn chuỗi bằng mảng char kết thúc bởi ''\0''.', 'Trong C không có kiểu `string` tích hợp; chuỗi là mảng `char` kết thúc bằng ký tự null `''\0''`. Hàm `strlen()` trong `<string.h>` trả về độ dài chuỗi không tính `''\0''`.', '#include <stdio.h>
#include <string.h>

int main(void) {
    char word[] = "hello";
    printf("%zu\n", strlen(word));
    return 0;
}
', '- `word` chiếm 6 byte: `''h'',''e'',''l'',''l'',''o'',''\0''`.
- `strlen(word)` trả về `5` (kiểu `size_t`, in bằng `%zu`).', '- So sánh hai chuỗi bằng `s1 == s2` (so sánh địa chỉ) thay vì `strcmp(s1, s2) == 0`.', 'Luôn chừa thêm 1 byte cho `''\0''` và dùng `%zu` để in `size_t`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('e63ec8c0-96a7-50f2-9857-d4727f7df866', 'fab1dffb-c2d6-5cee-b308-92dd52a1f1fc', 'C Standard Library Reference (DevDocs / cppreference)', 'https://devdocs.io/c/', 'c', 'ISO C11/C17', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('92a05b16-b84b-5741-937b-44cd2d740945', 'fab1dffb-c2d6-5cee-b308-92dd52a1f1fc', 'Đếm độ dài từ', 'coding', 'Đọc một từ (không chứa khoảng trắng, tối đa 100 ký tự) và in ra độ dài của từ đó.', 'c', '#include <stdio.h>
#include <string.h>

int main(void) {
    char s[101];
    scanf("%100s", s);
    // In độ dài chuỗi s
    return 0;
}
', '#include <stdio.h>
#include <string.h>

int main(void) {
    char s[101];
    if (scanf("%100s", s) == 1) {
        printf("%zu\n", strlen(s));
    }
    return 0;
}
', 'coding', '6', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('30f4c5ea-28c6-5d35-9756-45b5178597a8', '92a05b16-b84b-5741-937b-44cd2d740945', 'Từ thường', 'coding
', '6', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('63d9207d-7469-5ce0-8b81-c820c93fe239', '92a05b16-b84b-5741-937b-44cd2d740945', 'Một ký tự', 'C
', '1', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('1631bfff-9da3-5f6f-bc84-269f11fef478', '92a05b16-b84b-5741-937b-44cd2d740945', 'Từ dài hơn', 'programming
', '11', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('c2a923b6-4d70-55b5-b75c-cecd3075f053', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch10', 'Pointers', 'Địa chỉ bộ nhớ, toán tử & và *, truyền con trỏ vào hàm.', 10, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('c9a7c81e-6348-573d-a4ff-74a47fd5ed52', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c2a923b6-4d70-55b5-b75c-cecd3075f053', 'c-ch10-lesson-1', 'Con trỏ (Pointers) và hoán đổi hai biến', 'Dùng con trỏ để thay đổi giá trị biến gốc từ bên trong hàm.', 'Con trỏ là biến lưu địa chỉ bộ nhớ của biến khác. Toán tử `&` lấy địa chỉ, còn `*` truy xuất (dereference) giá trị tại địa chỉ đó.', '#include <stdio.h>

void swap(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int main(void) {
    int x = 3, y = 9;
    swap(&x, &y);
    printf("%d %d\n", x, y);
    return 0;
}
', '- `swap(&x, &y)` truyền địa chỉ của `x` và `y`.
- Trong hàm, `*a` và `*b` sửa trực tiếp giá trị tại ô nhớ của `x` và `y`.', '- Dereference con trỏ `NULL` hoặc con trỏ chưa khởi tạo gây crash (segmentation fault).', 'Luôn khởi tạo con trỏ (hoặc gán `NULL`) và kiểm tra trước khi dereference.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('b027ed48-e86f-5a43-90e9-29b9bcf11fc3', 'c9a7c81e-6348-573d-a4ff-74a47fd5ed52', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('2277d2f1-b1c2-5631-a2eb-a206fb75218a', 'c9a7c81e-6348-573d-a4ff-74a47fd5ed52', 'Hoán đổi hai số bằng con trỏ', 'coding', 'Đọc hai số nguyên x và y, dùng hàm `swap(int *a, int *b)` để hoán đổi rồi in ra `x y` sau khi hoán đổi.', 'c', '#include <stdio.h>

void swap(int *a, int *b) {
    // Hoán đổi giá trị tại a và b
}

int main(void) {
    int x, y;
    scanf("%d %d", &x, &y);
    swap(&x, &y);
    printf("%d %d\n", x, y);
    return 0;
}
', '#include <stdio.h>

void swap(int *a, int *b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}

int main(void) {
    int x = 0, y = 0;
    if (scanf("%d %d", &x, &y) == 2) {
        swap(&x, &y);
        printf("%d %d\n", x, y);
    }
    return 0;
}
', '3 9', '9 3', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('b1fc0242-83e1-5823-a060-6bc2a37c91b6', '2277d2f1-b1c2-5631-a2eb-a206fb75218a', 'Hai số dương', '3 9
', '9 3', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('48877926-c673-5fe3-8888-18b25bcc0996', '2277d2f1-b1c2-5631-a2eb-a206fb75218a', 'Số âm và dương', '-1 5
', '5 -1', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('9de220b6-b1d0-5a1d-b6fe-dc8d0a0bf315', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch11', 'Memory Management', 'Cấp phát động trên Heap bằng malloc/calloc và giải phóng bằng free().', 11, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('f3922091-d359-557b-9668-a7059dd0f0e3', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '9de220b6-b1d0-5a1d-b6fe-dc8d0a0bf315', 'c-ch11-lesson-1', 'Cấp phát bộ nhớ động với malloc và free', 'Quản lý bộ nhớ Heap an toàn, tránh rò rỉ bộ nhớ (memory leak).', 'Thư viện `<stdlib.h>` cung cấp `malloc(size)` để cấp phát bộ nhớ trên Heap. Sau khi dùng xong, bắt buộc gọi `free(ptr)` để trả lại bộ nhớ cho hệ thống.', '#include <stdio.h>
#include <stdlib.h>

int main(void) {
    int *arr = malloc(3 * sizeof(int));
    if (arr == NULL) return 1;
    arr[0] = 10; arr[1] = 20; arr[2] = 30;
    printf("%d\n", arr[0] + arr[1] + arr[2]);
    free(arr);
    arr = NULL;
    return 0;
}
', '- `malloc(3 * sizeof(int))` cấp phát đủ chỗ cho 3 số `int`.
- Kiểm tra `arr == NULL` để tránh lỗi khi hết bộ nhớ.
- `free(arr)` giải phóng vùng nhớ và gán `NULL` để tránh dangling pointer.', '- Quên gọi `free()` gây memory leak.
- Truy cập con trỏ sau khi đã `free()` (use-after-free).', 'Mọi lệnh `malloc`/`calloc` phải có đúng một lệnh `free` tương ứng.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('2cacc4c5-6af1-5772-80a9-b4321c0f2499', 'f3922091-d359-557b-9668-a7059dd0f0e3', 'The GNU C Library (glibc) Manual', 'https://sourceware.org/glibc/manual/', 'c', 'glibc 2.x / ISO C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, pass_threshold, is_required, sort_order) VALUES ('6b011f03-55f5-5635-a6cd-4bb91149fd48', 'f3922091-d359-557b-9668-a7059dd0f0e3', 'Quiz: Quản lý bộ nhớ động trong C', 'quiz', 'Trả lời đủ 5 câu hỏi về malloc, calloc, free và vùng nhớ Heap.', 'c', 80, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('acc2e6e2-687f-56b1-b9a0-aa1ce3407466', '6b011f03-55f5-5635-a6cd-4bb91149fd48', 'Thư viện chuẩn nào khai báo hàm `malloc` và `free` trong C?', '`malloc`, `calloc`, `realloc`, `free` nằm trong `<stdlib.h>`.', 'Nhiều người chỉ include `<stdio.h>` rồi gặp lỗi biên dịch.', 1) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('e969a27b-829e-5fea-bf19-42084122005d', 'acc2e6e2-687f-56b1-b9a0-aa1ce3407466', 'A', '<stdio.h>', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('309c9f1c-b59d-55a9-89cc-7f73b81b2446', 'acc2e6e2-687f-56b1-b9a0-aa1ce3407466', 'B', '<stdlib.h>', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('2ca1f650-c6c8-539c-a25a-6a61244d63ca', 'acc2e6e2-687f-56b1-b9a0-aa1ce3407466', 'C', '<string.h>', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('234e5b09-dc6f-5c9d-ab2e-25bee576be35', 'acc2e6e2-687f-56b1-b9a0-aa1ce3407466', 'D', '<math.h>', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('cad8dd43-77a5-517a-87bc-3af7c0d04fe7', '6b011f03-55f5-5635-a6cd-4bb91149fd48', 'Bộ nhớ cấp phát bởi `malloc` nằm ở vùng nhớ nào?', '`malloc` cấp phát bộ nhớ động trên vùng nhớ Heap.', 'Biến cục bộ nằm trên Stack, còn bộ nhớ động nằm trên Heap.', 2) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('afeb2056-1799-5ff5-8635-bfd8c2436b42', 'cad8dd43-77a5-517a-87bc-3af7c0d04fe7', 'A', 'Heap', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('93b5b1f3-e83b-5e29-aa96-854b46c6ec8e', 'cad8dd43-77a5-517a-87bc-3af7c0d04fe7', 'B', 'Stack', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('c0314a5d-1f39-5b6e-8682-b3e982ecf18d', 'cad8dd43-77a5-517a-87bc-3af7c0d04fe7', 'C', 'CPU Cache only', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('ece17081-4f48-5e45-9ae0-adf33d66bf45', 'cad8dd43-77a5-517a-87bc-3af7c0d04fe7', 'D', 'Read-only code segment', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('f7c69d3c-48bc-5be9-8baf-f1e1bcbbedf9', '6b011f03-55f5-5635-a6cd-4bb91149fd48', 'Nếu `malloc` không thể cấp phát bộ nhớ, nó trả về giá trị gì?', '`malloc` trả về `NULL` khi cấp phát thất bại.', 'Không kiểm tra `NULL` trước khi dùng con trỏ có thể làm crash chương trình.', 3) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('eb80178d-a0d4-5371-a6f9-4ad0c9e6a188', 'f7c69d3c-48bc-5be9-8baf-f1e1bcbbedf9', 'A', '0xFFFF', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('808c23e5-9ffa-52fa-993f-d872bdeae138', 'f7c69d3c-48bc-5be9-8baf-f1e1bcbbedf9', 'B', '-1', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('8c72e6ac-9013-52cb-88e3-d8ac32b8d798', 'f7c69d3c-48bc-5be9-8baf-f1e1bcbbedf9', 'C', 'NULL', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f448d7ce-d9fd-5e7c-a2e7-5758c6b6c1e5', 'f7c69d3c-48bc-5be9-8baf-f1e1bcbbedf9', 'D', 'Một mảng rỗng', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('c83458eb-acd2-512e-9fd3-e02991a0a791', '6b011f03-55f5-5635-a6cd-4bb91149fd48', 'Sự khác biệt chính giữa `calloc(n, size)` và `malloc(n * size)` là gì?', '`calloc` khởi tạo vùng nhớ về 0, còn `malloc` giữ nội dung chưa khởi tạo.', 'Đừng giả định vùng nhớ `malloc` luôn bằng 0.', 4) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f450cb54-33c4-531c-a74f-236adc2d5a53', 'c83458eb-acd2-512e-9fd3-e02991a0a791', 'A', 'calloc khởi tạo toàn bộ byte về 0', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('d0f586d0-bc0e-5bac-a06a-1275b1ea6978', 'c83458eb-acd2-512e-9fd3-e02991a0a791', 'B', 'calloc tự động gọi free', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('c021f19a-3daa-52ea-92f7-d824c3b6de16', 'c83458eb-acd2-512e-9fd3-e02991a0a791', 'C', 'malloc nhanh hơn và tự đặt về 0', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('24f607f1-4974-5036-a20b-d7fd2ce7966a', 'c83458eb-acd2-512e-9fd3-e02991a0a791', 'D', 'Không có khác biệt nào', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('8f18b3f0-5290-57f2-9b26-ba5f6310ca16', '6b011f03-55f5-5635-a6cd-4bb91149fd48', 'Điều gì xảy ra nếu gọi `free(ptr)` hai lần trên cùng một địa chỉ hợp lệ?', 'Double free gây undefined behavior và có thể dẫn đến lỗ hổng bảo mật.', 'Nên đặt `ptr = NULL;` sau khi gọi `free(ptr)` vì `free(NULL)` là an toàn.', 5) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('e4693cc3-0e9b-53b4-93c8-71eec31cd6a5', '8f18b3f0-5290-57f2-9b26-ba5f6310ca16', 'A', 'Không có vấn đề gì', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('492a1749-8332-55a1-b294-ac2f6f2d6c41', '8f18b3f0-5290-57f2-9b26-ba5f6310ca16', 'B', 'Double free — hành vi không xác định (lỗi bảo mật)', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('0673ee27-35c3-5471-a146-dc6906cbc4d4', '8f18b3f0-5290-57f2-9b26-ba5f6310ca16', 'C', 'Tự động tăng bộ nhớ', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('06512e61-e855-5bbb-8873-3d5539ed4a31', '8f18b3f0-5290-57f2-9b26-ba5f6310ca16', 'D', 'Chuyển ptr sang stack', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('487cf11b-efb4-50d8-99d3-9d72c399e6ef', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch12', 'Structures and Unions', 'Nhóm dữ liệu khác kiểu bằng struct và tối ưu bộ nhớ bằng union.', 12, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('bd4a9e24-61f9-5161-9e38-b3bef6c731b9', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '487cf11b-efb4-50d8-99d3-9d72c399e6ef', 'c-ch12-lesson-1', 'Kiểu cấu trúc struct trong C', 'Định nghĩa kiểu dữ liệu tự tạo bằng struct và typedef.', '`struct` cho phép gộp nhiều trường dữ liệu liên quan (ví dụ chiều dài và chiều rộng hình chữ nhật) vào một thực thể duy nhất.', '#include <stdio.h>

typedef struct {
    int width;
    int height;
} Rect;

int main(void) {
    Rect r = {4, 5};
    printf("%d\n", r.width * r.height);
    return 0;
}
', '- `typedef struct { ... } Rect;` tạo kiểu tên `Rect`.
- Truy cập thành viên bằng toán tử dấu chấm `.`.', '- Quên dấu chấm phẩy `;` sau ngoặc đóng của `struct`.', 'Dùng `struct` để mô hình hóa thực thể rõ ràng, dễ bảo trì.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('696c52f8-8cc5-5300-ae07-c8a2030aa75b', 'bd4a9e24-61f9-5161-9e38-b3bef6c731b9', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('0fc48449-7529-5a21-a676-d4dc2bbb5b9a', 'bd4a9e24-61f9-5161-9e38-b3bef6c731b9', 'Tính diện tích hình chữ nhật bằng struct', 'coding', 'Đọc hai số nguyên dương width và height, lưu vào struct `Rect` và in ra diện tích `width * height`.', 'c', '#include <stdio.h>

typedef struct {
    int width;
    int height;
} Rect;

int main(void) {
    Rect r;
    scanf("%d %d", &r.width, &r.height);
    // In diện tích
    return 0;
}
', '#include <stdio.h>

typedef struct {
    int width;
    int height;
} Rect;

int main(void) {
    Rect r = {0, 0};
    if (scanf("%d %d", &r.width, &r.height) == 2) {
        printf("%d\n", r.width * r.height);
    }
    return 0;
}
', '4 6', '24', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('ce43fa38-b8df-54b7-bc72-e061a3e5162e', '0fc48449-7529-5a21-a676-d4dc2bbb5b9a', 'Chữ nhật cơ bản', '4 6
', '24', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('aa18ba46-9025-53f8-b04b-e3f9cef19ec7', '0fc48449-7529-5a21-a676-d4dc2bbb5b9a', 'Hình vuông', '5 5
', '25', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('1297535f-3fe8-5195-8435-ca4c6c8e4839', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch13', 'File Handling', 'Đọc ghi tệp tin bằng FILE*, fopen, fprintf, fgets và fclose.', 13, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('566d2053-ba3f-52d4-9cbc-9a54c82c44aa', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '1297535f-3fe8-5195-8435-ca4c6c8e4839', 'c-ch13-lesson-1', 'Làm việc với tệp tin (File I/O) trong C', 'Quy trình mở tệp, kiểm tra NULL, đọc/ghi dữ liệu và đóng tệp an toàn.', 'Thư viện `<stdio.h>` cung cấp kiểu `FILE*` cùng các hàm `fopen`, `fprintf`, `fgets`, `fclose` để thao tác với tệp tin.', '#include <stdio.h>

int main(void) {
    // Ví dụ minh họa luồng chuẩn stdout (cùng bản chất FILE*)
    fprintf(stdout, "File I/O uses FILE* streams\n");
    return 0;
}
', '- `stdout`, `stdin`, `stderr` đều là các luồng `FILE*` có sẵn.
- Với tệp trên đĩa, luôn kiểm tra `if (fp == NULL)` sau `fopen` và đóng bằng `fclose(fp)`.', '- Quên `fclose(fp)` gây rò rỉ file descriptor hoặc mất dữ liệu chưa flush.', 'Luôn kiểm tra `fopen` khác `NULL` và luôn đóng tệp bằng `fclose`.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('58fee394-de19-5556-8762-8e415a271980', '566d2053-ba3f-52d4-9cbc-9a54c82c44aa', 'The GNU C Library (glibc) Manual', 'https://sourceware.org/glibc/manual/', 'c', 'glibc 2.x / ISO C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, pass_threshold, is_required, sort_order) VALUES ('629dcbf6-2d21-593d-baa0-35f5651867b4', '566d2053-ba3f-52d4-9cbc-9a54c82c44aa', 'Quiz: Xử lý tệp tin trong C', 'quiz', 'Hoàn thành 5 câu hỏi về File I/O trong C.', 'c', 80, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('3bb31242-6793-5575-8bee-f95a0dd25a01', '629dcbf6-2d21-593d-baa0-35f5651867b4', 'Hàm nào dùng để mở một tệp tin trong C chuẩn?', '`fopen(filename, mode)` là hàm chuẩn trong `<stdio.h>`.', '`open()` là POSIX syscall, không phải hàm ISO C chuẩn.', 1) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('d7d56253-51a3-5f65-9a71-e4ad69cc78ca', '3bb31242-6793-5575-8bee-f95a0dd25a01', 'A', 'openfile()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f5ba0e6b-e9da-577c-9da6-7ad60e73efc4', '3bb31242-6793-5575-8bee-f95a0dd25a01', 'B', 'fopen()', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('07041a8e-cdde-5102-87a7-1fcdd7335aba', '3bb31242-6793-5575-8bee-f95a0dd25a01', 'C', 'file_open()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('c3fa1d7f-fb20-51a6-b3b2-f4654f1fe3a8', '3bb31242-6793-5575-8bee-f95a0dd25a01', 'D', 'fread()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('09e11c9b-538d-5d80-9ca8-d6a46ef5324f', '629dcbf6-2d21-593d-baa0-35f5651867b4', 'Chế độ mở tệp `"w"` trong `fopen` có tác dụng gì?', 'Mode `"w"` tạo tệp mới nếu chưa có, hoặc cắt rỗng tệp cũ để ghi từ đầu.', 'Muốn ghi nối tiếp mà không xóa dữ liệu cũ, phải dùng mode `"a"` (append).', 2) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('5ed1ad54-9e68-5b36-9f56-0dbc57efd1a8', '09e11c9b-538d-5d80-9ca8-d6a46ef5324f', 'A', 'Chỉ đọc tệp', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('7448b83e-16d3-5881-ac9b-12bcb5c5f5fc', '09e11c9b-538d-5d80-9ca8-d6a46ef5324f', 'B', 'Tạo tệp mới hoặc ghi đè xóa nội dung cũ', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('5934ec67-2a5d-59ea-8e9f-1a5a6a0b62c7', '09e11c9b-538d-5d80-9ca8-d6a46ef5324f', 'C', 'Ghi nối tiếp cuối tệp', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('e2acae7b-66b2-5d7c-98ae-ba661fe81065', '09e11c9b-538d-5d80-9ca8-d6a46ef5324f', 'D', 'Xóa tệp khỏi ổ đĩa', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('f6738851-8c72-54d1-8a58-022c3b39e324', '629dcbf6-2d21-593d-baa0-35f5651867b4', 'Nếu `fopen` thất bại (ví dụ tệp không tồn tại ở mode `"r"`), nó trả về gì?', '`fopen` trả về `NULL` khi không mở được tệp.', '`EOF` là giá trị báo hết tệp khi đọc, không phải giá trị trả về của `fopen`.', 3) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('21e5ac61-ae5f-5264-ab96-00de54f99476', 'f6738851-8c72-54d1-8a58-022c3b39e324', 'A', '0x01', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('df8ece8d-c809-531b-ac14-bcad8cf3dfbf', 'f6738851-8c72-54d1-8a58-022c3b39e324', 'B', 'EOF', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('a79ca034-49dc-5a62-b96f-04b7db10b06a', 'f6738851-8c72-54d1-8a58-022c3b39e324', 'C', 'NULL', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('0332f627-fba5-5b7e-a92c-5f7beae1e309', 'f6738851-8c72-54d1-8a58-022c3b39e324', 'D', 'false', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('0b11d21b-799e-5c3a-b76c-a0d201281073', '629dcbf6-2d21-593d-baa0-35f5651867b4', 'Tại sao bắt buộc phải gọi `fclose(fp)` sau khi ghi tệp?', '`fclose` đảm bảo dữ liệu trong buffer được ghi đủ và giải phóng handle hệ thống.', 'Bỏ qua `fclose` có thể khiến tệp bị thiếu dữ liệu cuối.', 4) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('0bfeba53-74b3-549c-906e-0104c0cd0345', '0b11d21b-799e-5c3a-b76c-a0d201281073', 'A', 'Để xả (flush) bộ đệm xuống đĩa và giải phóng tài nguyên', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f6672cf2-1d51-56db-a343-c8d9fc6893c1', '0b11d21b-799e-5c3a-b76c-a0d201281073', 'B', 'Để đổi tên tệp', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('4183b551-367a-5293-94db-5f7ca4958f19', '0b11d21b-799e-5c3a-b76c-a0d201281073', 'C', 'Không cần thiết vì C không dùng buffer', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('3986fdc0-c191-5e67-b5b4-b33c3e0ed9b3', '0b11d21b-799e-5c3a-b76c-a0d201281073', 'D', 'Để nén tệp tự động', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('001ebe6c-2ec8-5cc4-9b04-a7dc9c923b8d', '629dcbf6-2d21-593d-baa0-35f5651867b4', 'Hàm nào an toàn hơn để đọc một dòng văn bản có giới hạn kích thước buffer?', '`fgets(buf, sizeof(buf), fp)` giới hạn số ký tự đọc, tránh tràn bộ đệm (buffer overflow).', '`gets()` đã bị xóa khỏi chuẩn C11 vì không kiểm tra kích thước buffer.', 5) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('4628be54-695f-5830-94d0-cb86771204e8', '001ebe6c-2ec8-5cc4-9b04-a7dc9c923b8d', 'A', 'gets()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('42f37165-6d5b-53e4-af7b-2b8a94bbc1c8', '001ebe6c-2ec8-5cc4-9b04-a7dc9c923b8d', 'B', 'fgets()', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('af21c15c-ebd1-568b-a568-360f8a41bc2b', '001ebe6c-2ec8-5cc4-9b04-a7dc9c923b8d', 'C', 'strcpy()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('92d42873-e746-5381-8a8e-380594fd4a94', '001ebe6c-2ec8-5cc4-9b04-a7dc9c923b8d', 'D', 'printf()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('e88cbe61-1c17-5588-a5a8-17103a9cf13d', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch14', 'Recursion', 'Hàm đệ quy, điều kiện dừng (base case) và call stack.', 14, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('60185b24-7a63-57ce-acac-dc24558de339', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'e88cbe61-1c17-5588-a5a8-17103a9cf13d', 'c-ch14-lesson-1', 'Đệ quy (Recursion) và bài toán giai thừa', 'Thiết kế hàm đệ quy với base case rõ ràng để tránh tràn stack.', 'Đệ quy là kỹ thuật hàm tự gọi lại chính nó trên bài toán nhỏ hơn. Mọi hàm đệ quy bắt buộc phải có **điều kiện dừng (base case)**.', '#include <stdio.h>

long long factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main(void) {
    printf("%lld\n", factorial(5));
    return 0;
}
', '- Khi `n <= 1`, hàm trả về `1` (base case).
- Ngược lại, trả về `n * factorial(n - 1)`.', '- Thiếu base case hoặc bước đệ quy không tiến về base case gây Stack Overflow.', 'Luôn xác định base case trước khi viết lời gọi đệ quy.', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('996a1e71-a198-559e-9d61-3316555047e5', '60185b24-7a63-57ce-acac-dc24558de339', 'The GNU C Reference Manual', 'https://www.gnu.org/software/gnu-c-manual/gnu-c-manual.html', 'c', 'C11 / GNU C', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('90cfded0-092c-56a8-bc00-2fe9794066cb', '60185b24-7a63-57ce-acac-dc24558de339', 'Tính giai thừa N! bằng đệ quy', 'coding', 'Đọc số nguyên N (0 <= N <= 12) và in ra N! bằng hàm đệ quy.', 'c', '#include <stdio.h>

long long factorial(int n) {
    // Viết hàm đệ quy tính n!
    return 1;
}

int main(void) {
    int n;
    scanf("%d", &n);
    printf("%lld\n", factorial(n));
    return 0;
}
', '#include <stdio.h>

long long factorial(int n) {
    if (n <= 1) return 1;
    return n * factorial(n - 1);
}

int main(void) {
    int n = 0;
    if (scanf("%d", &n) == 1) {
        printf("%lld\n", factorial(n));
    }
    return 0;
}
', '5', '120', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('f07a423a-b5f8-5396-8ee9-f49849563531', '90cfded0-092c-56a8-bc00-2fe9794066cb', '5! = 120', '5
', '120', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('eb35db8a-d935-559d-bada-585b2e4e5603', '90cfded0-092c-56a8-bc00-2fe9794066cb', '0! = 1', '0
', '1', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('1a8fdceb-4d74-5d32-a9d2-cae5303e9f54', '90cfded0-092c-56a8-bc00-2fe9794066cb', '10! = 3628800', '10
', '3628800', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('5d79f917-e5b6-513b-bf46-dc679af537c8', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', 'c-ch15', 'Algorithms and Problem Solving', 'Tìm kiếm tuyến tính, ước chung lớn nhất (Euclid) và tư duy phân tích độ phức tạp.', 15, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('97930fcd-2197-51ed-8fd4-6acaf0d3c279', '7ba38073-dfd1-5fad-ab87-09fe8fcc362d', '5d79f917-e5b6-513b-bf46-dc679af537c8', 'c-ch15-lesson-1', 'Thuật toán Euclid tìm ước chung lớn nhất (GCD)', 'Áp dụng thuật toán hiệu quả độ phức tạp O(log min(a, b)) trong C.', 'Thuật toán Euclid tính ước chung lớn nhất của hai số nguyên dương dựa trên tính chất: `gcd(a, b) = gcd(b, a % b)` cho đến khi `b == 0`.', '#include <stdio.h>

int gcd(int a, int b) {
    while (b != 0) {
        int r = a % b;
        a = b;
        b = r;
    }
    return a;
}

int main(void) {
    printf("%d\n", gcd(48, 18));
    return 0;
}
', '- Mỗi bước thay `(a, b)` bằng `(b, a % b)`.
- Khi `b == 0`, `a` chính là ước chung lớn nhất.', '- Duyệt thử mọi số từ 1 đến min(a, b) tốn O(n) và chậm với số lớn.', 'Chọn đúng thuật toán giúp giảm thời gian chạy từ tuyến tính O(n) xuống logarit O(log n).', 'c', 'ISO C11 / GCC 12', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('410e0877-be37-5c4c-aeda-f14f1e86c893', '97930fcd-2197-51ed-8fd4-6acaf0d3c279', 'GCC Online Documentation', 'https://gcc.gnu.org/onlinedocs/', 'c', 'GCC 12+', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('01678aeb-5b6e-55b8-b3ce-8d72cf53a65e', '97930fcd-2197-51ed-8fd4-6acaf0d3c279', 'Tìm ước chung lớn nhất (GCD)', 'coding', 'Đọc hai số nguyên dương a và b, in ra ước chung lớn nhất của chúng.', 'c', '#include <stdio.h>

int gcd(int a, int b) {
    // Cài đặt thuật toán Euclid
    return 1;
}

int main(void) {
    int a, b;
    scanf("%d %d", &a, &b);
    printf("%d\n", gcd(a, b));
    return 0;
}
', '#include <stdio.h>

int gcd(int a, int b) {
    while (b != 0) {
        int r = a % b;
        a = b;
        b = r;
    }
    return a;
}

int main(void) {
    int a = 1, b = 1;
    if (scanf("%d %d", &a, &b) == 2) {
        printf("%d\n", gcd(a, b));
    }
    return 0;
}
', '48 18', '6', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('072a4755-75ff-5fda-bd2d-4638091960de', '01678aeb-5b6e-55b8-b3ce-8d72cf53a65e', '48 và 18', '48 18
', '6', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('b4021463-0bf1-53d1-9528-6698c44c9245', '01678aeb-5b6e-55b8-b3ce-8d72cf53a65e', 'Nguyên tố cùng nhau', '17 13
', '1', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('12ca0b7e-2048-5144-a107-146bc78931c1', '01678aeb-5b6e-55b8-b3ce-8d72cf53a65e', 'Bội số của nhau', '100 25
', '25', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('24c4a94d-7f6e-505e-9d97-234ef99f75b7', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch01', 'Introduction to Python', 'Giới thiệu Python 3, trình thông dịch và hàm print().', 1, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('dc2cf558-4b3a-54ed-a43c-2fe92cc2ef56', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '24c4a94d-7f6e-505e-9d97-234ef99f75b7', 'py-ch01-lesson-1', 'Chương trình Python đầu tiên', 'Viết và chạy lệnh Python 3 đầu tiên với hàm print().', 'Python là ngôn ngữ thông dịch có cú pháp rõ ràng, dễ đọc. Khác với C, bạn không cần khai báo hàm `main` hay kết thúc câu lệnh bằng dấu chấm phẩy.', 'print("Hello, Python!")
', '- `print(...)` in đối tượng ra đầu ra chuẩn kèm ký tự xuống dòng.', '- Viết `Print` (chữ P viết hoa) — Python phân biệt chữ hoa và chữ thường.', 'Python sử dụng cú pháp gọn gàng và phân biệt hoa/thường.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('58213e88-1e7a-5abc-9a32-8ea1f749c07c', 'dc2cf558-4b3a-54ed-a43c-2fe92cc2ef56', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('022dde20-cb80-5b38-8c89-9ed39254f1a5', 'dc2cf558-4b3a-54ed-a43c-2fe92cc2ef56', 'In lời chào Python', 'coding', 'Viết chương trình Python in ra đúng một dòng:
Hello from Python 3', 'python', '# Viết lệnh print tại đây
', 'print("Hello from Python 3")
', '', 'Hello from Python 3', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('883ed2f8-cc2d-53d3-9364-fd79e3095ab0', '022dde20-cb80-5b38-8c89-9ed39254f1a5', 'Kiểm tra đầu ra chuẩn', '', 'Hello from Python 3', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('7a6baff8-957c-50ce-a979-e608dda062e5', '022dde20-cb80-5b38-8c89-9ed39254f1a5', 'Kiểm tra chính xác ký tự', '', 'Hello from Python 3', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('b9406f53-71f4-5bea-bede-f6799625c82a', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch02', 'Variables and Data Types', 'Biến động (dynamic typing), int, float, str, bool và hàm type().', 2, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('3ae679bf-2044-564f-a498-ecf847cc3390', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'b9406f53-71f4-5bea-bede-f6799625c82a', 'py-ch02-lesson-1', 'Biến và kiểu dữ liệu trong Python', 'Hiểu dynamic typing và các kiểu dữ liệu cơ bản của Python 3.', 'Trong Python, bạn gán giá trị trực tiếp cho biến mà không cần khai báo kiểu trước. Các kiểu cơ bản gồm `int`, `float`, `str`, `bool`.', 'name = "An"
age = 20
is_student = True
print(type(age).__name__, name, is_student)
', '- `age = 20` tạo biến kiểu `int`.
- `is_student = True` dùng chữ `T` viết hoa.
- `type(age).__name__` trả về `''int''`.', '- Viết `true` thay vì `True` gây `NameError`.', 'Boolean trong Python là `True` và `False` (viết hoa chữ đầu).', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('11e18e4c-da4f-5f01-beb7-3ff6b6baeb90', '3ae679bf-2044-564f-a498-ecf847cc3390', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, pass_threshold, is_required, sort_order) VALUES ('6ed75a1c-6b36-52b6-ad46-f81785095c8a', '3ae679bf-2044-564f-a498-ecf847cc3390', 'Quiz: Biến & Kiểu dữ liệu Python', 'quiz', 'Trả lời đủ 5 câu hỏi trắc nghiệm về biến và kiểu dữ liệu Python 3.', 'python', 80, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('6ec715c5-4bbb-58fe-b252-727440fd2fb9', '6ed75a1c-6b36-52b6-ad46-f81785095c8a', 'Giá trị kiểu boolean đúng trong Python 3 được viết như thế nào?', 'Python dùng `True` và `False` viết hoa chữ cái đầu.', 'Khác với C/JS dùng `true`, viết thường trong Python sẽ báo `NameError`.', 1) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('2396258d-3f8a-50e8-8471-32beccb85239', '6ec715c5-4bbb-58fe-b252-727440fd2fb9', 'A', 'true', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f4bd4c36-6143-52c9-b514-f46b3033bac9', '6ec715c5-4bbb-58fe-b252-727440fd2fb9', 'B', 'True', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('e8b2bf87-8e08-54f0-8c8c-f064d0602a59', '6ec715c5-4bbb-58fe-b252-727440fd2fb9', 'C', 'TRUE', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('4f202b3d-fc82-56f9-84ea-c7ef1d0d411b', '6ec715c5-4bbb-58fe-b252-727440fd2fb9', 'D', 'yes', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('eaab1a6d-5200-5e6f-b51e-615c3b6f21c6', '6ed75a1c-6b36-52b6-ad46-f81785095c8a', 'Hàm tích hợp nào trả về kiểu dữ liệu của một đối tượng trong Python?', '`type(x)` trả về kiểu (class) của `x`.', '`typeof` là toán tử của JavaScript, không có trong Python.', 2) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('db2d6ce6-d2fc-5741-86cd-27a8262c3110', 'eaab1a6d-5200-5e6f-b51e-615c3b6f21c6', 'A', 'typeof()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('6d09836a-b145-59a2-9ad0-96242200da71', 'eaab1a6d-5200-5e6f-b51e-615c3b6f21c6', 'B', 'type()', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('3892cf43-d3b9-53eb-baff-9a40e1f28632', 'eaab1a6d-5200-5e6f-b51e-615c3b6f21c6', 'C', 'datatype()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('bc0920a2-3b3d-536b-acad-de68ff1a8948', 'eaab1a6d-5200-5e6f-b51e-615c3b6f21c6', 'D', 'kind()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('7ec7d355-05da-5936-a26c-bec02a32a229', '6ed75a1c-6b36-52b6-ad46-f81785095c8a', 'Kết quả của `type(3.0)` là gì?', 'Số có dấu chấm thập phân là `float` trong Python.', 'Python không có kiểu `double` riêng; `float` của Python có độ chính xác kép.', 3) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('26533216-981d-5204-a928-b474c304c4b0', '7ec7d355-05da-5936-a26c-bec02a32a229', 'A', 'int', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('6d48721c-89d1-57b7-bcb3-8f2d56565116', '7ec7d355-05da-5936-a26c-bec02a32a229', 'B', 'float', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('0b61b6bf-f61d-504d-bd36-a6e2c3783509', '7ec7d355-05da-5936-a26c-bec02a32a229', 'C', 'str', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('6a607414-a7a7-540f-bcc9-83062515ab0b', '7ec7d355-05da-5936-a26c-bec02a32a229', 'D', 'double', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('7cad0e05-b8db-5bf8-8695-737dda99a117', '6ed75a1c-6b36-52b6-ad46-f81785095c8a', 'Tên biến nào sau đây KHÔNG hợp lệ trong Python?', 'Tên biến không được bắt đầu bằng chữ số.', 'Chữ số chỉ được phép xuất hiện sau ký tự đầu tiên.', 4) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('34d6a448-f90d-58f0-b319-3f12dbb6773f', '7cad0e05-b8db-5bf8-8695-737dda99a117', 'A', 'user_name', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('2fe40323-9971-533a-993d-ea110888cf3b', '7cad0e05-b8db-5bf8-8695-737dda99a117', 'B', '_count', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('15a1eb3e-d7be-5c53-9b1d-8a4b77624568', '7cad0e05-b8db-5bf8-8695-737dda99a117', 'C', '2nd_place', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('64be94aa-976e-5652-8e26-e5b9389afdab', '7cad0e05-b8db-5bf8-8695-737dda99a117', 'D', 'score2', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('4487b912-84af-5cf3-ad85-f73f188f44fb', '6ed75a1c-6b36-52b6-ad46-f81785095c8a', 'Theo PEP 8, quy ước đặt tên biến thông thường trong Python là gì?', 'PEP 8 khuyến nghị dùng `snake_case` cho biến và hàm.', '`PascalCase` dành cho tên class, còn `ALL_CAPS` dành cho hằng số.', 5) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('0ca515d4-235a-564b-948f-5cbe5e50f404', '4487b912-84af-5cf3-ad85-f73f188f44fb', 'A', 'snake_case', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('a4d9fef2-7c7b-51aa-b85b-6a0d6a4a27d7', '4487b912-84af-5cf3-ad85-f73f188f44fb', 'B', 'PascalCase', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('8ae4a8c4-7fb4-505e-a606-b46c0a83cfe4', '4487b912-84af-5cf3-ad85-f73f188f44fb', 'C', 'kebab-case', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('dd3ae788-375f-5195-807c-2f9b83edef4d', '4487b912-84af-5cf3-ad85-f73f188f44fb', 'D', 'ALLCAPS', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('44f3395d-9cc1-59eb-9335-793d5acb1c48', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch03', 'Input and Output', 'Đọc dữ liệu bằng input(), ép kiểu int()/float() và định dạng f-string.', 3, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('60988a5e-0c26-546b-b700-15ede466f878', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '44f3395d-9cc1-59eb-9335-793d5acb1c48', 'py-ch03-lesson-1', 'Nhập dữ liệu bằng input() và định dạng f-string', 'Chuyển đổi chuỗi từ input() sang số và in kết quả gọn gàng bằng f-string.', 'Hàm `input()` luôn trả về một chuỗi (`str`). Để tính toán số học, bạn cần chuyển đổi bằng `int()` hoặc `float()`.', 'a = int("10")
b = int("5")
print(f"Sum = {a + b}")
', '- `int(...)` chuyển chuỗi số thành kiểu `int`.
- `f"Sum = {a + b}"` chèn trực tiếp biểu thức vào chuỗi.', '- Cộng hai kết quả `input()` trực tiếp khiến `''2'' + ''3''` thành `''23''` thay vì `5`.', 'Luôn ép kiểu kết quả từ `input()` khi cần tính toán số học.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('83333e6f-6f20-52e7-9c0f-93f0f4102b77', '60988a5e-0c26-546b-b700-15ede466f878', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('4ef5e375-5ad7-59d9-9e7e-3b108fa650ef', '60988a5e-0c26-546b-b700-15ede466f878', 'Tính tổng hai số trong Python', 'coding', 'Đọc hai số nguyên trên hai dòng liên tiếp và in ra tổng của chúng.', 'python', '# Đọc 2 số nguyên và in tổng
', 'a = int(input().strip())
b = int(input().strip())
print(a + b)
', '8
12', '20', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('76b4080c-26d7-52b2-8769-cfdaf5cd160c', '4ef5e375-5ad7-59d9-9e7e-3b108fa650ef', 'Hai số dương', '8
12
', '20', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('1f855123-c833-5345-852a-035dc08dc115', '4ef5e375-5ad7-59d9-9e7e-3b108fa650ef', 'Số âm', '-5
9
', '4', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('20a1a272-fcac-51c4-bb49-04b66ce4b93b', '4ef5e375-5ad7-59d9-9e7e-3b108fa650ef', 'Số lớn', '1000
2500
', '3500', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('0035f013-3679-581b-a61a-fd67c1aa7482', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch04', 'Operators', 'Phép chia thực (/), chia lấy nguyên (//), chia dư (%) và lũy thừa (**).', 4, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('9ff6221c-a753-5aac-b1bd-f9b953f5aa28', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '0035f013-3679-581b-a61a-fd67c1aa7482', 'py-ch04-lesson-1', 'Toán tử chia thực, chia nguyên và lũy thừa', 'Phân biệt `/` và `//` cũng như toán tử `**` trong Python 3.', 'Trong Python 3, `/` luôn trả về `float`, `//` thực hiện phép chia lấy phần nguyên (floor division), và `**` tính lũy thừa.', 'print(7 // 2, 7 % 2, 2 ** 3)
', '- `7 // 2` bằng `3`.
- `7 % 2` bằng `1`.
- `2 ** 3` bằng `8`.', '- Dùng `^` để tính lũy thừa (trong Python `^` là phép XOR bitwise).', 'Dùng `**` cho lũy thừa và `//` cho chia nguyên trong Python 3.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('a8a020f5-584e-5584-80f8-bede79780085', '9ff6221c-a753-5aac-b1bd-f9b953f5aa28', 'The Python Language Reference — Official Python Documentation', 'https://docs.python.org/3/reference/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('97da476f-dbac-5b75-a3db-b6916eae98d4', '9ff6221c-a753-5aac-b1bd-f9b953f5aa28', 'Tính lũy thừa a^b', 'coding', 'Đọc hai số nguyên không âm a và b (trên cùng một dòng cách nhau bởi dấu cách) và in ra a mũ b.', 'python', 'a, b = map(int, input().split())
# In a mũ b
', 'a, b = map(int, input().split())
print(a ** b)
', '2 10', '1024', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('ae48ce2c-eef9-5d95-93ba-2d69bf3fe70e', '97da476f-dbac-5b75-a3db-b6916eae98d4', '2^10', '2 10
', '1024', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('37a5920d-3dd9-5688-ba44-d9fafcfe1d80', '97da476f-dbac-5b75-a3db-b6916eae98d4', 'Mũ 0', '7 0
', '1', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('792e7ffe-a2c4-5b75-8136-046c3ae26266', '97da476f-dbac-5b75-a3db-b6916eae98d4', '3^5', '3 5
', '243', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('fd9c9fef-4580-51e2-bbd3-a5962e76802a', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch05', 'Conditional Statements', 'Cấu trúc if, elif, else và quy tắc thụt lề (indentation).', 5, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('f6137f36-89b4-5aff-8bc8-6ffdceb221ce', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'fd9c9fef-4580-51e2-bbd3-a5962e76802a', 'py-ch05-lesson-1', 'Câu lệnh if / elif / else và thụt lề', 'Rẽ nhánh chương trình theo điều kiện trong Python.', 'Python dùng thụt lề (4 khoảng trắng theo PEP 8) thay vì dấu ngoặc nhọn `{}` để xác định khối lệnh.', 'score = 85
if score >= 80:
    print("GOOD")
elif score >= 50:
    print("PASS")
else:
    print("FAIL")
', '- Mỗi nhánh kết thúc bằng dấu hai chấm `:` và thụt lề 4 dấu cách.', '- Quên dấu `:` sau điều kiện `if`/`elif`/`else`.
- Trộn lẫn Tab và Space gây `IndentationError`.', 'Thụt lề nhất quán 4 dấu cách và luôn có dấu `:` sau `if/elif/else`.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('8538cd5d-ad72-5061-8396-71dc6df02615', 'f6137f36-89b4-5aff-8bc8-6ffdceb221ce', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('be8ac7c2-f8b9-5bda-b328-0a0efccbeda5', 'f6137f36-89b4-5aff-8bc8-6ffdceb221ce', 'Phân loại số âm, dương hay bằng 0', 'coding', 'Đọc một số nguyên n. In POSITIVE nếu n > 0, NEGATIVE nếu n < 0, ZERO nếu n == 0.', 'python', 'n = int(input().strip())
# Viết câu lệnh if/elif/else
', 'n = int(input().strip())
if n > 0:
    print("POSITIVE")
elif n < 0:
    print("NEGATIVE")
else:
    print("ZERO")
', '-3', 'NEGATIVE', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('062d4ada-18ef-5416-a6d8-ccb7204fbc8d', 'be8ac7c2-f8b9-5bda-b328-0a0efccbeda5', 'Số dương', '10
', 'POSITIVE', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('a3af45e9-39be-5134-8b6b-e58fb6344abd', 'be8ac7c2-f8b9-5bda-b328-0a0efccbeda5', 'Số âm', '-3
', 'NEGATIVE', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('3f2c7129-ccb3-5807-824e-75ebbe835b0f', 'be8ac7c2-f8b9-5bda-b328-0a0efccbeda5', 'Số 0', '0
', 'ZERO', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('5e8ec236-022a-5f5e-8b2a-9251038e8e87', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch06', 'Loops', 'Vòng lặp for với range(), vòng lặp while, break và continue.', 6, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('289f1051-0366-5c87-9841-fb69c3a8fdeb', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '5e8ec236-022a-5f5e-8b2a-9251038e8e87', 'py-ch06-lesson-1', 'Vòng lặp for với range()', 'Lặp qua dãy số hiệu quả bằng range(start, stop, step).', '`range(1, n + 1)` sinh các số nguyên từ `1` đến `n` (không bao gồm giá trị `stop`).', 'total = 0
for i in range(1, 6):
    total += i
print(total)
', '- `range(1, 6)` tạo các giá trị 1, 2, 3, 4, 5.
- Tổng là 15.', '- Viết `range(1, n)` sẽ thiếu giá trị `n`.', '`range(a, b)` luôn dừng ở `b - 1`.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('fade96ac-5cdb-5dec-8380-27e7a1ed1393', '289f1051-0366-5c87-9841-fb69c3a8fdeb', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('ea356dc8-48a8-5dd9-b0d9-bba49c0a8830', '289f1051-0366-5c87-9841-fb69c3a8fdeb', 'Tính tổng các số chẵn từ 1 đến N', 'coding', 'Đọc số nguyên dương N và in ra tổng tất cả các số chẵn trong đoạn [1, N].', 'python', 'n = int(input().strip())
# Tính tổng số chẵn từ 1 đến n
', 'n = int(input().strip())
print(sum(i for i in range(2, n + 1, 2)))
', '10', '30', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('fe19a630-8743-58e2-8f89-df4f91bba4d4', 'ea356dc8-48a8-5dd9-b0d9-bba49c0a8830', 'N = 10', '10
', '30', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('2e383041-0cf3-5e05-878b-a92f640dbeb2', 'ea356dc8-48a8-5dd9-b0d9-bba49c0a8830', 'N = 1', '1
', '0', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('c6a2160a-fa5d-5820-a47c-0a4790ad97ef', 'ea356dc8-48a8-5dd9-b0d9-bba49c0a8830', 'N = 7', '7
', '12', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('99f920d2-80b8-5a05-a815-a8c34c035c38', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch07', 'Functions', 'Định nghĩa hàm bằng def, tham số mặc định và giá trị trả về.', 7, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('26a1d201-2fd5-53e4-903e-60f64d7e4f32', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '99f920d2-80b8-5a05-a815-a8c34c035c38', 'py-ch07-lesson-1', 'Định nghĩa hàm với từ khóa def', 'Tổ chức mã nguồn sạch và tái sử dụng bằng hàm Python.', 'Dùng `def ten_ham(tham_so):` để khai báo hàm. Nếu không có lệnh `return`, hàm mặc định trả về `None`.', 'def square(x: int) -> int:
    return x * x

print(square(6))
', '- `square(6)` trả về `36`.
- Type hints (`x: int -> int`) giúp mã dễ đọc hơn.', '- Dùng `print()` bên trong hàm thay vì `return` khiến kết quả trả về là `None`.', 'Dùng `return` để trả dữ liệu ra khỏi hàm cho nơi gọi sử dụng.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('f3419d6f-d7d2-5a1e-910a-affd673e9cbf', '26a1d201-2fd5-53e4-903e-60f64d7e4f32', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('a1280770-45ab-5c90-9b88-c91ab3458bcd', '26a1d201-2fd5-53e4-903e-60f64d7e4f32', 'Hàm kiểm tra số nguyên tố', 'coding', 'Viết hàm `is_prime(n)` trả về True nếu n là số nguyên tố, ngược lại False. Đọc n từ stdin và in YES hoặc NO.', 'python', 'def is_prime(n: int) -> bool:
    # Cài đặt kiểm tra số nguyên tố
    return False

n = int(input().strip())
print("YES" if is_prime(n) else "NO")
', 'def is_prime(n: int) -> bool:
    if n < 2:
        return False
    d = 2
    while d * d <= n:
        if n % d == 0:
            return False
        d += 1
    return True

n = int(input().strip())
print("YES" if is_prime(n) else "NO")
', '13', 'YES', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('4b23972c-aa1d-57a3-af3b-3e07fffa7847', 'a1280770-45ab-5c90-9b88-c91ab3458bcd', 'Số nguyên tố 13', '13
', 'YES', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('38c0f795-a20f-5bc7-aa3b-9fd97abe5403', 'a1280770-45ab-5c90-9b88-c91ab3458bcd', 'Số 1 không phải nguyên tố', '1
', 'NO', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('a5c518dd-baa0-55e5-8434-8cc57c52d012', 'a1280770-45ab-5c90-9b88-c91ab3458bcd', 'Số 2 là nguyên tố', '2
', 'YES', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('563b9230-4341-5bea-b63c-d9e75220d0c5', 'a1280770-45ab-5c90-9b88-c91ab3458bcd', 'Hợp số 15', '15
', 'NO', TRUE, 4) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('0f189869-740d-5e62-9039-c19ef0b3b80f', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch08', 'Lists and Tuples', 'Danh sách có thể thay đổi (list), bộ bất biến (tuple) và slicing.', 8, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('7b0d379e-9e5c-501a-b267-713b90b7fac4', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '0f189869-740d-5e62-9039-c19ef0b3b80f', 'py-ch08-lesson-1', 'Làm việc với List và Tuple', 'Thao tác thêm, duyệt, sắp xếp list và hiểu tính bất biến của tuple.', '`list` (ngoặc vuông `[]`) có thể thay đổi phần tử (mutable), còn `tuple` (ngoặc tròn `()`) là bất biến (immutable).', 'nums = [5, 2, 9, 1]
print(min(nums), max(nums))
', '- `min(nums)` trả về `1`, `max(nums)` trả về `9`.', '- Cố sửa phần tử của tuple (`t[0] = 5`) gây `TypeError`.', 'Dùng `list` khi dữ liệu cần thay đổi, dùng `tuple` cho bộ giá trị cố định.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('4d05545b-4547-51bb-8d4b-d500d25aac0c', '7b0d379e-9e5c-501a-b267-713b90b7fac4', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('a76ac1a1-0261-59b3-bc52-ad14143940ad', '7b0d379e-9e5c-501a-b267-713b90b7fac4', 'Tìm giá trị lớn nhất trong danh sách', 'coding', 'Đọc một dòng gồm các số nguyên cách nhau bởi dấu cách và in ra số lớn nhất.', 'python', 'nums = list(map(int, input().split()))
# In số lớn nhất
', 'nums = list(map(int, input().split()))
print(max(nums))
', '3 9 2 7', '9', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('afad04ad-b46b-5f1e-81f0-4d71c22a0253', 'a76ac1a1-0261-59b3-bc52-ad14143940ad', 'Danh sách số dương', '3 9 2 7
', '9', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('00fc41d3-d427-54eb-a271-53f619aaf5d0', 'a76ac1a1-0261-59b3-bc52-ad14143940ad', 'Danh sách số âm', '-10 -3 -20
', '-3', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('01cbd05c-8e28-50b4-bf34-115f306291d0', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch09', 'Dictionaries and Sets', 'Cặp khóa-giá trị (dict) và tập hợp không trùng lặp (set).', 9, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('6bf41fd7-0a0a-5767-949d-fdc83f3b80a1', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '01cbd05c-8e28-50b4-bf34-115f306291d0', 'py-ch09-lesson-1', 'Dictionary và Set trong Python', 'Tra cứu O(1) với dict và lọc phần tử duy nhất với set.', '`dict` ánh xạ `key -> value` với tốc độ tra cứu trung bình O(1). `set` lưu tập các phần tử không trùng lặp.', 'counts = {}
for ch in "banana":
    counts[ch] = counts.get(ch, 0) + 1
print(counts["a"])
', '- `counts.get(ch, 0)` trả về `0` nếu khóa chưa tồn tại, tránh `KeyError`.', '- Truy cập `d[key]` trực tiếp khi khóa chưa có gây `KeyError`.', 'Dùng `dict.get(key, default)` để đọc an toàn và `set()` để khử trùng lặp.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('c7aa0610-bf82-5c33-96eb-c34d8daebe83', '6bf41fd7-0a0a-5767-949d-fdc83f3b80a1', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('0c40df55-369f-5173-83f3-805f0821fc70', '6bf41fd7-0a0a-5767-949d-fdc83f3b80a1', 'Đếm số phần tử khác nhau', 'coding', 'Đọc một dòng các số nguyên cách nhau bởi dấu cách và in ra số lượng giá trị khác nhau (unique).', 'python', 'nums = list(map(int, input().split()))
# In số phần tử khác nhau
', 'nums = list(map(int, input().split()))
print(len(set(nums)))
', '1 2 2 3 3 3', '3', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('6b7e5acb-c771-5ac7-8efa-e020fb8731f6', '0c40df55-369f-5173-83f3-805f0821fc70', 'Có phần tử trùng', '1 2 2 3 3 3
', '3', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('c4cc7124-ee4d-541b-9867-7e50098eec09', '0c40df55-369f-5173-83f3-805f0821fc70', 'Tất cả giống nhau', '5 5 5
', '1', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('d5ba5c40-f2d2-5ea4-a3e4-b404fe4c9803', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch10', 'Strings', 'Thao tác chuỗi: slicing, strip, split, join và tính bất biến.', 10, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('df505494-bfdc-5113-8631-3ebde5c3bd97', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'd5ba5c40-f2d2-5ea4-a3e4-b404fe4c9803', 'py-ch10-lesson-1', 'Xử lý chuỗi nâng cao trong Python', 'Dùng slicing và các phương thức chuỗi chuẩn của Python 3.', 'Chuỗi (`str`) trong Python là bất biến. Slicing `s[::-1]` tạo ra bản sao đảo ngược của chuỗi.', 's = "python"
print(s[::-1])
', '- Bước nhảy `-1` duyệt chuỗi từ cuối về đầu, cho ra `''nohtyp''`.', '- Cố gán `s[0] = ''P''` gây `TypeError` vì chuỗi là immutable.', 'Các phương thức chuỗi như `.strip()`, `.lower()`, `.split()` luôn trả về chuỗi/list mới.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('edefe609-c184-55bb-a5d0-fcefa89560f6', 'df505494-bfdc-5113-8631-3ebde5c3bd97', 'The Python Standard Library — Official Python Documentation', 'https://docs.python.org/3/library/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('8610762b-0d00-56f5-8bac-1d95a2e238cb', 'df505494-bfdc-5113-8631-3ebde5c3bd97', 'Kiểm tra chuỗi đối xứng (Palindrome)', 'coding', 'Đọc một chuỗi không dấu cách (chữ thường). In YES nếu chuỗi đọc xuôi ngược giống nhau, ngược lại in NO.', 'python', 's = input().strip()
# Kiểm tra palindrome
', 's = input().strip()
print("YES" if s == s[::-1] else "NO")
', 'level', 'YES', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('88975042-e2c2-5d9a-8a02-890cd7557cf7', '8610762b-0d00-56f5-8bac-1d95a2e238cb', 'Chuỗi đối xứng', 'level
', 'YES', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('b9ccd0af-df87-5fcd-9dbf-471077aa69ed', '8610762b-0d00-56f5-8bac-1d95a2e238cb', 'Không đối xứng', 'python
', 'NO', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('9db895f4-d1e5-542a-8b96-5a7ba69ed027', '8610762b-0d00-56f5-8bac-1d95a2e238cb', '1 ký tự', 'a
', 'YES', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('061e72c5-8180-5f17-ac18-2af3fcfb77f5', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch11', 'File Handling', 'Đọc ghi tệp an toàn bằng câu lệnh with open(...).', 11, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('1e7b731f-617c-5c39-9fa7-e94f205f412d', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '061e72c5-8180-5f17-ac18-2af3fcfb77f5', 'py-ch11-lesson-1', 'Đọc ghi tệp an toàn với Context Manager (with)', 'Sử dụng `with open(...)` để tự động đóng tệp ngay cả khi có ngoại lệ.', 'Trong Python, luôn nên mở tệp bằng `with open(path, mode, encoding=''utf-8'') as f:` để hệ thống tự động gọi `f.close()` khi ra khỏi khối `with`.', 'import io

buf = io.StringIO("line1\nline2\n")
lines = [line.strip() for line in buf]
print(len(lines))
', '- `io.StringIO` mô phỏng file object trong bộ nhớ, hoạt động tương tự file mở bằng `open()`.
- Duyệt từng dòng giúp tiết kiệm bộ nhớ với tệp lớn.', '- Quên chỉ định `encoding=''utf-8''` khi đọc/ghi tiếng Việt trên Windows.', 'Luôn dùng `with open(..., encoding=''utf-8'')` khi làm việc với tệp văn bản.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('92ca2b13-8cf4-5091-a9c5-73b215307e12', '1e7b731f-617c-5c39-9fa7-e94f205f412d', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, pass_threshold, is_required, sort_order) VALUES ('9954746c-34ab-596e-aacc-59c51ebc7eea', '1e7b731f-617c-5c39-9fa7-e94f205f412d', 'Quiz: File Handling trong Python', 'quiz', 'Trả lời đủ 5 câu hỏi về quản lý tệp tin trong Python.', 'python', 80, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('bfefe80c-ec3d-55cd-920e-09d60d909f0a', '9954746c-34ab-596e-aacc-59c51ebc7eea', 'Ưu điểm chính của câu lệnh `with open(...) as f:` là gì?', 'Context manager (`with`) luôn gọi `f.close()` khi thoát khối.', 'Nếu chỉ dùng `f = open(...)` mà gặp exception trước `f.close()`, tệp có thể không được đóng.', 1) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('3030c6d0-e69e-5090-863a-3f7aabd8e41f', 'bfefe80c-ec3d-55cd-920e-09d60d909f0a', 'A', 'Tự động đóng tệp ngay cả khi có lỗi xảy ra', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('0555340a-6eaa-56bb-9f86-676de35b9e3f', 'bfefe80c-ec3d-55cd-920e-09d60d909f0a', 'B', 'Tự động mã hóa tệp', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('e91dd051-29f8-51e1-bcad-b5ebf923f4af', 'bfefe80c-ec3d-55cd-920e-09d60d909f0a', 'C', 'Tăng gấp đôi tốc độ ổ cứng', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('c393d996-cc2e-5d5c-8554-12fa1889e9d4', 'bfefe80c-ec3d-55cd-920e-09d60d909f0a', 'D', 'Bỏ qua mọi lỗi đọc tệp', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('6c576ea4-db85-5251-8f1b-dbb6610edcfa', '9954746c-34ab-596e-aacc-59c51ebc7eea', 'Mode nào dùng để ghi thêm nội dung vào cuối tệp mà không xóa nội dung cũ?', '`''a''` (append) ghi nối tiếp vào cuối tệp.', 'Mode `''w''` sẽ xóa sạch nội dung cũ của tệp.', 2) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('8ec1139d-7cf9-50f3-9242-a7b7a46eacd6', '6c576ea4-db85-5251-8f1b-dbb6610edcfa', 'A', '''r''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('039b10d2-c0cd-5c37-b77f-4ce16f82c8eb', '6c576ea4-db85-5251-8f1b-dbb6610edcfa', 'B', '''w''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('dc06fa3f-b2ef-5edb-9287-8a15b52262d1', '6c576ea4-db85-5251-8f1b-dbb6610edcfa', 'C', '''a''', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('fa6c8cf0-0849-53e3-952d-5ba2cb689c4b', '6c576ea4-db85-5251-8f1b-dbb6610edcfa', 'D', '''x''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('49c20b88-77bd-5029-8044-0e8cd0d244e8', '9954746c-34ab-596e-aacc-59c51ebc7eea', 'Tham số nào nên truyền vào `open()` khi xử lý tệp văn bản tiếng Việt?', '`encoding=''utf-8''` đảm bảo đọc/ghi Unicode nhất quán trên mọi hệ điều hành.', 'Không truyền encoding có thể gây `UnicodeDecodeError` trên Windows.', 3) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('8cb70ab8-15df-52fb-bd2e-f9481ba1e435', '49c20b88-77bd-5029-8044-0e8cd0d244e8', 'A', 'charset=''ascii''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('9809141d-820c-5180-8a15-845645eba537', '49c20b88-77bd-5029-8044-0e8cd0d244e8', 'B', 'encoding=''utf-8''', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f67e9191-6f21-52e1-8387-261df5fac96a', '49c20b88-77bd-5029-8044-0e8cd0d244e8', 'C', 'lang=''vi''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('c4e0f80f-66c2-518a-8fef-db579deb5acb', '49c20b88-77bd-5029-8044-0e8cd0d244e8', 'D', 'format=''text''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('71669a65-7e6b-5d5d-9cdb-fd2a2f8ee257', '9954746c-34ab-596e-aacc-59c51ebc7eea', 'Phương thức nào đọc toàn bộ các dòng thành một `list` các chuỗi?', '`f.readlines()` trả về danh sách các dòng trong tệp.', 'Với tệp rất lớn, nên lặp `for line in f:` thay vì tải hết bằng `readlines()`.', 4) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('e8f2f070-8cfd-58d4-b18b-6666bfff9e99', '71669a65-7e6b-5d5d-9cdb-fd2a2f8ee257', 'A', 'f.readlines()', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('313ae75b-6a93-54d4-852b-e63b56997459', '71669a65-7e6b-5d5d-9cdb-fd2a2f8ee257', 'B', 'f.readall()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f9be2804-352b-5bc7-8b7f-08237228d5c2', '71669a65-7e6b-5d5d-9cdb-fd2a2f8ee257', 'C', 'f.getlines()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('12adf33f-3c79-5ea5-b327-7fe860321dad', '71669a65-7e6b-5d5d-9cdb-fd2a2f8ee257', 'D', 'f.lines()', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('5e4bf794-2826-5c13-8560-3c2a713474cb', '9954746c-34ab-596e-aacc-59c51ebc7eea', 'Mode `''rb''` trong `open()` có nghĩa là gì?', '`''r''` là đọc, `''b''` là binary — dùng cho ảnh, PDF, ZIP.', 'Không truyền `encoding` khi mở tệp ở chế độ binary.', 5) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('da966d22-8194-5cf4-b50d-a5513717a8b9', '5e4bf794-2826-5c13-8560-3c2a713474cb', 'A', 'Đọc tệp nhị phân (read binary)', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('322f4652-70bd-5be2-b3c6-b6961017c21a', '5e4bf794-2826-5c13-8560-3c2a713474cb', 'B', 'Đọc và xóa tệp', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('8882553b-bcc0-5104-b553-dd373ec63577', '5e4bf794-2826-5c13-8560-3c2a713474cb', 'C', 'Ghi tệp backup', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('ad128708-9ca0-5267-9bd1-16073d6fdfd3', '5e4bf794-2826-5c13-8560-3c2a713474cb', 'D', 'Đọc tệp ở chế độ nền', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('2807a5a8-19a7-5a68-b595-47814532fee2', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch12', 'Exception Handling', 'Bắt và xử lý ngoại lệ với try, except, else và finally.', 12, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('bbe58341-ba30-5ba4-a56b-486a980c5d3b', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '2807a5a8-19a7-5a68-b595-47814532fee2', 'py-ch12-lesson-1', 'Xử lý ngoại lệ với try / except', 'Ngăn chương trình dừng đột ngột khi gặp dữ liệu lỗi hoặc phép chia cho 0.', 'Khối `try ... except SpecificError:` giúp bắt đúng loại lỗi (như `ZeroDivisionError`, `ValueError`) và xử lý an toàn.', 'try:
    x = 10 // 0
except ZeroDivisionError:
    print("Cannot divide by zero")
', '- Khi `10 // 0` ném `ZeroDivisionError`, luồng nhảy sang khối `except`.', '- Dùng `except:` trống không chỉ định loại lỗi, vô tình che giấu bug nghiêm trọng.', 'Luôn bắt đúng lớp ngoại lệ cụ thể thay vì dùng bare `except:`.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('170633f4-dfe6-5f75-9a5e-4523109f50db', 'bbe58341-ba30-5ba4-a56b-486a980c5d3b', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('772e6e4f-3d26-5bf5-a9c0-e775ab4c43aa', 'bbe58341-ba30-5ba4-a56b-486a980c5d3b', 'Phép chia nguyên an toàn', 'coding', 'Đọc hai số nguyên a và b (cách nhau bởi dấu cách). In ra a // b, nếu b == 0 thì in ERROR.', 'python', 'a, b = map(int, input().split())
# Dùng try/except ZeroDivisionError
', 'a, b = map(int, input().split())
try:
    print(a // b)
except ZeroDivisionError:
    print("ERROR")
', '10 0', 'ERROR', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('8f5409d1-d7b1-58ff-bcd0-f1a645f17d34', '772e6e4f-3d26-5bf5-a9c0-e775ab4c43aa', 'Chia cho 0', '10 0
', 'ERROR', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('6202712e-c91e-50c9-af44-ddb548a707e2', '772e6e4f-3d26-5bf5-a9c0-e775ab4c43aa', 'Chia bình thường', '15 4
', '3', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('8af105c4-49c1-5c41-9e54-03ffdc70623c', '772e6e4f-3d26-5bf5-a9c0-e775ab4c43aa', 'Số âm', '-9 3
', '-3', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('84a86815-3386-5af1-abc7-778180fa567f', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch13', 'Object-Oriented Programming', 'Lớp (class), hàm khởi tạo __init__, thuộc tính và phương thức.', 13, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('4b2b76c1-fe7d-5ec3-9f30-d48d98ce5b73', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '84a86815-3386-5af1-abc7-778180fa567f', 'py-ch13-lesson-1', 'Lập trình hướng đối tượng (OOP) với class', 'Định nghĩa class, phương thức khởi tạo __init__ và tham số self.', 'Class là bản thiết kế để tạo đối tượng (instance). Phương thức `__init__(self, ...)` chạy tự động khi khởi tạo đối tượng mới.', 'class Rectangle:
    def __init__(self, w: int, h: int):
        self.w = w
        self.h = h

    def area(self) -> int:
        return self.w * self.h

print(Rectangle(3, 5).area())
', '- `self` đại diện cho chính đối tượng đang được thao tác.
- `area()` trả về tích `self.w * self.h`.', '- Quên tham số `self` khi định nghĩa phương thức trong class.', 'Tham số đầu tiên của mọi phương thức thực thể (instance method) là `self`.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('045bffb9-9132-50a4-968f-faa76417a9a5', '4b2b76c1-fe7d-5ec3-9f30-d48d98ce5b73', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('096f0df7-955e-5348-a256-e0b902e9b758', '4b2b76c1-fe7d-5ec3-9f30-d48d98ce5b73', 'Lớp Rectangle tính chu vi và diện tích', 'coding', 'Đọc hai số nguyên dương w và h. Dùng class `Rectangle` để in ra diện tích và chu vi cách nhau bởi dấu cách.', 'python', 'class Rectangle:
    def __init__(self, w: int, h: int):
        self.w = w
        self.h = h
    # Thêm phương thức area() và perimeter()

w, h = map(int, input().split())
r = Rectangle(w, h)
print(r.area(), r.perimeter())
', 'class Rectangle:
    def __init__(self, w: int, h: int):
        self.w = w
        self.h = h

    def area(self) -> int:
        return self.w * self.h

    def perimeter(self) -> int:
        return 2 * (self.w + self.h)

w, h = map(int, input().split())
r = Rectangle(w, h)
print(r.area(), r.perimeter())
', '4 5', '20 18', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('a246bea9-128f-586a-9756-02bcb33b81ef', '096f0df7-955e-5348-a256-e0b902e9b758', 'Hình chữ nhật 4x5', '4 5
', '20 18', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('bf405baa-20f2-5718-8662-f7d9c83555f3', '096f0df7-955e-5348-a256-e0b902e9b758', 'Hình vuông 3x3', '3 3
', '9 12', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('828aec69-78b1-5a2b-8ee4-f095285e47fa', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch14', 'Modules and Packages', 'Tổ chức mã nguồn theo module, import và cấu trúc __name__ == ''__main__''.', 14, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('5670a945-7c03-5709-9d3d-6a129a64e3b0', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '828aec69-78b1-5a2b-8ee4-f095285e47fa', 'py-ch14-lesson-1', 'Module, Package và if __name__ == ''__main__''', 'Chia nhỏ chương trình Python thành các module dễ bảo trì.', 'Mỗi tệp `.py` là một module. Khi chạy trực tiếp tệp đó, biến `__name__` có giá trị `''__main__''`; khi được import từ tệp khác, `__name__` là tên module.', 'import math

def circle_area(r: float) -> float:
    return math.pi * r * r

if __name__ == "__main__":
    print(round(circle_area(2), 2))
', '- `import math` nạp module toán học chuẩn.
- Khối `if __name__ == "__main__":` ngăn code test chạy ngoài ý muốn khi module được import.', '- Đặt tên tệp trùng tên module chuẩn (ví dụ `math.py` hoặc `json.py`) làm che khuất thư viện chuẩn.', 'Không đặt tên file trùng thư viện chuẩn và dùng `if __name__ == "__main__":` cho entry point.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('4429792f-6114-5fa7-81b7-594c16c1b2f2', '5670a945-7c03-5709-9d3d-6a129a64e3b0', 'The Python Tutorial — Official Python Documentation', 'https://docs.python.org/3/tutorial/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, pass_threshold, is_required, sort_order) VALUES ('772ece0b-21d8-5259-bad3-8589a3051a5d', '5670a945-7c03-5709-9d3d-6a129a64e3b0', 'Quiz: Modules và Packages trong Python', 'quiz', 'Trả lời đủ 5 câu hỏi về hệ thống module của Python.', 'python', 80, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('ccb82613-5100-58c7-9d72-e99d2ba74ccf', '772ece0b-21d8-5259-bad3-8589a3051a5d', 'Giá trị của `__name__` khi một tệp Python được chạy trực tiếp là gì?', 'Python đặt `__name__ = ''__main__''` cho script chạy trực tiếp.', 'Khi được `import`, `__name__` mới mang tên module.', 1) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('8e50e0e2-fb3e-523c-8647-d6411cc807ef', 'ccb82613-5100-58c7-9d72-e99d2ba74ccf', 'A', '''main''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('68988928-8b54-5885-9b72-9fe7148b47a8', 'ccb82613-5100-58c7-9d72-e99d2ba74ccf', 'B', '''__main__''', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('ac1b94d7-9b4d-551c-bc75-076c223dea65', 'ccb82613-5100-58c7-9d72-e99d2ba74ccf', 'C', '''script''', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('4adcc4ac-93b9-59c8-9d09-69d114a0f75b', 'ccb82613-5100-58c7-9d72-e99d2ba74ccf', 'D', 'Tên tệp .py', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('65a0d34b-afbd-5cb4-855e-eb8a838ee551', '772ece0b-21d8-5259-bad3-8589a3051a5d', 'Cách import nào chỉ nạp hàm `sqrt` từ module `math`?', 'Cú pháp chuẩn là `from math import sqrt`.', 'Đảo ngược thành `import ... from ...` sẽ gây `SyntaxError`.', 2) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('c90c4057-51d2-59d2-a5ac-55d66cbc0b1f', '65a0d34b-afbd-5cb4-855e-eb8a838ee551', 'A', 'import sqrt from math', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('a9d875e6-1406-5b31-be79-0cc92fee5185', '65a0d34b-afbd-5cb4-855e-eb8a838ee551', 'B', 'from math import sqrt', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('4ee6fd28-21ba-5908-bf7e-357fb4e54ad4', '65a0d34b-afbd-5cb4-855e-eb8a838ee551', 'C', 'using math.sqrt', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('4f5ec19c-0e20-5abd-bbce-2eea02c51384', '65a0d34b-afbd-5cb4-855e-eb8a838ee551', 'D', 'include math.sqrt', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('43ac8a62-2ba2-559d-aa6c-aefc33d835af', '772ece0b-21d8-5259-bad3-8589a3051a5d', 'Vì sao nên tránh dùng `from module import *` trong dự án thực tế?', 'Wildcard import khiến khó biết hàm đến từ đâu và dễ ghi đè tên trùng.', 'PEP 8 khuyến nghị import tường minh.', 3) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('bba14e92-f1f8-5564-afbd-990e387d172d', '43ac8a62-2ba2-559d-aa6c-aefc33d835af', 'A', 'Làm ô nhiễm namespace và dễ xung đột tên hàm/biến', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('90bc5209-adf2-544b-a703-2a452793d4c1', '43ac8a62-2ba2-559d-aa6c-aefc33d835af', 'B', 'Python 3 cấm hoàn toàn cú pháp này', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('085a77ab-01df-54b5-ad62-80319e247c5d', '43ac8a62-2ba2-559d-aa6c-aefc33d835af', 'C', 'Không import được hàm nào', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('aa38b9a2-d561-5988-9c50-65594afe7690', '43ac8a62-2ba2-559d-aa6c-aefc33d835af', 'D', 'Làm tăng kích thước ổ đĩa', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('760e7891-c9b6-571d-9902-797f20963da1', '772ece0b-21d8-5259-bad3-8589a3051a5d', 'Điều gì xảy ra nếu bạn tạo tệp tên `json.py` trong thư mục dự án rồi chạy `import json`?', 'Thư mục hiện tại đứng đầu `sys.path`, nên tệp cùng tên sẽ bị import thay vì stdlib.', 'Đây là lỗi rất hay gặp với người mới khi đặt tên `random.py` hay `math.py`.', 4) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('f6b6ec56-44c4-5788-bdee-cc1a6c3e8df8', '760e7891-c9b6-571d-9902-797f20963da1', 'A', 'Python luôn ưu tiên thư viện chuẩn', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('bd2302c6-1ba4-57ea-a780-fbe1165f6da7', '760e7891-c9b6-571d-9902-797f20963da1', 'B', 'Tệp `json.py` của bạn che khuất (shadow) module `json` chuẩn', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('ab2828af-9eae-5ede-96a8-1dd53e4f4a86', '760e7891-c9b6-571d-9902-797f20963da1', 'C', 'Python tự động đổi tên tệp', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('cb26e44f-32a1-576d-8054-bb999c51a03e', '760e7891-c9b6-571d-9902-797f20963da1', 'D', 'Không có ảnh hưởng gì', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_questions (id, exercise_id, question_text, explanation, common_misconception, sort_order) VALUES ('b4a3f976-286f-5b43-88e4-540243b65569', '772ece0b-21d8-5259-bad3-8589a3051a5d', 'Tệp nào thường dùng để đánh dấu một thư mục là regular package trong Python?', '`__init__.py` khởi tạo regular package trong Python.', 'Dù Python 3.3+ hỗ trợ namespace packages, `__init__.py` vẫn là chuẩn phổ biến.', 5) ON CONFLICT (exercise_id, sort_order) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('b64cb799-f1d4-5455-8c3e-bdf2652e7110', 'b4a3f976-286f-5b43-88e4-540243b65569', 'A', 'package.json', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('a205acc3-ba29-5f12-93bd-08728b382169', 'b4a3f976-286f-5b43-88e4-540243b65569', 'B', '__init__.py', TRUE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('dd2af96d-d409-5722-b48c-7fac8e633de0', 'b4a3f976-286f-5b43-88e4-540243b65569', 'C', 'index.py', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.quiz_options (id, question_id, option_label, option_text, is_correct) VALUES ('e2fe90a9-0242-560f-93e8-e549709dfb1a', 'b4a3f976-286f-5b43-88e4-540243b65569', 'D', 'setup.cfg', FALSE) ON CONFLICT (question_id, option_label) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('606d7e0e-fa0b-5b17-8b30-6a9c44751a44', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch15', 'Python Standard Library', 'Sử dụng thư viện chuẩn: math, collections, datetime, json.', 15, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('0eb99beb-7ea6-512c-9830-2dbb5e01913a', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '606d7e0e-fa0b-5b17-8b30-6a9c44751a44', 'py-ch15-lesson-1', 'Khám phá Python Standard Library (collections & math)', 'Tận dụng sức mạnh thư viện chuẩn có sẵn không cần cài đặt thêm.', 'Python đi kèm triết lý ''batteries included''. Module `collections.Counter` giúp đếm tần suất phần tử cực nhanh và ngắn gọn.', 'from collections import Counter

c = Counter(["a", "b", "a", "c", "a"])
print(c.most_common(1)[0][0])
', '- `Counter` đếm số lần xuất hiện của từng phần tử.
- `most_common(1)` trả về phần tử xuất hiện nhiều nhất.', '- Tự viết vòng lặp lồng nhau O(n^2) để đếm tần suất thay vì dùng `Counter` O(n).', 'Ưu tiên dùng Python Standard Library (`collections`, `math`, `json`, `datetime`).', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('2f6685b6-a76e-5b3e-abb7-8dfbfad94cbc', '0eb99beb-7ea6-512c-9830-2dbb5e01913a', 'The Python Standard Library — Official Python Documentation', 'https://docs.python.org/3/library/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('b207fb1d-fad7-562d-8798-df4a64dff25c', '0eb99beb-7ea6-512c-9830-2dbb5e01913a', 'Tìm ký tự xuất hiện nhiều nhất', 'coding', 'Đọc một chuỗi chữ thường (không dấu cách). In ra số lần xuất hiện lớn nhất của một ký tự trong chuỗi.', 'python', 'from collections import Counter

s = input().strip()
# Dùng Counter để tìm tần suất lớn nhất
', 'from collections import Counter

s = input().strip()
print(Counter(s).most_common(1)[0][1])
', 'banana', '3', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('6e87f085-c08c-5565-b2cb-bede25521dbe', 'b207fb1d-fad7-562d-8798-df4a64dff25c', 'banana -> 3 chữ a', 'banana
', '3', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('32679742-9535-5e7e-8c7e-5a1df41c2dcf', 'b207fb1d-fad7-562d-8798-df4a64dff25c', 'abc -> 1', 'abc
', '1', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('bb852fe5-766e-5ad5-86ee-a2725f784135', 'b207fb1d-fad7-562d-8798-df4a64dff25c', 'aaaa -> 4', 'aaaa
', '4', TRUE, 3) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('53409c63-0e95-5b39-bc2c-5f8f1005cc2b', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch16', 'Working with APIs', 'Định dạng JSON, HTTP status codes và xử lý payload API với module json.', 16, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('a62a46cd-c9e3-560f-9864-47d8aff6325f', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '53409c63-0e95-5b39-bc2c-5f8f1005cc2b', 'py-ch16-lesson-1', 'Xử lý dữ liệu JSON từ Web API', 'Parse JSON thành dictionary Python bằng `json.loads` và trích xuất dữ liệu an toàn.', 'Hầu hết REST API hiện đại trao đổi dữ liệu bằng JSON. Module chuẩn `json` của Python chuyển đổi qua lại giữa chuỗi JSON và `dict`/`list` bằng `json.loads()` và `json.dumps()`.', 'import json

payload = ''{"user": "linh", "scores": [80, 90, 100]}''
data = json.loads(payload)
print(data["user"], sum(data["scores"]))
', '- `json.loads(payload)` phân tích chuỗi JSON thành dict Python.
- Truy cập trường `data[''scores'']` như list thông thường.', '- Dùng `eval()` để đọc JSON (rất nguy hiểm về bảo mật) thay vì `json.loads()`.', 'Luôn dùng `json.loads()` để parse JSON và kiểm tra khóa bằng `.get()`.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('321b3093-8dee-570f-b1c8-87279df22bc5', 'a62a46cd-c9e3-560f-9864-47d8aff6325f', 'The Python Standard Library — Official Python Documentation', 'https://docs.python.org/3/library/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('64a37443-e72b-5ca8-82c8-e48dcc244f6e', 'a62a46cd-c9e3-560f-9864-47d8aff6325f', 'Trích xuất tổng điểm từ JSON API payload', 'coding', 'Đọc một chuỗi JSON dạng `{"scores": [10, 20, 30]}` từ stdin và in ra tổng các số trong mảng `scores`.', 'python', 'import json

raw = input().strip()
# Parse JSON và in tổng scores
', 'import json

raw = input().strip()
data = json.loads(raw)
print(sum(data.get("scores", [])))
', '{"scores": [10, 20, 30]}', '60', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('2a0a820f-c268-58f9-ac3f-2d510dc4cd97', '64a37443-e72b-5ca8-82c8-e48dcc244f6e', '3 điểm', '{"scores": [10, 20, 30]}
', '60', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('48ee2037-91a3-5c64-a92f-9126340f944e', '64a37443-e72b-5ca8-82c8-e48dcc244f6e', 'Mảng rỗng', '{"scores": []}
', '0', TRUE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.chapters (id, course_id, slug, title, description, sort_order, is_published) VALUES ('3b06c29a-79de-5828-b942-fd1dd87dfd5a', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', 'py-ch17', 'Basic Data Analysis', 'Thống kê mô tả cơ bản: trung bình (mean), trung vị (median) với module statistics.', 17, TRUE) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lessons (id, course_id, chapter_id, slug, title, summary, content_markdown, code_example, code_explanation, common_mistakes, key_takeaways, language, language_version, difficulty, estimated_minutes, sort_order, is_published, verification_status, last_verified_at) VALUES ('e8b1dc30-064c-5026-9e0f-10b83aa2eeca', 'fff37a5f-7307-5de0-8c8a-7b3fc2ea1397', '3b06c29a-79de-5828-b942-fd1dd87dfd5a', 'py-ch17-lesson-1', 'Phân tích dữ liệu cơ bản với module statistics', 'Tính trung bình (mean) và trung vị (median) trên tập dữ liệu số.', 'Module chuẩn `statistics` của Python cung cấp các hàm thống kê đã kiểm chứng như `mean()`, `median()`, `stdev()` giúp phân tích dữ liệu nhanh mà không cần cài thư viện ngoài.', 'import statistics

values = [10, 20, 30, 40]
print(f"{statistics.mean(values):.2f}")
', '- `statistics.mean(values)` trả về `25`.
- Định dạng `:.2f` in đúng 2 chữ số thập phân `25.00`.', '- Chia cho `len(values)` khi danh sách rỗng gây `ZeroDivisionError`.', 'Dùng `statistics.mean` và `statistics.median` để tổng hợp số liệu chính xác.', 'python', 'Python 3.11+', 'beginner', 15, 1, TRUE, 'verified', NOW()) ON CONFLICT (course_id, slug) DO NOTHING;
INSERT INTO public.lesson_sources (id, lesson_id, source_name, source_url, programming_language, version, last_verified_date, verification_status, notes) VALUES ('9771a6e9-e81f-5b88-9c98-7e19f71e8566', 'e8b1dc30-064c-5026-9e0f-10b83aa2eeca', 'The Python Standard Library — Official Python Documentation', 'https://docs.python.org/3/library/index.html', 'python', 'Python 3.x', CURRENT_DATE, 'verified', 'Đã kiểm chứng biên dịch và chạy thực tế bằng GCC 12 / Python 3.11.') ON CONFLICT (id) DO NOTHING;
INSERT INTO public.exercises (id, lesson_id, title, type, instructions, language, starter_code, solution_code, sample_input, sample_output, pass_threshold, is_required, sort_order) VALUES ('4f41a0a3-961e-5420-adf4-8bebf7f93e80', 'e8b1dc30-064c-5026-9e0f-10b83aa2eeca', 'Tính giá trị trung bình (Mean)', 'coding', 'Đọc một dòng gồm các số thực cách nhau bởi dấu cách và in ra giá trị trung bình làm tròn đúng 2 chữ số thập phân.', 'python', 'import statistics

nums = list(map(float, input().split()))
# In giá trị trung bình với 2 chữ số thập phân
', 'import statistics

nums = list(map(float, input().split()))
print(f"{statistics.mean(nums):.2f}")
', '10 20 30 40', '25.00', 100, TRUE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('b2cda861-00aa-592b-b43c-80d3e91dbefd', '4f41a0a3-961e-5420-adf4-8bebf7f93e80', 'Dãy chẵn', '10 20 30 40
', '25.00', FALSE, 1) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('cad45303-b197-57b5-a69e-8eb60af1119d', '4f41a0a3-961e-5420-adf4-8bebf7f93e80', 'Có số lẻ thập phân', '1 2 4
', '2.33', FALSE, 2) ON CONFLICT (id) DO NOTHING;
INSERT INTO public.coding_test_cases (id, exercise_id, name, input_data, expected_output, is_hidden, sort_order) VALUES ('bb22fe9e-78ba-5601-970f-d53b39a41e4c', '4f41a0a3-961e-5420-adf4-8bebf7f93e80', 'Một giá trị', '7.5
', '7.50', TRUE, 3) ON CONFLICT (id) DO NOTHING;
