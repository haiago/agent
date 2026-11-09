# 📡 TỔNG ĐÀI ĐIỀU PHỐI DÂY CHUYỀN (ROLLING DISPATCH RADAR)

> **Cơ chế:** Trung tâm điều phối đa nhiệm cuốn chiếu (Pipelined Dispatch). Mỗi nhiệm vụ mang một mã `Task ID` độc lập và được đóng gói trọn vẹn trong thư mục `docs/tasks/T-xx/`.

---

## 📞 1. DANH BẠ PHÒNG BAN & TRẠNG THÁI (ROOM REGISTRY)
| Phòng Ban | Vai Trò | Conversation ID | Trạng Thái | Việc Đang Làm Dở (In-Progress) |
| :--- | :--- | :--- | :--- | :--- |
| **[CHANNEL]** | Tháp Chỉ Huy Trung Tâm | `chưa_kết_nối` | 🔴 Offline | Giám sát & Điều phối chung |
| **[BA]** | Phân Tích Nghiệp Vụ | `chưa_kết_nối` | 🔴 Offline | Đang rảnh |
| **[UI]** | Thiết Kế & Demo HTML | `chưa_kết_nối` | 🔴 Offline | Đang rảnh |
| **[DEV]** | Lập Trình Frontend/Backend | `chưa_kết_nối` | 🔴 Offline | Đang rảnh |
| **[QA]** | Kiểm Thử & Review | `chưa_kết_nối` | 🔴 Offline | Đang rảnh |
| **[GIT]** | Release & Commit | `chưa_kết_nối` | 🔴 Offline | Đang rảnh |

---

## 📋 2. BẢNG THEO DÕI NHIỆM VỤ CUỐN CHIẾU (TASK PIPELINE)
| Task ID | Tên Nhiệm Vụ | Phân Hệ | Chặng Hiện Tại | Phòng Đang Xử Lý | Trạng Thái | Thư Mục Hồ Sơ |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`#T-00`** | Mẫu nhiệm vụ khởi đầu | System | `INIT` | `[CHANNEL]` | ⚪ Standby | `docs/tasks/T-00-sample/` |

> *Trạng thái quy chuẩn: `🟡 In-Progress` | `🔴 Bug Found` | `🟡 Retesting` | `🟢 PASS` | `✅ DONE`*

---

## 📨 3. NHẬT KÝ ĐIỀU PHỐI THỜI GIAN THỰC (LIVE DISPATCH TICKER)
- `[System]`: Kênh điều phối sẵn sàng tiếp nhận nhiệm vụ.
