---
trigger: always_on
---

# GEMINI.md — Multi-Engine & Subagent Policy

> Priority: P0 engine profile. Shared governance lives in `SHARED.md`.
>
> changelog:
>
> - 2026-04-28: Initial engine foundation.
> - 2026-05-07: Split shared governance to `SHARED.md`.
> - 2026-10-22: Consolidate `CODEX.md` and remove stale `model-registry.md`; align subagent allocation with native Antigravity runtime.

---

## 1. Subagent & Model Allocation

- **Active Session Model:** Controlled directly by the user via the IDE/CLI selector. Never hardcode or assume stale model version strings in prompts or application code.
- **Subagent Dispatch (`invoke_subagent`):**
  - **`inherit` (Default):** Use for standard subagent tasks to match the parent session's model.
  - **`pro`:** Complex architecture, deep root-cause debugging, security reviews.
  - **`flash` / `flash_lite`:** High-speed mechanical edits, exploration, boilerplate generation, or parallel read-only tasks.
  - When in doubt between speed and correctness, bias toward correctness (`inherit` or `pro`).

---

## 2. Deep Reasoning Triggers

Escalate reasoning effort when any of the following apply:
- Multi-step logical inference spanning **more than 3 dependencies**.
- A previous implementation or fix attempt failed or produced contradictory results.
- High-risk operations involving **security, authentication, data integrity, or irreversible side effects**.

---

## 3. Cross-Harness Compatibility (Antigravity / Gemini / Codex)

- Root `GEMINI.md` is the canonical project instructions entrypoint.
- Root `AGENTS.md` acts as a lightweight pointer to `GEMINI.md` for Codex/Claude harnesses so instructions are never duplicated across files.
