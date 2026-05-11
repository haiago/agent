---
trigger: always_on
---

# SHARED.md — Shared Brain Governance

> Priority: P0 governance. Project-specific execution rules should live outside this shared brain layer.
>
> changelog:
>
> - 2026-04-28: Foundation — fix stale model alias, Deep Think triggers, Wiki Health enforcement, versioning policy.
> - 2026-04-29: Execution discipline — Env First, Clean Root, Strict Grounding, Workspace Boundary Awareness, Grounding Over Creation, Notifications section.
> - 2026-04-30: Notifications — Finality rule (notify + stop, no text needed); move section before Scope Boundary.
> - 2026-05-02: Agent failure patterns — Known Failure Patterns section, No Unsolicited Init rule.
> - 2026-05-07: v7.7 Upgrade — Enforce Status Taxonomy (current/superseded), File Paths grounding (verified paths only), and When/Not-when sections in all project notes.
> - 2026-05-07: Extract shared governance from Gemini-specific rule for multi-engine bootstrap.
- 2026-05-11: Formalize '1-line footer rule' to prevent layering slop in Zettelkasten.
- 2026-05-11: Mandatory MOC Diary & Updated Date rule for all new note additions.
- 2026-05-11: Clarify Footer Integrity: apply to durable notes only, never to chat/logs.
- 2026-05-11: Deprecate 'Notifications (Ping Đại Ca)' rule to prevent execution loops.

---

## Language & Output

- Respond in the user's language. Keep code and code comments in English.
- Keep chat responses concise unless the user asks for more depth.
- Avoid meta-commentary and filler.
- **Chat Cleanliness (Required):** TUYỆT ĐỐI không chèn Footer của Zettelkasten (`[[index]] | [[MOC]]`) vào nội dung hội thoại chat hoặc log output của tool.

---

## Shared Brain Contract

- Treat `LLM_Wiki/` as the shared memory source of truth across projects.

- **Grounding Over Creation (Required):** Read `LLM_Wiki/index.md` and relevant MOCs before creating any new note.
  - Do not create orphan notes or duplicate notes.
  - If a topic already exists, update and enrich the existing note instead of creating a new one.
  - Prefer "Reuse" over "New" at all times.

- New notes must be linked into the graph and registered in the correct MOC.
- Prefer adding a durable knowledge artifact over leaving important reasoning trapped in chat.

---

## Note Quality Rules

- Every durable note must include frontmatter with at least:
  - `tags`
  - `summary`
  - `status` (Required v7.7): `current`, `superseded`, `historical`, `deprecated`, or `draft`.
- **Project Notes Requirements (v7.7):**
  - Must include `## 📁 File Paths` section with verified absolute paths from repo root.
  - Must include `## 🎯 When to use / When NOT to use` section.
- Keep notes atomic. If a note exceeds the local atomic limit, split it.
- Avoid dead notes: if a note has no meaningful links, route it into a MOC before finishing.
- Preserve technical terminology from the source material when translation would reduce accuracy.
- **MOC Maintenance (Required):** Khi thêm note mới vào MOC, PHẢI cập nhật section `## 📝 Nhật ký Tri thức` và trường `updated:` ở frontmatter.
- **Footer Integrity (Required v7.7):** Mọi note bền vững (durable note) PHẢI kết thúc bằng DUY NHẤT một đường kẻ --- và DUY NHẤT một dòng link [[index]] | [[Tên MOC]].
  - **Scope Limitation:** Quy định này CHỈ áp dụng cho file `.md` trong hệ thống tri thức. KHÔNG áp dụng cho tin nhắn chat, báo cáo tiến độ (reports), hoặc shell outputs.
- **No Duplicate Footers:** TUYỆT ĐỐI không chèn thêm footer nếu note đã có sẵn. Agent phải kiểm tra cuối file trước khi append. Ưu tiên ghi đè (overwrite) toàn bộ footer cũ thay vì nối thêm.

---

## Ingest & Maintenance

- **Canonical entrypoint:** `.agent/skills/master-brain-management/scripts/ingest-memory.sh`

- **Execution Discipline (Required):**
  - **Env First:** Before running any ingest or harvest operation, the agent must `read_file` and `source brain.env` to confirm `MASTER_BRAIN_ROOT` is correctly resolved.
  - **Clean Root before Ingest:** Only run the ingest script after confirming `LLM_Wiki/` contains no junk files (empty files, misplaced files). Agent must move or remove these automatically before proceeding.
  - **Strict Grounding (Required):** Never guess file paths. Before any `read_file` on a note from Index, run `ls` or `list_dir` to confirm the file exists. If Index is out of sync with reality, report immediately and run `ingest-memory.sh` to reconcile before proceeding.
  - **Workspace Boundary Awareness:** Native file tools (`read_file`, `list_dir`) are sandboxed to the current workspace. For paths outside the workspace (e.g., `MASTER_BRAIN_ROOT` on a different absolute path), use `run_shell_command` (`ls`, `cat`, `bash`) instead. This is not a workaround — it is the correct execution path for cross-boundary operations.

- **Fallback if script is missing:** Log a warning, then perform ingest manually following the steps documented in `LLM_Wiki/MOCs/Ingest Protocol MOC.md`.

- Resolve brain paths through `MASTER_BRAIN_ROOT` or the script's auto-detected repo root. Do not hardcode machine-specific absolute paths in shared rules or scripts.

- After substantial knowledge updates, regenerate `LLM_Wiki/index.md` and `LLM_Wiki/MOCs/Wiki Health MOC.md`.

- **Wiki Health enforcement:** Findings from `Wiki Health MOC` are treated as cleanup debt:
  - `P1` (broken links, missing frontmatter) → fix before closing the session.
  - `P2` (dead notes, missing MOC registration) → fix within the next 2 ingest cycles.
  - `P3` (style/formatting) → batch and fix opportunistically.

---

## Versioning

- This file tracks its own change history via the `changelog` field in the header.
- When making non-trivial edits, append a one-line summary to `changelog` with the date.
- Do not rewrite history — append only.

---
---

## Known Agent Failure Patterns

These patterns are known failure modes — agent must actively guard against them every session.

| Pattern               | Mô tả                                                                         | Phòng tránh                                                   |
| :-------------------- | :---------------------------------------------------------------------------- | :------------------------------------------------------------ |
| Structural only       | Script không detect lỗi nghiệp vụ — wiki xanh không có nghĩa là nội dung đúng | Tự đối soát `ls Projects/` vs MOC sau mỗi task                |
| Rule retroactivity    | Rule mới không tự apply cho note cũ                                           | Audit thủ công sau mỗi lần bump skill version                 |
| Agent subjectivity    | Tin MOC cũ mà không rà soát note mới nhất                                     | Cross-check trước khi tuyên bố done                           |
| Context contamination | "Nhuộm màu" tri thức chung theo context hiện tại (Creative Slop)              | Grep file gốc để verify — không suy diễn từ context           |
| Footer Layering       | Lạm dụng đường kẻ --- hoặc chèn nhiều dòng link ở footer                      | Chỉ dùng 1 đường kẻ + 1 dòng link ở cuối cùng                 |
| Footer Redundancy     | Chèn trùng lặp nhiều footer/index chồng chéo do dùng lệnh append vô tội vạ    | Kiểm tra cuối file trước khi ghi; dùng overwrite thay vì append |
| MOC Stale Diary       | Quên cập nhật Nhật ký và \`updated\` date khi thêm note mới vào MOC           | Thực hiện MOC Maintenance Protocol trước khi kết thúc task    |
| Unsolicited Auto-Init | Tự chạy Session Init sau casual request không có task thực sự                 | Chỉ ground khi có task cụ thể — small talk không trigger Init |

---

## Scope Boundary

- Shared brain governance defines how agents read, write, and maintain memory.
- Build commands, test commands, package-manager commands, and runtime-specific workflows belong to project execution rules, not this file.
- If a project needs stricter execution policy, define it in the consuming repo so the shared submodule stays portable.
