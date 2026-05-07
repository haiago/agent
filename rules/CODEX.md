---
trigger: always_on
---

# CODEX.md — Codex Engine Rules

> changelog:
>
> - 2026-05-07: Initial Codex engine profile for Master Brain bootstrap.

---

## Model & Engine

- **Primary Engine:** Codex. Prefer the default project model unless the user explicitly requests a different model.
- **Reasoning Effort:** Scale effort to task complexity instead of switching named model aliases:
  - **High / xhigh:** Deep architecture, tricky debugging, security-sensitive work, irreversible side effects, or conflicting evidence.
  - **Medium:** Normal implementation, repo refactors, and reviews.
  - **Low:** Mechanical edits, repetitive formatting, straightforward boilerplate.
- When in doubt, bias toward correctness over latency.

- **Deep Think:** Increase reasoning effort when any of the following apply:
  - The problem requires multi-step logical inference across more than 3 dependencies.
  - An initial approach has failed or produced contradictory output.
  - The task involves security, data integrity, or irreversible side effects.
  - The user explicitly requests deeper reasoning.

---

## Codex Runtime Notes

- Use `AGENTS.md` at repo root as the Codex bootstrap entrypoint for project instructions.
- Keep engine-specific rules in this file. Keep shared governance in `SHARED.md`.
- If a rule mentions a platform-specific tool that Codex does not expose, translate it to the closest Codex-native tool rather than dropping the requirement.
