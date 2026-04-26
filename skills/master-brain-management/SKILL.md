---
name: master-brain-management
description: Quy trình Sentinel Refinery-v6.5 - Ép Agent trích xuất tinh hoa nguyên tử và bảo trì mạng lưới Zettelkasten thực chiến.
---

# Master Brain Management (Sentinel Refinery-v6.5)

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
- **Nguồn chân lý**: `.agent/VERSION` (Chứa phiên bản hiện tại).
- **Lò luyện Refinery-v6.5 (Automator)**: `.agent/skills/master-brain-management/scripts/ingest-memory.sh`
- **Dashboard Sức khỏe**: `LLM_Wiki/MOCs/Wiki Health MOC.md`.
- **Mẫu ghi chú**: `LLM_Wiki/Tools/Note Templates.md`.
- **Cổng vào**: `LLM_Wiki/index.md`.

## 🔄 Quy trình Ingest Refinery-v6.5 (The Automator Loop)
1. **Search & Scan**: Quét `/raw` tìm quặng.
2. **Deconstruct & Synthesis**: Sử dụng mẫu tại `LLM_Wiki/Tools/Note Templates.md`.
3. **Graph Linking**: Kết nối mạng lưới.
4. **Auto-Versioning**: Chạy `ingest-memory.sh` để đồng bộ phiên bản toàn hệ thống.
5. **Healer Diagnosis**: Kiểm tra Dashboard Sức khỏe và thực hiện Auto-Healing.

## ⚠️ Anti-Slop Safeguards (Cấm kỵ)
- **Language Integrity (MANDATORY)**: Đối với tài liệu nguồn (quặng thô) bằng tiếng Anh, PHẢI giữ nguyên nội dung Atomic Note bằng tiếng Anh. Tuyệt đối không dịch sang tiếng Việt để tránh làm sai lệch ngữ nghĩa kỹ thuật và thuật ngữ chuyên môn.
- **Đồng bộ tuyệt đối (MANDATORY)**: Mọi thay đổi về logic (Skill, Script, Cấu trúc) PHẢI đi kèm với việc cập nhật đồng bộ các file điều phối (`GEMINI.md`, `index.md`, `LLM Wiki.md`) và các MOC liên quan. Cấm tuyệt đối việc để tồn tại phiên bản cũ hoặc "link ma".
- KHÔNG để tri thức mồ côi.
- KHÔNG để mâu thuẫn tồn tại (Note A nói X, Note B nói Y -> Phải hợp nhất hoặc sửa đổi).
- Mọi note phải có "giá trị định tuyến" (Tóm tắt 1 dòng chất lượng).

---
*Mọi hành vi vi phạm quy chuẩn Atomic sẽ bị Lão Ní "thanh trừng" ngay lập tức.*
