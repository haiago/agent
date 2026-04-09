---
trigger: on_report_read
---

# Cache Mechanism

---

## 📁 Storage

- **Cache file:** `reports/.cache/task_cache.json`
- **TTL:** 1 hour, hoặc reset khi session kết thúc (whichever comes first)

---

## 🔑 Fingerprint Calculation

Fingerprint là hash định danh một task, dùng để check cache hit/miss.

### Inputs để tính fingerprint

```
fingerprint = hash(
  task_type,        // "bug" | "feature" | "quick-task"
  file_paths[],     // danh sách file liên quan (sorted)
  prompt_summary,   // 1-2 từ khóa chính của user prompt
  agent_name        // agent được assign
)
```

### Ví dụ

```json
{
  "fingerprint": "a3f9c2b1",
  "task_type": "bug",
  "file_paths": ["src/main.ts", "src/components/Chat.vue"],
  "prompt_summary": "CORS header missing",
  "agent_name": "backend-specialist",
  "created_at": "2025-01-15T10:30:00Z",
  "expires_at": "2025-01-15T11:30:00Z",
  "report_path": "reports/analysis.md",
  "token_count": 3800
}
```

---

## ⚙️ Cache Logic

### Check cache (BEFORE running task)

```
1. Tính fingerprint từ current request
2. Kiểm tra **Forced Refresh**: Nếu prompt chứa từ khóa ("re-run", "thực hiện lại", "update rules") → **Dừng**, bỏ qua cache.
3. Lookup fingerprint trong task_cache.json
4. Nếu HIT và chưa expired → return cached report_path, skip re-run
5. Nếu MISS hoặc expired → run task, lưu cache mới
```

### Cache hit response

```
✅ Cache hit. Report: reports/[cached_report].md (saved ~[token_count] tokens)
```

### Cache invalidation

Tự động invalidate khi:

- File trong `file_paths[]` bị modified (check mtime)
- TTL hết hạn (>1 hour)
- User gõ lệnh: `!clear-cache`

---

## 📄 task_cache.json Schema

```json
{
  "version": "1.0",
  "entries": [
    {
      "fingerprint": "string (8 chars hex)",
      "task_type": "bug | feature | quick-task | survey",
      "file_paths": ["string"],
      "prompt_summary": "string",
      "agent_name": "string",
      "created_at": "ISO8601",
      "expires_at": "ISO8601",
      "report_path": "string",
      "token_count": "number"
    }
  ]
}
```

---

## 🧹 Cache Maintenance

- Max **50 entries** trong cache file
- Khi vượt 50 → xóa entries cũ nhất (LRU)
- Không cache task có `token_count < 1000` (để tránh nhiễu do các tác vụ cực nhỏ)

---

## 🔗 Integration

- Cache được check bởi `@orchestrator` ở STEP 0
- Work index: `reports/README.md` (xem `EXECUTION_FLOW.md`)
