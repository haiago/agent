---
name: master-brain-management
description: Quy trình Zettelkasten v6.0 - Ép Agent trích xuất tinh hoa nguyên tử và xây dựng mạng lưới tri thức thực chiến.
---

# Master Brain Management (Zettelkasten v6.0)

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

## 🔄 Quy trình Ingest v6.1 (The Karpathy Loop)
1. **Search & Scan**: Quét `/raw` để tìm quặng mới.
2. **Deconstruct**: Chẻ nhỏ tri thức thành các Atomic Notes.
3. **Filing Answers (Synthesis)**: Nếu có một cuộc hội thảo sâu sắc, phải đúc kết thành một note mới thay vì để nó trôi mất.
4. **Graph Linking**: Kết nối note mới với mạng lưới hiện có.
5. **Router Update**: Đảm bảo note mới có 1 dòng tóm tắt (hoặc `summary:` field) để lò luyện v6.1 cập nhật vào `index.md`.
6. **Auto-Linting**: Định kỳ quét Wiki để tìm mâu thuẫn giữa các note và xóa bỏ kiến thức lỗi thời.

## ⚠️ Anti-Slop Safeguards (Cấm kỵ)
- KHÔNG để tri thức mồ côi.
- KHÔNG để mâu thuẫn tồn tại (Note A nói X, Note B nói Y -> Phải hợp nhất hoặc sửa đổi).
- Mọi note phải có "giá trị định tuyến" (Tóm tắt 1 dòng chất lượng).

---
*Mọi hành vi vi phạm quy chuẩn Atomic sẽ bị Lão Ní "thanh trừng" ngay lập tức.*
