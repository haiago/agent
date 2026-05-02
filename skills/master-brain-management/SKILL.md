---
name: master-brain-management
description: Quy trình Sentinel v7.3 - Ép Agent trích xuất tinh hoa nguyên tử và bảo trì mạng lưới Zettelkasten thực chiến. Dùng khi harvest tri thức từ project, tạo atomic note, kiểm tra sức khỏe wiki, hoặc chạy ingest pipeline.
---

# Master Brain Management (Sentinel v7.3)

> changelog:
>
> - v7.1: Initial Sentinel standard. Atomic note rules, Harvest law, Ingest pipeline.
> - v7.2: Add step 0 Verify (ls before read_file); add Mandatory Sync Contract; clarify done criteria.
> - v7.3: Add Auto-Routing rule (never write to LLM_Wiki/ root); add Footer Required to Atomic Note rules.

Mục tiêu tối thượng: **Triệt tiêu Slop**. Biến tri thức thành mạng lưới các viên gạch "copy-paste xài ngay".

---

## 🧱 Quy chuẩn Atomic Note (BẮT BUỘC)

1. **One idea, one file**: Mỗi note chỉ giải quyết một khái niệm, công cụ, hoặc bối cảnh rõ ràng.
2. **Summary-first**: Mọi durable note PHẢI có frontmatter `summary:` (1 dòng, súc tích, đủ để router index định tuyến).
3. **Graph-aware**: Note mới PHẢI có ít nhất một liên kết vào MOC và một liên kết ra note liên quan nếu phù hợp.
4. **Length**: > 100 dòng = vi phạm Atomic. Phải chẻ nhỏ (trừ `status: reference` hoặc `status: archived`).
5. **Footer Required**: Mọi note PHẢI kết thúc bằng `[[index]] | [[Tên MOC]]` để ingest script có thể validate classification. Thiếu footer = vi phạm, flag vào Wiki Health MOC.

**Ví dụ summary tốt vs slop:**

```yaml
# ✅ Tốt
summary: "Giải thích cơ chế attention trong Transformer — Q/K/V matrix và scaled dot-product."

# ❌ Slop
summary: "Ghi chú về AI"
summary: "Tổng hợp nội dung bài đọc"
```

---

## 🦅 Thiết luật Harvest (Project Management)

Mọi tri thức từ dự án thực tế PHẢI tuân thủ:

1. **Project MOC**: Tạo `[Project Name] MOC.md` trong `/MOCs` với tag `#projects` và `#moc`.
2. **Internal Linking**: Project MOC phải link tới `/Projects/[Project Name].md`.
3. **Cross-Linking**: Project MOC phải link tới Concepts/Tools dùng chung đã có.

---

## 🛠️ Phân khu Tri thức (LLM_Wiki/)

| Thư mục     | Mục đích                  | Câu hỏi trả lời |
| ----------- | ------------------------- | --------------- |
| `/Concepts` | Nguyên lý kỹ thuật        | How & Why       |
| `/Tools`    | Scripts, CLI, Snippets    | What & Code     |
| `/Projects` | Bối cảnh dự án thực tế    | Where & Context |
| `/MOCs`     | Bản đồ truy cập trung tâm | The Map         |

**Root is forbidden:** Never write a note directly to `LLM_Wiki/`. Every note must land in one of the subdirectories above. When in doubt, default to `LLM_Wiki/Projects/`.

---

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

---

## 🔄 Quy trình Ingest v7.3

```
0. Verify        → Run `ls` or `list_dir` to confirm target files exist before
                   any `read_file`. If Index is out of sync with reality, run
                   ingest immediately to reconcile before proceeding.
                   Never guess paths — verify first.
1. Search & Scan → Quét /raw tìm quặng thô. Chạy `ls -R LLM_Wiki/` và kiểm tra
                   Project MOC để xác định đúng target path trước khi tạo note.
                   Default path cho project notes: LLM_Wiki/Projects/
2. Deconstruct   → Dùng mẫu tại LLM_Wiki/Tools/Note Templates.md
3. Graph Linking → Kết nối vào MOC + note liên quan
4. Run Script    → bash ingest-memory.sh
5. Healer Review → Đọc Wiki Health MOC, fix các lỗi được flag
```

**Done criteria (bước 5):** Script hoàn thành khi không còn:

- Orphan note (MOC Missing)
- Broken link (trừ Draft/Planned được ignore)
- Note vi phạm Atomic (> line limit, không phải reference/archived)
- Note nằm sai vị trí (root `LLM_Wiki/` thay vì subfolder)
- Note thiếu footer `[[index]] | [[Tên MOC]]`

**Mandatory Sync Contract:**
Every write or edit to `LLM_Wiki/` is considered incomplete until `ingest-memory.sh`
has been executed successfully. The agent must not declare a task complete before
this step. If the script fails, report the error and halt — do not mark done.

---

## ⚠️ Anti-Slop Safeguards

- **Language Integrity**: Tài liệu nguồn tiếng Anh → giữ nguyên tiếng Anh trong Atomic Note.
- **Sync bắt buộc**: Mọi thay đổi logic phải đồng bộ `GEMINI.md`, `LLM Wiki.md`, các MOC liên quan. Script tự sync version string trong danh sách file cố định — nếu thêm file mới cần sync, cập nhật `files_to_sync` trong script.
- **Không orphan note**: Mọi note phải xuất hiện trong ít nhất 1 MOC.
- **Không mâu thuẫn**: Note A nói X, Note B nói Y → hợp nhất hoặc sửa đổi.

**Xử lý vi phạm:**

| Vi phạm               | Hành động                                                         |
| --------------------- | ----------------------------------------------------------------- | ------------------------------------------------ |
| Missing summary       | Flag trong Wiki Health MOC, thêm `summary:` trước lần ingest tiếp |
| Atomic quá dài        | Chẻ thành note con, link qua nhau                                 |
| Broken link           | Tạo note stub hoặc xóa link                                       |
| Orphan note           | Link vào MOC phù hợp                                              |
| Missing `#moc` tag    | Thêm vào frontmatter `tags:`                                      |
| Ingest chưa chạy      | Không được tuyên bố task hoàn thành — chạy script trước           |
| Note ở root LLM_Wiki/ | Move vào đúng subfolder, cập nhật links, chạy lại ingest          |
| Missing footer        | Thêm `[[index]]                                                   | [[Tên MOC]]` vào cuối note trước lần ingest tiếp |
