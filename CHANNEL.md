# 📡 KÊNH ĐIỀU PHỐI LIÊN PHÒNG BAN (WORKDONE DISPATCH CHANNEL)

> **Cơ chế:** Mọi phòng ban ([BA], [UI], [DEV], [QA], [GIT]) đều phải tuân thủ việc ĐỌC và TỰ ĐỘNG CẬP NHẬT file này.  
> Đại ca chỉ cần sang phòng tiếp theo và gõ: **`tiếp tục`** (hoặc `@.agent/CHANNEL.md tiếp tục`)!

---

## 🚦 TRẠNG THÁI HIỆN TẠI (ACTIVE DISPATCH)
- **Tính năng đang xử lý:** Viết lại Control Treeview thuần Vue & Tối ưu Lazy-load cây thư mục theo 2 pha API (`getSectionsWithinWorkspaceTreeData` + `getTeamDriveTreeData`)
- **Phân hệ mục tiêu:** `Drive` (`src/modules/drives`)
- **Nhánh Git tác chiến:** `dev`
- **Phòng ban đang giữ quyền (Active Role):** `[QA]`
- **Cập nhật lần cuối:** 2026-11-08

---

## 📋 TIẾN TRÌNH DÂY CHUYỀN (PIPELINE CHECKLIST)
- [x] **1. [BA] Đặc tả:** Đã xuất spec tại `docs/prd/drive-treeview-lazy-load-spec.md`
- [ ] **2. [UI] Demo HTML:** (Bỏ qua - Giữ nguyên 100% UI/CSS hiện tại của Treeview Drive)
- [x] **3. [DEV] Triển khai Code:** Đã viết xong logic và kiểm tra syntax/lint passed 0 error
  - `docs/dev/drive-treeview-lazy-load-plan.md`
  - `src/modules/drives/services/drivefile.ts`
  - `src/modules/drives/Components/driveTreeNode.vue`
  - `src/modules/drives/Components/driveTreeView.vue`
  - `src/assets/scss/custom/drive/_tree-custom.scss`
  - `src/modules/drives/Components/leftbar.vue`
- [ ] **4. [QA] Kiểm thử:** Chờ QA chạy type-check & lint trên các file sửa và xác nhận PASS ✅
- [ ] **5. [GIT] Release:** Chờ Git soát diff, commit đúng format và push an toàn

---

## 📨 THÔNG ĐIỆP BÀN GIAO GẦN NHẤT (LATEST HANDOFF)
> **Phòng vừa hoàn thành:** `[DEV]`  
> **Chuyển giao cho phòng:** `[QA]`  
> **Nội dung bàn giao:**  
> - **Kế hoạch Dev:** `docs/dev/drive-treeview-lazy-load-plan.md`  
> - **Chi tiết triển khai:**  
>   1. **API Service (`src/modules/drives/services/drivefile.ts`):** Thêm 2 hàm `getSectionsWithinWorkspaceTreeData(WorkspaceId)` và `getTeamDriveTreeData(TeamId)`.  
>   2. **Custom Reactive Treeview (`driveTreeNode.vue`, `driveTreeView.vue`):**  
>      - Thay thế hoàn toàn `<ejs-treeview>` và gỡ bỏ `TreeViewPlugin` khỏi `leftbar.vue`.  
>      - Hiển thị 100% chuẩn giao diện: Lucide icon (`hard-drive`, `trash`, `folder-minus`, `folder`), tên node ellipsis, highlight active xanh lá.  
>      - Phân tách rõ ràng hành vi: click mũi tên chevron chỉ toggle expand (kích hoạt lazy-load nếu cần); click tên/icon thư mục kích hoạt chọn node, mở rộng và cập nhật breadcrumb + tải file.  
>      - Tự động ẩn mũi tên cho các node lá (`TRASH`, `WS_UPLOAD_FROM`, `TASK`, hoặc `SECTION` đã nạp nhưng không có task con).  
>      - Loading spinner gọn nhẹ tại node Section khi đang nạp dữ liệu.  
>   3. **Pha 1 (Khởi tạo nhanh):** Gọi song song `getSectionsWithinWorkspaceTreeData` + `getWorkspaceFileTreeData`, dựng cấu trúc cây đến cấp Section, gắn `TeamId` và `ProjectId` xuyên suốt.  
>   4. **Pha 2 (Nạp động Task theo Team):** Khi click/expand Section, gọi `getTeamDriveTreeData(TeamId)`, map danh sách Task (`LevelId: 4`) vào tất cả Section thuộc Team đó, lưu cache `loadedTeamIds` và xử lý chống duplicate call bằng Promise in-flight sharing.  
>   5. **Tương thích & Đồng bộ:**  
>      - Điều hướng ngược từ Breadcrumb / vùng file (`fileEvents.driveOpenNode`): tự động nạp dữ liệu Team nếu node đích là Section/Task chưa hydrate trước khi focus.  
>      - Xóa node (`fileEvents.driveRemoveTreeNode`): xóa reactive trực tiếp trên mảng dữ liệu cây mà không làm đóng các nhánh khác, tự động focus về node cha.  
>      - URL param `?project=xxx`: tự mở rộng và focus đúng Project khi truy cập trực tiếp.  
>      - Biến động file: làm mới cache dung lượng và team cache khi xóa/khôi phục file.  
>   6. **Hotfix Bug Watcher Lifecycle:** Đã chuyển khai báo các cache `teamStorageCache`, `loadedTeamIds` và các state `selectedNodes`, `expandedNodes` lên đầu `setup()`, dời `watch` xuống cuối lifecycle để tránh temporal dead zone khi `watch` chạy ở mode `{ immediate: true }`.  
>   7. **Kết quả Lint:** Đã chạy ESLint trên toàn bộ các file thay đổi, 0 lỗi (`0 errors`).
