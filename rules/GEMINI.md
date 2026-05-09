---
trigger: always_on
---

# GEMINI.md — Gemini Engine Rules

> Priority: P0 engine profile. Shared governance lives in `SHARED.md`.
>
> changelog:
>
> - 2026-04-28: Foundation — fix stale model alias, Deep Think triggers, Wiki Health enforcement, versioning policy.
> - 2026-04-29: Execution discipline — Env First, Clean Root, Strict Grounding, Workspace Boundary Awareness, Grounding Over Creation, Notifications section.
> - 2026-04-30: Notifications — Finality rule (notify + stop, no text needed); move section before Scope Boundary.
> - 2026-05-02: Agent failure patterns — Known Failure Patterns section, No Unsolicited Init rule.
> - 2026-05-07: v7.7 Upgrade — Enforce Status Taxonomy (current/superseded), File Paths grounding (verified paths only), and When/Not-when sections in all project notes.
> - 2026-05-07: Extract shared governance to `SHARED.md`; keep Gemini-specific engine policy only.
> - 2026-05-07: Clarify bootstrap role: this file now exists only for Gemini-specific engine policy.

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

## Gemini Runtime Notes

- Use root `GEMINI.md` as the Gemini bootstrap entrypoint for project instructions.
- Keep engine-specific rules in this file. Keep shared governance in `SHARED.md`.
- If a project also supports Codex, treat `CODEX.md` as a sibling engine profile rather than a competing source of truth.
