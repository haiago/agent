---
trigger: always_on
---

# SHARED.md — Shared Brain Governance

> Priority: P0 governance. Project-specific execution rules live in the project's root `GEMINI.md`.
>
> changelog:
>
> - 2026-04-28: Initial shared governance foundation.
> - 2026-05-07: v7.7 Upgrade — Status taxonomy, File Paths grounding, multi-engine split.
> - 2026-05-11: Formalize 1-line footer, MOC Diary, and deprecate notification loop.
> - 2026-10-22: Streamline always-on context — delegate detailed Zettelkasten mechanics to `master-brain-management` skill to eliminate token bloat and Constraint Tax.

---

## 1. Language & Output

- Respond in the user's language (Vietnamese). Keep code, identifiers, and code comments in English.
- Keep responses concise, direct, and free of filler or meta-commentary.
- **Chat Cleanliness (Required):** Never insert Zettelkasten footers (`[[index]] | [[MOC]]`) into chat messages or tool outputs. Footers belong strictly inside durable `.md` note files.

---

## 2. Shared Brain Contract (On-Demand)

- Treat `LLM_Wiki/` (in `MyBrain`) as the shared cross-project source of truth.
- **Delegate to Skill:** Whenever reading, harvesting, or maintaining `LLM_Wiki/` notes and MOCs, **invoke and follow the `master-brain-management` skill**.
  - Detailed mechanics (Atomic note rules, Frontmatter schema, 1-line Footer integrity, MOC Diary rotation, and `ingest-memory.sh` execution) are governed by `master-brain-management` so they do not bloat everyday coding context.
- **Reuse Over Creation:** Always check existing MOCs/notes before creating new ones to prevent orphans and duplicates.
- **No Unsolicited Init:** Do not run cross-workspace shell init scripts on casual chat or local coding tasks unless cross-project memory is needed.

---

## 3. Core Execution Guardrails

- **Strict Grounding:** Never guess file paths, APIs, or schemas. Verify context in the active workspace before proposing or making changes.
- **Workspace Boundary Awareness:** Native tools (`read_file`, `list_dir`) are scoped to the current workspace. Use shell commands only when cross-boundary access (e.g., `MASTER_BRAIN_ROOT`) is genuinely required.
- **Scope Boundary:** Build, test, and lint commands belong to the consuming project's `GEMINI.md`, keeping this shared layer portable across all repositories.
