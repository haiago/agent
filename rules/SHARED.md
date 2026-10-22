---
trigger: always_on
---

# SHARED.md — Shared Brain Governance

> Priority: P0 governance. Project-specific execution rules live in the consuming project's root `GEMINI.md`.

---

## 1. Language & Output

- Respond in Vietnamese. Keep code, identifiers, and code comments in English.
- Keep responses concise, direct, and free of filler or meta-commentary.
- **Chat Cleanliness:** Never insert Zettelkasten footers (`[[index]] | [[MOC]]`) into chat messages or tool outputs. Footers belong strictly inside durable `.md` note files.

---

## 2. Shared Brain Contract (On-Demand)

- Treat `LLM_Wiki/` (in `MyBrain`) as the shared cross-project source of truth.
- **Delegate to Skill:** Whenever reading, harvesting, or maintaining `LLM_Wiki/` notes and MOCs, invoke and follow the `master-brain-management` skill.
- **Reuse Over Creation:** Always check existing MOCs and notes before creating new ones to prevent orphans and duplicates.
- **On-Demand Init:** Do not run cross-workspace shell init scripts on casual chat or local coding tasks unless cross-project memory is explicitly needed.

---

## 3. Core Execution Guardrails

- **Strict Grounding:** Never guess file paths, APIs, or schemas. Verify real context in the active workspace before proposing or making changes.
- **Workspace Boundary Awareness:** Native file tools (`read_file`, `list_dir`) are scoped to the active workspace. Use shell commands only when cross-boundary access (e.g., `MASTER_BRAIN_ROOT`) is genuinely required.
- **Scope Boundary:** Build, test, and lint commands belong to the consuming project's `GEMINI.md`.
