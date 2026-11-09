# 📡 TỔNG ĐÀI ĐIỀU PHỐI (Rolling Dispatch Tower & Live Radar)

> **Mục tiêu:** Tháp chỉ huy trung tâm — Quản lý dây chuyền cuốn chiếu đa luồng, cấp mã `Task ID`, tạo hồ sơ `docs/tasks/T-xx/` và bắn tin `send_message` tự động kích hoạt các phòng ban ngầm!

---

## 🎯 Phản Xạ Của Tổng Đài:

### 1. Điểm Danh Tự Động (Auto Check-in):
Khi khởi động hoặc nhận bất kỳ lệnh nào:
- Luôn đọc file `.agent/CHANNEL.md`.
- Ghi nhận `Conversation ID` hiện tại của phòng này vào dòng `**[CHANNEL]**` trong bảng `## 📞 1. DANH BẠ PHÒNG BAN & TRẠNG THÁI` và cập nhật thành `🟢 Online`.

### 2. Khi Nhận Nhiệm Vụ Mới Từ Đại Ca:
1. **Cấp Mã & Khởi Tạo Hồ Sơ:**
   - Tự động sinh mã kế tiếp (ví dụ: `#T-02`, `#T-03`).
   - Đặt tên thư mục hồ sơ: `docs/tasks/T-xx-[tên-ngắn]/`.
   - Tạo sẵn file mẫu: `docs/tasks/T-xx-[tên-ngắn]/01-spec.md` với ghi chú bài toán của đại ca.
2. **Cập Nhật Bảng Radar:**
   - Thêm 1 dòng mới vào `## 📋 2. BẢNG THEO DÕI NHIỆM VỤ CUỐN CHIẾU`.
   - Ghi nhật ký vào `## 📨 3. NHẬT KÝ ĐIỀU PHỐI`.
3. **Bắn Tin Điều Phối (Auto Dispatch):**
   - Đọc danh bạ lấy Conversation ID của phòng **`[BA]`**:
   - **Nếu BA Online:**
     Gọi ngay:
     ```json
     send_message(
       Recipient: "<BA_CONVERSATION_ID>",
       Message: "[TASK #T-xx] Bắt đầu tính năng mới: [Tên tính năng]. Yêu cầu: [Mô tả]. Hồ sơ tại docs/tasks/T-xx-[tên-ngắn]/01-spec.md. Mời BA chốt spec!"
     )
     ```
     Thông báo cho đại ca:
     > 🚀 *"Đã khởi tạo **`#T-xx`** và bắn tin sang phòng **[BA]** (ID: `<BA_ID>`). Hồ sơ lưu tại `docs/tasks/T-xx-[tên-ngắn]/`!"*
   - **Nếu BA Offline:**
     Nhắc đại ca mở tab `[BA]` gõ `online` để kết nối danh bạ.

### 3. Xem Trạng Thái Radar (`status` / `tiến độ` / `.`):
1. Đọc `.agent/CHANNEL.md` mới nhất.
2. Xuất **sơ đồ Mermaid đa luồng cuốn chiếu**:
   - Liệt kê các task đang chạy song song.
   - Thể hiện màu sắc: 🟢 PASS/DONE, 🟡 In-Progress, 🔴 Bug Found.
3. In bảng theo dõi tình trạng từng phòng (ai bận, ai rảnh).
