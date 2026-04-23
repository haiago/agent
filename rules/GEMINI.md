---
trigger: always_on
priority: P0
---

# GEMINI.md — Universal Rules (Superpowers Edition)

> **Priority:** P0 (GEMINI.md) > P1 (SKILL.md)

---

## 🌐 Language & Output

- Respond in **user's language** (code/comments in English)
- **Chat responses: max 3 sentences** (canonical — overrides all other rules)
- **Implementation Plans & Reports**: Always write in **Vietnamese**.
- No meta-commentary ("I am analyzing...", "I will now...")
- All technical details → `reports/` (must include **Token Usage** section)

---

## ⚡ Superpowers Workflow (MANDATORY)

Operate using the **Research -> Strategy -> Execution** lifecycle:

1.  **Research**: Use `grep_search` and `glob` to understand the codebase.
2.  **Strategy**: For complex tasks, use `activate_skill` with `brainstorming` to design and `writing-plans` to create a plan.
3.  **Execution**: Use `subagent-driven-development` or `executing-plans` for implementation.
4.  **Validation**: ALWAYS run `npm run type-check` and relevant tests after any change.

---

## 🛑 Socratic Gate

Stop and ask before acting on complex/vague requests:

| Situation     | Action                                              |
| ------------- | --------------------------------------------------- |
| New feature   | 3 strategic questions (purpose, users, constraints) |
| Bug fix       | Confirm understanding + ask impact                  |
| Vague request | Ask scope, expected behavior, environment           |

> 🔴 **Skip Gate if:** Instructions are explicit and clear (e.g., "Implement X as planned").

---

## 🧹 Clean Code & Engineering Standards

- **Clean Code**: Concise, self-documenting, no over-engineering.
- **Testing**: Unit > Int > E2E, AAA Pattern (Arrange, Act, Assert).
- **Performance**: Measure before and after optimization.
- **Atomic Commits**: Commit each logical step as defined in the plan.

---

## 📁 Standardized Reporting

All technical summaries and analysis MUST be stored in the `/reports/` folder:
- **Format**: Markdown (.md)
- **Naming**: `{category}-{task-slug}.md`
- **Content**: Summary, Findings, Proposed changes, and Token Usage.

---

## 📊 Token Tracking

For every non-trivial task, include a token estimation table in the report:

| Component | Estimated Tokens |
|-----------|------------------|
| **Input Context** (System + Files) | ~N,NNN |
| **Output Generation** (Report + Chat) | ~N,NNN |
| **Total Task Consumption** | **~N,NNN tokens** |
