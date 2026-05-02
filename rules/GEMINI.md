---
trigger: always_on
---

# GEMINI.md — Shared Brain Governance

> Priority: P0 governance. Project-specific execution rules should live outside this shared brain layer.
>
> changelog:
>
> - 2026-04-28: Fix stale model alias, clarify task allocation, add Deep Think triggers, add ingest fallback, add versioning policy, add Wiki Health enforcement tiers.
> - 2026-04-29: Add execution discipline (Env First, Clean Root), add Grounding Over Creation rule.
> - 2026-04-29: Normalize language to English throughout; replace "S-Tier" label with "Required"; resolve P0 label collision; restore full changelog history.
> - 2026-04-29: Add Strict Grounding rule to Execution Discipline — verify paths before read_file, reconcile Index on mismatch.
> - 2026-04-30: Add Workspace Boundary Awareness — shell fallback for cross-boundary paths is correct behavior, not a workaround.
> - 2026-04-30: Add Notifications (Ping Đại Ca) section; move before Scope Boundary.
> - 2026-05-02: Add Known Agent Failure Patterns — context contamination, rule retroactivity, structural-only blind spot.
> - 2026-05-02: Add Finality rule to Notifications; add Echoing Loop to Known Failure Patterns.
> - 2026-05-02: Add No Unsolicited Init rule; add Unsolicited Auto-Init to Known Failure Patterns.

---

## Language & Output

- Respond in the user's language. Keep code and code comments in English.
- Keep chat responses concise unless the user asks for more depth.
- Avoid meta-commentary and filler.

---

## Model & Engine

- **Primary Engine:** Always prioritize the **Gemini series**. Resolve the exact model alias at runtime from `./model-registry.md` — never hardcode a version string in this file.
- **Review cadence:** Re-evaluate the active model alias at least once per quarter or when a new major version is released.

- **Task Allocation** (guidelines, not hard rules — use judgment):
  - **Pro tier:** Complex reasoning, architectural design, debugging deep-rooted issues, final code reviews.
  - **Flash tier:** Rapid implementation, mechanical tasks, unit test generation, initial drafts.
  - When in doubt about tier, default to Pro. Speed is secondary to correctness.

- **Deep Think:** Activate when **any** of the following apply:
  - The problem requires multi-step logical inference across more than 3 dependencies.
  - An initial approach has failed or produced contradictory output.
  - The task involves security, data integrity, or irreversible side effects.
  - The user explicitly requests it.

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
- Keep notes atomic. If a note exceeds the local atomic limit, split it.
- Avoid dead notes: if a note has no meaningful links, route it into a MOC before finishing.
- Preserve technical terminology from the source material when translation would reduce accuracy.

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

## Notifications (Ping Đại Ca)

- **Always Ping on Stop/Complete (Required):** Whenever you finish a task, or whenever you stop to wait for the user's confirmation (e.g., after presenting a plan, needing approval, or hitting a roadblock), you MUST run the notification script to ping the user.
- **Finality (Required):** The text output accompanying the notification call must be the definitive and final response for that turn. Do NOT re-state or repeat previous explanations after the shell returns success.
- **No Unsolicited Init (Required):** Session Init (source brain.env, read MOC) only runs when there is a real task. Casual conversation, small talk, creative requests (thơ, jokes...) do NOT trigger Session Init.
- **Command:** Execute `bash .agent/scripts/notify_me.sh "<Your short message>"` using your terminal tool before yielding control.
- **Tone:** Keep the message short, witty, and in character (e.g., "Ê đại ca, check plan cho tui nè", "Xong task rồi, đại ca vào nghiệm thu!", "Có biến rồi đại ca, vô cứu tui!").

---

## Known Agent Failure Patterns

These patterns are known failure modes — agent must actively guard against them every session.

| Pattern               | Mô tả                                                                         | Phòng tránh                                                   |
| :-------------------- | :---------------------------------------------------------------------------- | :------------------------------------------------------------ |
| Structural only       | Script không detect lỗi nghiệp vụ — wiki xanh không có nghĩa là nội dung đúng | Tự đối soát `ls Projects/` vs MOC sau mỗi task                |
| Rule retroactivity    | Rule mới không tự apply cho note cũ                                           | Audit thủ công sau mỗi lần bump skill version                 |
| Agent subjectivity    | Tin MOC cũ mà không rà soát note mới nhất                                     | Cross-check trước khi tuyên bố done                           |
| Context contamination | "Nhuộm màu" tri thức chung theo context hiện tại (Creative Slop)              | Grep file gốc để verify — không suy diễn từ context           |
| Echoing Loop          | Lặp lại toàn bộ câu trả lời sau khi tool phụ trợ (notify) trả về kết quả      | Thực hiện Finality: notify là bước cuối cùng của turn         |
| Unsolicited Auto-Init | Tự chạy Session Init sau casual request không có task thực sự                 | Chỉ ground khi có task cụ thể — small talk không trigger Init |

---

## Scope Boundary

- Shared brain governance defines how agents read, write, and maintain memory.
- Build commands, test commands, package-manager commands, and runtime-specific workflows belong to project execution rules, not this file.
- If a project needs stricter execution policy, define it in the consuming repo so the shared submodule stays portable.
