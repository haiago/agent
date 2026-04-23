---
trigger: always_on
priority: P0
---

# GEMINI.md — Universal Rules

> **Priority:** P0 (GEMINI.md) > P1 (Agent .md) > P2 (SKILL.md)
> **Refs:** `.agent/rules/EXECUTION_FLOW.md` | `.agent/rules/CACHE.md`

---

## 🌐 Language & Output

- Respond in **user's language** (code/comments in English)
- **Chat responses: max 3 sentences** (canonical — overrides all other rules)
- **Implementation Plans & Reports**: Always write in **Vietnamese**.
- No meta-commentary ("I am analyzing...", "I will now...")
- All technical details → `reports/` (must include **Token Usage** section)

---

## 📊 Token Tracking

For every non-trivial task, include a token estimation table in the report:

| Component | Estimated Tokens |
|-----------|------------------|
| **Input Context** (System + Files) | ~N,NNN |
| **Output Generation** (Report + Chat) | ~N,NNN |
| **Total Task Consumption** | **~N,NNN tokens** |


---

## 📥 STEP 0: Classify Request

| Type         | Trigger                             | Action                   |
| ------------ | ----------------------------------- | ------------------------ |
| QUESTION     | "what is", "how does", "explain"    | Text response, no agents |
| SURVEY       | "analyze", "list files", "overview" | `explorer-agent`         |
| SIMPLE CODE  | 1 file, <50 lines                   | Inline edit, no plan     |
| COMPLEX CODE | ≥2 files, ≥100 lines                | Create `{task-slug}.md`  |
| DESIGN/UI    | "design", "UI", "page", "dashboard" | Create `{task-slug}.md`  |

---

## 🤖 STEP 1: Auto-Routing

1. Silent domain detection from keywords
2. Announce: `🤖 Agent: @[agent-name] — [reason] | Model: [model]`
3. Load agent rules from `.agent/agents/[agent].md` **(skip if cached this session)**

### Routing Table

| Signal                               | Agent                   |
| ------------------------------------ | ----------------------- |
| Vue, React, component, CSS, UI       | `frontend-specialist`   |
| API, Express, auth, server, endpoint | `backend-specialist`    |
| Prisma, schema, migration, query     | `database-architect`    |
| slow, performance, optimize, bundle  | `performance-optimizer` |
| security, CORS, OWASP, XSS           | `security-auditor`      |
| test, coverage, unit, E2E            | `test-engineer`         |
| mobile, React Native, Flutter, Expo  | `mobile-developer`      |
| deploy, CI/CD, Docker, PM2, k8s      | `devops-engineer`       |
| documentation, README, comment       | `documentation-writer`  |

> 🔴 Mobile project → ONLY `mobile-developer`
> 🔴 Unknown domain → Ask: "Specify domain (frontend/backend/database/...)"

---

## 🛑 STEP 2: Socratic Gate

Stop and ask before acting on complex/vague requests:

| Situation     | Action                                              |
| ------------- | --------------------------------------------------- |
| New feature   | 3 strategic questions (purpose, users, constraints) |
| Bug fix       | Confirm understanding + ask impact                  |
| Vague request | Ask scope, expected behavior, environment           |

> 🔴 **Skip Gate if:** Request is simple (<50 lines), repetitive, or instructions are explicit and clear (e.g., "Implement X as planned").


---

## ✅ STEP 3: Pre-Code Checklist

- [ ] Clean Code (`@skills/clean-code`)
- [ ] Check `CODEBASE.md` for file dependencies
- [ ] Correct agent assigned
- [ ] Socratic gate cleared

---

## 🧹 Clean Code (MANDATORY)

- Concise, self-documenting, no over-engineering
- Testing: Unit > Int > E2E, AAA Pattern
- Performance: measure first

---

## 📁 Quick Reference

- **Architecture:** `ARCHITECTURE.md`
- **Agents:** `.agent/agents/`
- **Skills:** `.agent/skills/`
- **Rules:** `.agent/rules/`

---

## 📁 Standardized Reporting

All technical summaries and analysis MUST be stored in the `/reports/` folder:
- **Format**: Markdown (.md)
- **Naming**: `{category}-{task-slug}.md`
- **Content**: Summary, Findings, Proposed changes, and Token Usage.

