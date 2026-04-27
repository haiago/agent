---
name: master-brain-management
description: Quy trình Sentinel Refinery-v6.7 - Ép Agent trích xuất tinh hoa nguyên tử và bảo trì mạng lưới Zettelkasten thực chiến. Dùng khi harvest tri thức từ project, tạo atomic note, kiểm tra sức khỏe wiki, hoặc chạy ingest pipeline.
---

# Master Brain Management (Sentinel Refinery-v6.7)

Mục tiêu tối thượng: **Triệt tiêu Slop**. Biến tri thức thành mạng lưới các viên gạch "copy-paste xài ngay".

## 🧱 Quy chuẩn Atomic Note (BẮT BUỘC)

1. **One idea, one file**: Mỗi note chỉ giải quyết một khái niệm, công cụ, hoặc bối cảnh rõ ràng.
2. **Summary-first**: Mọi durable note PHẢI có frontmatter `summary:` (1 dòng, súc tích, đủ để router index định tuyến).
3. **Graph-aware**: Note mới PHẢI có ít nhất một liên kết vào MOC và một liên kết ra note liên quan nếu phù hợp.
4. **Length**: > 100 dòng = vi phạm Atomic. Phải chẻ nhỏ (trừ `status: reference` hoặc `status: archived`).

**Ví dụ summary tốt vs slop:**

```yaml
# ✅ Tốt
summary: "Giải thích cơ chế attention trong Transformer — Q/K/V matrix và scaled dot-product."

# ❌ Slop
summary: "Ghi chú về AI"
summary: "Tổng hợp nội dung bài đọc"
```

## 🦅 Thiết luật Harvest (Project Management)

Mọi tri thức từ dự án thực tế PHẢI tuân thủ:

1. **Project MOC**: Tạo `[Project Name] MOC.md` trong `/MOCs` với tag `#projects` và `#moc`.
2. **Internal Linking**: Project MOC phải link tới `/Projects/[Project Name].md`.
3. **Cross-Linking**: Project MOC phải link tới Concepts/Tools dùng chung đã có.

## 🛠️ Phân khu Tri thức (LLM_Wiki/)

| Thư mục     | Mục đích                  | Câu hỏi trả lời |
| ----------- | ------------------------- | --------------- |
| `/Concepts` | Nguyên lý kỹ thuật        | How & Why       |
| `/Tools`    | Scripts, CLI, Snippets    | What & Code     |
| `/Projects` | Bối cảnh dự án thực tế    | Where & Context |
| `/MOCs`     | Bản đồ truy cập trung tâm | The Map         |

## 🛠️ Hạ tầng & Cấu hình

### Các file cốt lõi

- **Version truth**: `.agent/VERSION`
- **Ingest script**: `.agent/skills/master-brain-management/scripts/ingest-memory.sh`
- **Health dashboard**: `LLM_Wiki/MOCs/Wiki Health MOC.md`
- **Note templates**: `LLM_Wiki/Tools/Note Templates.md`
- **Router index**: `LLM_Wiki/index.md`

### Env vars (override mặc định)

Script tự resolve path từ vị trí của nó. Chỉ set các biến này khi brain nằm ngoài repo:

| Biến                              | Mặc định          | Dùng khi                                   |
| --------------------------------- | ----------------- | ------------------------------------------ |
| `MASTER_BRAIN_ROOT`               | 4 cấp trên script | Brain là submodule riêng                   |
| `MASTER_BRAIN_WIKI_DIR`           | `$ROOT/LLM_Wiki`  | Wiki ở path tùy chỉnh                      |
| `MASTER_BRAIN_RAW_DIR`            | `$ROOT/raw`       | Raw ở path khác                            |
| `MASTER_BRAIN_STRICT_SUMMARY`     | `1`               | Set `0` để bỏ qua warning summary          |
| `MASTER_BRAIN_IGNORE_DRAFT_LINKS` | `1`               | Set `0` để check cả link Draft/Planned/TBD |
| `MASTER_BRAIN_ATOMIC_LINE_LIMIT`  | `100`             | Tăng giới hạn cho note đặc biệt            |

### Prerequisites

Script sẽ exit với lỗi rõ ràng nếu thiếu:

- `.agent/VERSION` tồn tại
- `LLM_Wiki/` và `LLM_Wiki/MOCs/` tồn tại

## 🔄 Quy trình Ingest Refinery-v6.7

```
1. Search & Scan     → Quét /raw tìm quặng thô
2. Deconstruct       → Dùng mẫu tại LLM_Wiki/Tools/Note Templates.md
3. Graph Linking     → Kết nối vào MOC + note liên quan
4. Run Script        → bash ingest-memory.sh
5. Healer Review     → Đọc Wiki Health MOC, fix các lỗi được flag
```

**Done criteria (bước 5):** Script hoàn thành khi không còn:

- Orphan note (MOC Missing)
- Broken link (trừ Draft/Planned được ignore)
- Note vi phạm Atomic (> line limit, không phải reference/archived)

## ⚠️ Anti-Slop Safeguards

- **Language Integrity**: Tài liệu nguồn tiếng Anh → giữ nguyên tiếng Anh trong Atomic Note.
- **Sync bắt buộc**: Mọi thay đổi logic phải đồng bộ `GEMINI.md`, `LLM Wiki.md`, các MOC liên quan. Script tự sync version string trong danh sách file cố định — nếu thêm file mới cần sync, cập nhật `files_to_sync` trong script.
- **Không orphan note**: Mọi note phải xuất hiện trong ít nhất 1 MOC.
- **Không mâu thuẫn**: Note A nói X, Note B nói Y → hợp nhất hoặc sửa đổi.

**Xử lý vi phạm:**
| Vi phạm | Hành động |
|---|---|
| Missing summary | Flag trong Wiki Health MOC, thêm `summary:` trước lần ingest tiếp |
| Atomic quá dài | Chẻ thành note con, link qua nhau |
| Broken link | Tạo note stub hoặc xóa link |
| Orphan note | Link vào MOC phù hợp |
| Missing `#moc` tag trên MOC | Thêm vào frontmatter `tags:` |
