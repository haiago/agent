---
trigger: always_on
priority: P0
---

# GEMINI.md — Shared Brain Governance

> Priority: P0 governance. Project-specific execution rules should live outside this shared brain layer.

## Language & Output

- Respond in the user's language. Keep code and code comments in English.
- Keep chat responses concise unless the user asks for more depth.
- Avoid meta-commentary and filler.

## Shared Brain Contract

- Treat `LLM_Wiki/` as the shared memory source of truth across projects.
- Read `LLM_Wiki/index.md` before creating new notes or repeating known context.
- New notes must be linked into the graph and registered in the correct MOC.
- Prefer adding a durable knowledge artifact over leaving important reasoning trapped in chat.

## Note Quality Rules

- Every durable note should include frontmatter with at least:
  - `tags`
  - `summary`
- Keep notes atomic. If a note exceeds the local atomic limit, split it.
- Avoid dead notes: if a note has no meaningful links, route it into a MOC before finishing.
- Preserve technical terminology from the source material when translation would reduce accuracy.

## Ingest & Maintenance

- Use `.agent/skills/master-brain-management/scripts/ingest-memory.sh` as the canonical ingest entrypoint.
- Resolve brain paths through `MASTER_BRAIN_ROOT` or the script's auto-detected repo root. Do not hardcode machine-specific absolute paths in shared rules or scripts.
- After substantial knowledge updates, regenerate `LLM_Wiki/index.md` and `LLM_Wiki/MOCs/Wiki Health MOC.md`.
- Treat `Wiki Health MOC` findings as cleanup debt, not ignorable noise.

## Scope Boundary

- Shared brain governance defines how agents read, write, and maintain memory.
- Build commands, test commands, package-manager commands, and runtime-specific workflows belong to project execution rules, not this file.
- If a project needs stricter execution policy, define it in the consuming repo so the shared submodule stays portable.
