---
name: supabase-patterns
description: Supabase best practices, RLS setup, Auth integration, and Edge Functions optimization.
allowed-tools: Read, Write, Edit, Glob, Grep
---

# Supabase Patterns

> **Master the "Firebase Alternative" with PostgreSQL power.**

## 🎯 Selective Reading Rule

**Read ONLY files relevant to the request!**

| File | Description | When to Read |
|------|-------------|--------------|
| `auth-patterns.md` | Auth flows, Providers, SSR handling | Setting up authentication |
| `database-rls.md` | Row Level Security (RLS), Policies | Security & API access |
| `realtime-storage.md` | Realtime subscriptions, Buckets | Dynamic data & Files |
| `edge-functions.md` | Deno, Webhooks, Background tasks | Server-side logic |

---

## ⚠️ Core Principle

- **RLS IS NON-NEGOTIABLE:** Never disable RLS in production.
- **PostgreSQL First:** Use SQL functions/triggers when performance matters.
- **Client vs Server:** Use the right client for the environment (SSR vs Browser).

---

## Decision Checklist

- [ ] RLS enabled on all public tables?
- [ ] Correct Auth provider configured?
- [ ] SQL Migrations versioned?
- [ ] Storage policies defined?
- [ ] Edge functions optimized for cold starts?

---

## Anti-Patterns

❌ `service_role` key in the browser (Security Breach)
❌ Long-running queries in Edge Functions
❌ Deeply nested JSONB without indexing
❌ Ignoring PostgreSQL triggers for simple automation
❌ Not using TypeScript types for the database schema
