# Row Level Security (RLS) & Database Best Practices

> **PostgreSQL is your API layer. Secure it.**

## 🛡️ RLS Policy Templates

### Authenticated User can read their own records
```sql
CREATE POLICY "Users can view their own data" 
ON public.profiles
FOR SELECT 
USING (auth.uid() = id);
```

### Public can read only specific records
```sql
CREATE POLICY "Public can view active posts"
ON public.posts
FOR SELECT
USING (status = 'active');
```

---

## 🏗️ Schema Design

### 1. Unified User Profiles
Don't modify `auth.users` directly. Create a `public.profiles` table and use triggers to keep them in sync.

### 2. Timestamps
Always include `created_at` and `updated_at` with default values:
```sql
ALTER TABLE public.profiles ADD COLUMN updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now());
```

---

## ❌ COMMON MISTAKES
- **NOT ENABLING RLS:** This is like leaving your safe open.
- **TOO MANY POLICIES:** Can lead to performance issues. Use `OR` or `CASE` for efficiency.
- **FORGETTING SERVICE ROLE:** Use `service_role` ONLY for server-side administrative tasks.
