# Authentication Flow Best Practices

> **JWT is the core of Supabase. Use it wisely.**

## 🔐 Auth Providers
- **Email/Password:** Simplest for MVP.
- **Social Connectors (Google, GitHub):** Prefer OAuth for better UX.
- **Magic Links:** Good for high-security environments.

---

## ⚡ SSR Handling
When using Next.js or Nuxt, handle auth on the server to prevent flashing UI states.

### 1. Create Server Client
```typescript
import { createServerClient } from '@supabase/ssr'
```

### 2. Guard Middleware
Always verify the session in the middleware for protected routes.

---

## 👤 User Metadata
Use `user_metadata` for store public information like display names or avatars.

### Example update:
```typescript
const { data, error } = await supabase.auth.updateUser({
  data: { favorite_color: 'blue' }
})
```
