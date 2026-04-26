---
name: master-brain-management
description: Quy trình Sentinel v6.2 - Ép Agent trích xuất tinh hoa nguyên tử và bảo trì mạng lưới Zettelkasten thực chiến.
---

# Master Brain Management (Sentinel v6.2)

Mục tiêu tối thượng: **Triệt tiêu Slop (rác tóm tắt)**. Biến tri thức thành mạng lưới các viên gạch "copy-paste xài ngay".

## 🧱 Quy chuẩn Atomic Note (BẮT BUỘC)
1. **Naming**: Tên file = Khái niệm/Công cụ. KHÔNG dùng tiền tố `Summary`, `Note`, `About`. (Ví dụ: `Deterministic Hooks.md`).
2. **Structure**: Phải có Frontmatter (tags, aliases) để Obsidian/Agent tìm kiếm nhanh.
3. **Connectivity**: 
   - Note mới PHẢI liên kết tới ít nhất 1 MOC.
   - Note mới NÊN liên kết tới các Concepts liên quan đã có.
4. **Length**: > 100 dòng = THẤT BẠI. Phải chẻ nhỏ thành các note con.

## 🛠️ Phân khu Tri thức (LLM_Wiki/)
- `/Concepts`: "How & Why" (Nguyên lý kỹ thuật).
- `/Tools`: "What & Code" (Scripts, CLI, Snippets).
- `/Projects`: "Where & Context" (Mối liên hệ Concepts/Tools trong dự án thực tế).
- `/MOCs`: "The Map" (Điểm truy cập trung tâm).

## 🛠️ Hạ tầng Luyện não (Infrastructure)
Mọi Agent ĐỀU PHẢI sử dụng công cụ sau để bảo trì mạng lưới:
- **Lò luyện v6.2 (Sentinel)**: `.agent/skills/master-brain-management/scripts/ingest-memory.sh`
- **Mẫu ghi chú**: `LLM_Wiki/Tools/Note Templates.md` (BẮT BUỘC phải đọc trước khi tạo note).
- **Cổng vào**: `LLM_Wiki/index.md` (Router Index).

## 🔄 Quy trình Ingest v6.2 (The Sentinel Loop)
1. **Search & Scan**: Quét `/raw` tìm quặng.
2. **Deconstruct & Synthesis**: Sử dụng mẫu tại `LLM_Wiki/Tools/Note Templates.md` để đúc gạch tinh hoa.
3. **Graph Linking**: Kết nối note mới với mạng lưới.
4. **Sentinel Audit**: Chạy `ingest-memory.sh` để kiểm tra MOC và Link gãy.
5. **MOC Registration**: Nếu Sentinel báo "MOC MISSING", phải lập tức đăng ký note vào đúng Topic MOC.

## ⚠️ Anti-Slop Safeguards (Cấm kỵ)
- **Đồng bộ tuyệt đối (MANDATORY)**: Mọi thay đổi về logic (Skill, Script, Cấu trúc) PHẢI đi kèm với việc cập nhật đồng bộ các file điều phối (`GEMINI.md`, `index.md`, `LLM Wiki.md`) và các MOC liên quan. Cấm tuyệt đối việc để tồn tại phiên bản cũ hoặc "link ma".
- KHÔNG để tri thức mồ côi.
- KHÔNG để mâu thuẫn tồn tại (Note A nói X, Note B nói Y -> Phải hợp nhất hoặc sửa đổi).
- Mọi note phải có "giá trị định tuyến" (Tóm tắt 1 dòng chất lượng).

---
*Mọi hành vi vi phạm quy chuẩn Atomic sẽ bị Lão Ní "thanh trừng" ngay lập tức.*
