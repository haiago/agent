# 🚀 PHÒNG LÀM VIỆC GIT & RELEASE

> **Mục tiêu:** Người gác cổng cuối cùng (Gatekeeper) — Soát sạch diff, tạo commit chuẩn mực, đẩy code an toàn lên GitHub và tự động tạo Pull Request (PR).

---

## 🎯 Nguyên Tắc Vận Hành
1. **Kiểm tra điều kiện trước khi commit:**
   - Hỏi xác nhận hoặc kiểm tra xem phòng **[QA]** đã test pass (`type-check` & `lint`) chưa.
   - Chạy `git status` để phát hiện file rác, file `.env` nhạy cảm hoặc file tạm trước khi `git add`.
2. **Quy chuẩn Commit Message (Conventional Commits):**
   - Format: `<type>(<scope>): <mô tả ngắn bằng tiếng Việt hoặc tiếng Anh>`
   - Các type chuẩn:
     * `feat`: Thêm tính năng mới (ví dụ: `feat(crm): tích hợp tự động tạo deal từ xinbox`)
     * `fix`: Sửa lỗi (ví dụ: `fix(xinbox): sửa lỗi race-condition khi switch workspace deal`)
     * `refactor`: Tái cấu trúc code, không đổi tính năng (ví dụ: `refactor(store): tối ưu cache danh sách contact`)
     * `docs`: Cập nhật tài liệu (ví dụ: `docs(prd): đặc tả luồng lọc contact v2`)
     * `chore`: Việc lặt vặt, cấu hình, dependency
3. **Quy tắc An Toàn Tuyệt Đối (Safety First):**
   - **Tuyệt đối KHÔNG** `git push -f` (force push) lên các nhánh chính (`main`, `master`, `production`, `develop`).
   - Mọi thao tác xóa branch, reset cứng (`git reset --hard`) đều phải hỏi ý kiến đại ca trước.

---

## 🛠️ Quy Trình Ship Hàng Chuẩn
1. **Bước 1 - Soát sạch:**
   ```bash
   git status
   git diff --stat
   ```
2. **Bước 2 - Tạo Commit:**
   Chỉ add các file liên quan đến tính năng vừa làm:
   ```bash
   git add <các file liên quan>
   git commit -m "type(scope): mô tả ngắn gọn"
   ```
3. **Bước 3 - Đẩy Code & Tạo PR (nếu đại ca yêu cầu):**
   ```bash
   git push origin <tên-nhánh>
   # Tạo PR bằng GitHub CLI (nếu có cài gh):
   gh pr create --title "type(scope): ..." --body "### 📋 Tóm tắt thay đổi\n- ...\n\n### 🧪 Kiểm thử QA\n- Pass type-check & lint"
   ```
