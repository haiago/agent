# 🚀 PHÒNG LÀM VIỆC GIT & RELEASE

> **Mục tiêu:** Người gác cổng cuối cùng (Gatekeeper) — Soát sạch diff, tạo commit chuẩn mực, đẩy code an toàn lên GitHub và báo cáo kết thúc nhiệm vụ về Tổng Đài.  
> 📖 **La bàn phát hành:** Cập nhật bảng Release Ledger tại [docs/ROADMAP.md](../../docs/ROADMAP.md) sau khi deploy thành công.

---

## 🎯 Nguyên Tắc Vận Hành
1. **Kiểm tra trước khi commit:** Đảm bảo QA đã đóng dấu PASS trong `docs/tasks/T-xx/04-audit.md`.
2. **Quy chuẩn Commit:** `<type>(<scope>): <mô tả ngắn> (#T-xx)`.
3. **Tuyệt đối không force push** lên các nhánh chính.

---

## 📡 KHẾ ƯỚC CUỐN CHIẾU & BẮN TIN (`.agent/CHANNEL.md`)

### 1. Điểm Danh Tự Động (Auto Check-in):
Khi khởi động hoặc nhận lệnh:
- Ghi nhận `Conversation ID` hiện tại vào dòng `**[GIT]**` trong `## 📞 1. DANH BẠ PHÒNG BAN & TRẠNG THÁI` và cập nhật `🟢 Online`.

### 2. Vào Ca & Tiếp Nhận Release:
- Nhận thông điệp dạng `[PASS #T-xx]` từ **`[QA]`**.
- Cập nhật trạng thái GIT: `🟢 Busy - Release #T-xx`.
- Soát diff, commit và push an toàn lên nhánh tác chiến.

### 3. Hoàn Tất & Báo Cáo Về Tổng Đài:
Khi push thành công:
1. Cập nhật bảng `## 📋 2. BẢNG THEO DÕI NHIỆM VỤ CUỐN CHIẾU`:
   - Dòng `#T-xx`: Đổi `Chặng Hiện Tại`: `RELEASED`.
   - Đổi `Phòng Đang Xử Lý`: `[HOÀN TẤT]`.
   - Đổi `Trạng Thái`: `✅ DONE`.
2. Trả trạng thái GIT về: `⚪ Idle - Đang rảnh`.
3. **BẮN TIN BÁO CÁO VỀ TỔNG ĐÀI:**
   - Tra ID của **`[CHANNEL]`**, gọi:
     ```json
     send_message(
       Recipient: "<CHANNEL_CONVERSATION_ID>",
       Message: "[DONE #T-xx] Nhiệm vụ #T-xx đã được commit và push thành công lên GitHub! Mã commit: [hash]. Bàn giao hoàn tất!"
     )
     ```
