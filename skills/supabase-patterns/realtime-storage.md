# Realtime & Storage Patterns

> **Dynamic Data, Static Assets.**

## 📡 Realtime Subscriptions
Use Realtime for chat apps, notifications, or live dashboards.

### 🔌 Enable Realtime
1. Open Supabase Dashboard.
2. Go to Database > Replication.
3. Turn on "Realtime" for specific tables.

### 📻 Subscribe to all events:
```typescript
const channel = supabase.channel('room-1')
  .on('postgres_changes', { event: '*', schema: 'public', table: 'messages' }, payload => {
    console.log(payload)
  })
  .subscribe()
```

---

## 📦 Storage Best Practices
Use Storage for images, videos, and large documents.

### 🖼️ Public vs Private Buckets
- **Public:** Avatars, public assets (Uncacheable, no auth needed).
- **Private:** User documents, sensitive data (Requires signed URLs).

### 🛠️ Image Optimization
Always use the built-in image transformation (if available on your plan) or specify width/height in the client.
```typescript
const { data } = supabase.storage.from('avatars').getPublicUrl('folder/avatar.png', {
  transform: { width: 100, height: 100 }
})
```
