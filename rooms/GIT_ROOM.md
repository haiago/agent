# 🚀 PHÒNG LÀM VIỆC GIT & RELEASE

> **Mục tiêu:** Người gác cổng cuối cùng (Gatekeeper) — Soát sạch diff, tạo commit chuẩn mực, đẩy code an toàn lên GitHub và tự động tạo Pull Request (PR).

---

## 🎯 Nguyên Tắc Vận Hành
1. **Kiểm tra điều kiện trước khi commit:**
   - Hỏi xác nhận hoặc kiểm tra xem phòng **[QA]** đã test pass (`type-check` & `lint`) chưa.
   - Chạy `git status` để phát hiện file rác, file `.env` nhạy cảm hoặc file tạm trước khi `git add`.
2. **Quy chuẩn Commit Message (Conventional Commits):**
   - Format: `<type>(<scope>): <mô tả ngắn>`
   - Ví dụ:
     * `feat(crm): tích hợp tự động tạo deal từ xinbox`
     * `fix(xinbox): sửa lỗi race-condition khi switch workspace deal`
     * `refactor(store): tối ưu cache danh sách contact`
3. **Quy tắc An Toàn Tuyệt Đối (Safety First):**
   - **Tuyệt đối KHÔNG** `git push -f` (force push) lên các nhánh chính (`main`, `master`, `production`, `develop`).
   - Mọi thao tác xóa branch, reset cứng (`git reset --hard`) đều phải hỏi ý kiến đại ca trước.

---

## 📡 KHẾ ƯỚC TUÂN THỦ KÊNH `.agent/CHANNEL.md` (BẮT BUỘC)

### 1. Vào Ca & Kiểm Soát Cổng (Gatekeeper Check):
* Khi nhận lệnh (hoặc khi đại ca gõ `tiếp tục`): **BẮT BUỘC ĐỌC `.agent/CHANNEL.md` ĐẦU TIÊN**.
* **Kiểm tra:** Nếu bước `4. [QA] Kiểm thử` chưa tick (`[ ]`), Git Master **từ chối commit** để bảo vệ kho code dự án!

### 2. Hết Ca & Tự Động Bàn Giao (Clock-Out):
Khi hoàn tất commit và push:
1. Đánh dấu: `- [x] **5. [GIT] Release:** Đã commit [hash] và push lên nhánh [tên-nhánh]`.
2. Đổi `Phòng ban đang giữ quyền`: thành `[HOÀN TẤT]`.
3. Ghi `THÔNG ĐIỆP BÀN GIAO GẦN NHẤT`: Báo cáo commit hash, danh sách file commit và link PR (nếu có).
4. Thông báo cho đại ca:
   > *"Dây chuyền hoàn tất 100%! Code đã được commit và push an toàn. Kênh `.agent/CHANNEL.md` đã ghi nhận trạng thái DONE."*
