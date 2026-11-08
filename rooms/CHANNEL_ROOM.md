# 📡 TỔNG ĐÀI ĐIỀU PHỐI (WorkDone Dispatch Channel & Live Dashboard)

> **Mục tiêu:** Bảng điều khiển trực quan (Live Dashboard Console) cho dự án `WorkDone`. Thay vì đọc file `.agent/CHANNEL.md` khô khan, đại ca click vào room này để xem **sơ đồ tiến độ màu sắc**, **nhật ký bàn giao giữa các phòng** và **biết ngay việc đang tắc ở đâu**!

---

## 🎯 Phản Xạ Mặc Định Của Phòng Này
Mỗi khi đại ca gõ bất kỳ câu nào vào room này (như `status`, `tiến độ`, `channel`, `log`, hoặc chỉ một dấu chấm `.`):

1. **BẮT BUỘC ĐỌC NGAY:** File `.agent/CHANNEL.md` mới nhất.
2. **XUẤT SƠ ĐỒ MERMAID TIẾN ĐỘ ĐỘNG:**
   Tô màu trực quan dựa theo trạng thái trong file:
   - Phòng đã xong: Màu xanh lá `fill:#dcfce7,stroke:#22c55e` ✅
   - Phòng đang làm: Màu vàng nổi bật `fill:#fef9c3,stroke:#eab308,stroke-width:3px` 🟡
   - Phòng đang chờ: Màu xám viền nét đứt `fill:#f1f5f9,stroke:#94a3b8` ⚪

3. **IN BẢNG DASHBOARD TRỰC QUAN:**
   - **Tính năng đang chạy:** [Tên tính năng]
   - **Phân hệ mục tiêu:** `CRM` | `Task` | `Xinbox` | `Form` | `RightSidebar` | `Khác`
   - **Phòng đang giữ bóng:** `[TÊN_PHÒNG]`
   - **Các file đã được tạo / sửa:** (Liệt kê kèm link clickable `file://...`)
   - **Thông điệp bàn giao mới nhất:** Trích xuất nguyên văn lời nhắn từ phòng trước gửi phòng sau.

4. **CHỈ HƯỚNG RÕ RÀNG CHO ĐẠI CA:**
   Xuất 1 dòng chỉ dẫn:
   > 👉 *"Đại ca hãy bấm vào tab **[TÊN_PHÒNG]** ở thanh bên trái và gõ: `tiếp tục` để dây chuyền chạy tiếp!"*

---

## 🛠️ Các Lệnh Hỗ Trợ Nhanh:
* `status` / `tiến độ`: Xem sơ đồ và trạng thái hiện tại.
* `reset` / `clear`: Xóa trắng channel, chuẩn bị cho tính năng mới.
* `history` / `nhật ký`: Tóm tắt lại toàn bộ lịch sử từ lúc BA ra đề đến lúc Git release.
