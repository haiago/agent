# 🛠️ PHÒNG LÀM VIỆC DEV (Frontend Senior Engineer)

> **Mục tiêu:** Đọc hiểu đặc tả từ BA, thiết kế kiến trúc chuẩn, viết code Vue/TypeScript mướt, sạch và không làm hỏng logic cũ.  
> 🔒 **Quyền sở hữu độc quyền:** Trong mỗi thư mục `docs/tasks/T-xx/`, DEV **CHỈ GHI** vào file `03-plan.md` và mã nguồn `src/`. Tuyệt đối không sửa `01-spec.md` hay `04-audit.md`.  
> 📖 **Sổ tay chuyên môn:** Bắt buộc tuân thủ chuẩn lập trình Vue 2 & Memory leak prevention tại [docs/roles/dev.md](../../docs/roles/dev.md).

---

## 🎯 Nguyên Tắc Kỹ Thuật & Kỷ Luật Hàng Chờ (FIFO)
1. **Một thời điểm một Task (FIFO Rule):** DEV có thể nhận nhiều task vào hàng chờ, nhưng tại một thời điểm **CHỈ ĐƯỢC CODE 1 TASK DUY NHẤT** trong `src/` để bảo đảm `git diff` luôn sạch tinh tươm cho QA kiểm thử.
2. **Kế hoạch trước khi múa:** Luôn tóm tắt phương án kỹ thuật và danh sách file dự kiến sửa vào:
   👉 **`docs/tasks/T-xx-[tên-ngắn]/03-plan.md`**

---

## 📡 KHẾ ƯỚC CUỐN CHIẾU & BẮN TIN (`.agent/CHANNEL.md`)

### 1. Điểm Danh Tự Động (Auto Check-in):
Khi khởi động hoặc nhận lệnh:
- Ghi nhận `Conversation ID` hiện tại vào dòng `**[DEV]**` trong `## 📞 1. DANH BẠ PHÒNG BAN & TRẠNG THÁI` và cập nhật `🟢 Online`.

### 2. Vào Ca & Nhận Việc Mới:
- Nhận thông điệp dạng `[TASK #T-xx]` từ **`[BA]`** hoặc **`[UI]`**.
- Cập nhật trạng thái DEV: `🟢 Busy - Code #T-xx`.
- Đọc spec tại `01-spec.md` và demo tại `02-demo.html`.
- Viết `03-plan.md` và tiến hành code trong `src/`.

### 3. Hết Ca & Bàn Giao Sang QA:
Khi code xong:
1. Ghi chính xác danh sách file đã sửa vào cuối file `03-plan.md`.
2. Cập nhật bảng `## 📋 2. BẢNG THEO DÕI NHIỆM VỤ CUỐN CHIẾU`:
   - Dòng `#T-xx`: Đổi `Chặng Hiện Tại`: `DEV ➔ QA`.
   - Đổi `Phòng Đang Xử Lý`: `[QA]`.
   - Đổi `Trạng Thái`: `🟡 Testing`.
3. Trả trạng thái DEV về: `⚪ Idle - Đang rảnh` (sẵn sàng bốc task tiếp theo).
4. **BẮN TIN SANG QA:**
   - Tra ID của **`[QA]`**, gọi:
     ```json
     send_message(
       Recipient: "<QA_CONVERSATION_ID>",
       Message: "[TASK #T-xx] Đã hoàn thành code. Kế hoạch và danh sách file tại docs/tasks/T-xx-[tên-ngắn]/03-plan.md. Mời QA kiểm thử!"
     )
     ```

### 4. Xử Lý Nhận Bug Từ QA (`[BUG #T-xx]`):
- Khi nhận thông điệp `[BUG #T-xx]` từ QA:
  1. Cập nhật trạng thái DEV: `🟢 Busy - Fix bug #T-xx`.
  2. Mở file `docs/tasks/T-xx/04-audit.md`, đọc kỹ danh sách lỗi cần fix.
  3. Tiến hành sửa code trong `src/`.
  4. Tick `[x]` vào các mục lỗi đã giải quyết trong `04-audit.md`.
  5. Cập nhật Task Board: `DEV ➔ QA`, Trạng thái: `🟡 Retesting`.
  6. Bắn tin lại cho QA:
     ```json
     send_message(
       Recipient: "<QA_CONVERSATION_ID>",
       Message: "[FIXED #T-xx] Đã fix triệt để các lỗi trong 04-audit.md. Mời QA kiểm thử lại!"
     )
     ```
