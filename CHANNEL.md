# 📡 TỔNG ĐÀI ĐIỀU PHỐI DÂY CHUYỀN (ROLLING DISPATCH RADAR)

> **Cơ chế:** Trung tâm điều phối đa nhiệm cuốn chiếu (Pipelined Dispatch). Mỗi nhiệm vụ mang một mã `Task ID` độc lập và được đóng gói trọn vẹn trong thư mục `docs/tasks/T-xx/`.

---

## 📞 1. DANH BẠ PHÒNG BAN & TRẠNG THÁI (ROOM REGISTRY)
| Phòng Ban | Vai Trò | Conversation ID | Trạng Thái | Việc Đang Làm Dở (In-Progress) |
| :--- | :--- | :--- | :--- | :--- |
| **[CHANNEL]** | Tháp Chỉ Huy Trung Tâm | `64e11ef6-739e-46b1-8020-25acabc0221c` | 🟢 Online (TEST) | Giám sát & Điều phối chung |
| **[BA]** | Phân Tích Nghiệp Vụ | `0b8df28c-a723-4878-91fc-2310a7f180de` | ⚪ Idle (TEST) | Sẵn sàng nhận Task mới |
| **[UI]** | Thiết Kế & Demo HTML | `87e3472b-8ec3-4383-a95e-db52a3f0c93d` | 🟢 Online (TEST) | Sẵn sàng nhận Task mới |
| **[DEV]** | Lập Trình Frontend | `aed7af8f-be34-4ac9-b988-801efcd45b36` | ⚪ Idle (TEST) | Đã xong #T-02-UX-FIX, bàn giao QA |
| **[QA]** | Kiểm Thử & Review | `e5db0129-01fe-444f-aa24-3395ba8d8b38` | ⚪ Idle - Đang rảnh | Sẵn sàng nhận việc mới |
| **[GIT]** | Release & Commit | `bf4e87ff-bda5-4318-890f-3bf759e4699e` | 🟢 Busy - Release #T-02-INACTIVITY-TIMEOUT | Soát diff & Release #T-02-V2 & INACTIVITY-TIMEOUT |

---

## 📋 2. BẢNG THEO DÕI NHIỆM VỤ CUỐN CHIẾU (TASK PIPELINE)
| Task ID | Tên Nhiệm Vụ | Phân Hệ | Chặng Hiện Tại | Phòng Đang Xử Lý | Trạng Thái | Thư Mục Hồ Sơ |
| :--- | :--- | :--- | :--- | :--- | :--- | :--- |
| **`#T-01`** | Viết lại Control Treeview & Lazy-load 2 pha | Drive | `DEV ➔ QA` | `[QA]` | 🟡 Testing | `docs/tasks/T-01-drive-lazyload/` |
| **`#T-02-V2`** | Native Directory Stream & Inactivity Timeout | Drive | `QA ➔ GIT` | `[GIT]` | 🟢 PASS | `docs/tasks/T-02-drive-zip-download/` |
| **`#T-02`** | Nâng cấp Smart Chunking 500MB ZIP Team | Drive | `QA ➔ GIT` | `[GIT]` | 🟢 PASS | `docs/tasks/T-02-drive-zip-download/` |

> *Trạng thái quy chuẩn: `🟡 In-Progress` | `🔴 Bug Found` | `🟡 Retesting` | `🟢 PASS` | `✅ DONE`*

---

## 📨 3. NHẬT KÝ ĐIỀU PHỐI THỜI GIAN THỰC (LIVE DISPATCH TICKER)
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #T-02-INACTIVITY-TIMEOUT (Inactivity Timeout 25s: lắng nghe byte mới từ progress, hỗ trợ file lớn 500MB+, chống treo socket khi rớt mạng). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã hoàn thành #T-02-INACTIVITY-TIMEOUT (Chuyển Timeout sang Inactivity Timeout 25s: reset timer mỗi khi có byte dữ liệu mới, file nặng tải lâu vẫn mượt mà, chỉ timeout khi mất mạng liên tục 25s). Mời QA kiểm thử!
- `[Founder] ➔ [DEV]`: Yêu cầu chuyển sang Inactivity Timeout dựa trên progress của JSZipUtils (#T-02-INACTIVITY-TIMEOUT).
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #T-02-TIMEOUT-FIX (Bọc Timeout 25s chống treo socket vĩnh viễn; Triệt tiêu 100% ảo - chỉ lên 100% khi count === totalFiles). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã hoàn thành #T-02-TIMEOUT-FIX (Tích hợp Timeout 25s cho `fetchBinaryData` chống treo socketCDN; Triệt tiêu "100% ảo" chỉ lên 100% khi count === totalFiles). Mời QA kiểm thử!
- `[Founder] ➔ [DEV]`: Báo cáo hiện tượng đứng ở 100% ảo và socket treo ở 3 file cuối trong bài test 3.548 file (#T-02-TIMEOUT-FIX).
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #T-02-HOTFIX (User Gesture được bảo toàn trên dòng đầu tiên, không sinh popup rác khi Hủy, chỉ push process khi đã chọn thư mục). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã hoàn thành #T-02-HOTFIX (Đưa `requestDirectoryHandle()` lên dòng đầu tiên của `onDownloadFileByTeam`, bảo toàn User Gesture, thoát sạch khi Hủy, chỉ push process khi đã chọn thư mục). Mời QA kiểm thử!
- `[Founder] ➔ [DEV]`: Báo lỗi kiến trúc User Gesture hết hạn khi tải theo Team (#T-02-HOTFIX).
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #CRITICAL-UX-BUGFIX (3 lỗi giao diện: Giữ 0% trước chọn thư mục; Bọc try/catch thư mục và nhảy % mượt; Chống đè dòng & tự tắt khi Hủy). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã khắc phục triệt để 3 lỗi UX thực tế từ Founder (Giữ 0% trước khi chọn thư mục; Bọc try/catch thư mục và chuyển text "Đang lưu..." nhảy 1-100%; Xử lý triệt để đè dòng và auto-dismiss khi Cancel). Mời QA kiểm thử!
- `[Founder] ➔ [DEV]`: Bắt 3 lỗi nghiêm trọng thực tế trên UI kèm ảnh chứng cứ (#CRITICAL-UX-BUGFIX).
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #T-02-V2 & UX-FIX (Khắc phục lỗi TS, Nút Cancel cho Type==1, Tiến độ realtime không đơ 0%). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã hoàn tất sửa lỗi TypeScript và 2 lỗi UX (Cancel cho Type==1, Cập nhật tiến độ realtime không đơ 0%) trong src/components/UploadProcess.vue. Mời QA vào kiểm thử!
- `[Founder] ➔ [DEV]`: Yêu cầu xử lý gấp 2 lỗi UX (Bổ sung nút Cancel cho Type==1 & Cập nhật tiến độ mượt mà realtime không đơ 0%) (#T-02-UX-FIX).
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #T-02-V2 (Native Directory Stream & 4 Khiên Bảo Vệ OS). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã hoàn thành code #T-02-V2 (Native Directory Stream `showDirectoryPicker`, 4 Khiên Bảo Vệ OS & Fallback Smart Zip). Kế hoạch tại docs/tasks/T-02-drive-zip-download/03-plan.md. Mời QA kiểm thử!
- `[Handoff]` **[BA] ➔ [DEV]**: Bàn giao đặc tả `#T-02-V2` (Vũ Khí Tối Thượng: Native Directory Stream `showDirectoryPicker`, 4 Chiếc Khiên Bảo Vệ OS & Fallback Smart Zip 500MB) tại `docs/tasks/T-02-drive-zip-download/01-spec.md` sang phòng DEV triển khai.
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #T-02-UPGRADE (Smart Chunking 500MB & Safe Fallback). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã hoàn tất nâng cấp thuật toán Smart Chunking 500MB (#T-02-UPGRADE) trong src/components/UploadProcess.vue. Kế hoạch tại docs/tasks/T-02-drive-zip-download/03-plan.md. Mời QA kiểm thử!
- `[Founder] ➔ [DEV]`: Giao việc nâng cấp thuật toán Smart Chunking theo ngưỡng 500MB cho tính năng tải ZIP cấp Team (#T-02-UPGRADE).
- `[Handoff]` **[QA] ➔ [GIT]**: Đã kiểm thử PASS ✅ toàn diện #T-02 (Tối ưu Tải Tệp Nén ZIP Drive). Báo cáo tại docs/tasks/T-02-drive-zip-download/04-audit.md. Mời phòng GIT soát diff và release.
- `[Handoff]` **[DEV] ➔ [QA]**: Đã hoàn thành code #T-02 (Tối ưu Tải Tệp Nén ZIP Drive). Kế hoạch và danh sách file tại docs/tasks/T-02-drive-zip-download/03-plan.md. Bàn giao sang phòng QA kiểm thử.
- `[Handoff]` **[BA] ➔ [DEV]**: Bàn giao đặc tả `#T-02` chuẩn 5 phần tại `docs/tasks/T-02-drive-zip-download/01-spec.md` sang phòng DEV lập `03-plan.md`.
- `[Handoff]` **[DEV] ➔ [QA]**: Bàn giao `#T-01` (Treeview Lazy-load) sang phòng QA kiểm thử type-check và lint.
