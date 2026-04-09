---
trigger: on_code_task
---

# Execution Flow & Optimization Rules

---

## 🤖 Debug Mode

Announce agent mỗi lượt:
`🤖 Agent: @[agent-name] — [reason] | Model: [model]`

---

## 🧠 Model Assignment

| Agent                                          | Model                          |
| ---------------------------------------------- | ------------------------------ |
| Orchestrator                                   | `gemini-3-flash`               |
| Backend, Frontend, Database, Debugger, Mobile, Performance, Security, Test, Planner | `gemini-3-pro` / `inherit` |
| Others (SEO, Doc, etc.)                        | `inherit` (Orchestrator model) |

### Fallback (Multi-Tier)

Nếu quota giới hạn hoặc có lỗi API:

1. `gemini-3-pro` → **`gemini-3-flash`**
2. `gemini-3-flash` → **`gemini-1.5-flash`**
3. Announce (BẮT BUỘC): `Model: [target-model] (Fallback: [actual-model])` trong dòng đầu tiên của chat/report.

---

## 🔒 Master Executor Rule

`@master-executor` là agent **DUY NHẤT** được write/edit source files.
Tất cả agents khác → chỉ ghi vào `reports/`.

---

## ⚡ Execution Flow

```
1. @orchestrator  → phân tích request
2. Route report:
   BUG     → reports/analysis.md
   FEATURE → reports/feature.md
   QUICK   → reports/quick-task.md
3. @master-executor → đọc reports/ → implement
4. Verify: build pass, no runtime errors
5. Output → reports/execution-report.md (kèm token count)
6. Update → reports/README.md (Work Index)
```

### 🔁 Retry (Auto Debug)

Nếu verify FAIL:

1. `@debugger` → `reports/debugger.md`
2. `@master-executor` → fix theo debug report
3. **Max 2 retries**

---

## ⚡ Rate Limit Safety

- Max **3 agents / request**
- Ưu tiên quick-task (0 agent)
- Không debug nếu không cần

---

## 📄 Output Rule

```
✅ Success → "✅ Done. reports/execution-report.md"
❌ Failure → "❌ [short reason]. reports/execution-report.md"
```

No more than 1 line in chat. Details go to report.

---

## 🧠 Context Optimization — Token Budget

### Selective Context Loading

| Context Type            | Load when                | Skip when                           |
| ----------------------- | ------------------------ | ----------------------------------- |
| Full chat history       | Multi-turn complex task  | Task độc lập → chỉ last 3 exchanges |
| File content >100 lines | Chỉ gửi phần liên quan   | Không gửi cả file                   |
| `reports/` cũ           | Task yêu cầu reuse       | Mặc định skip → đọc `index.json`    |
| Agent definitions       | First load trong session | Đã cache → skip                     |

### Token Budget per Request

| Request Type                  | Max Input | Khi vượt                                |
| ----------------------------- | --------- | --------------------------------------- |
| Quick task                    | 10,000    | Cắt history, giữ user prompt            |
| Bug / Feature (single domain) | 25,000    | Gửi file summaries thay vì full content |
| Multi-agent complex           | 60,000    | Gửi tuần tự, không gộp context          |

### Kỹ thuật cắt giảm

- **File:** `file_path + 1-2 câu tóm tắt + line numbers cần sửa`
- **History:** Mỗi agent chỉ nhận `last 3 exchanges` từ orchestrator
- **Reports:** Đọc `reports/README.md`, không đọc từng `.md`
- **Agent def:** Cache in-memory trong session, không reload

---

## 📊 reports/README.md Indexing

Tất cả các tệp phân tích kỹ thuật phải được dẫn link tại `reports/README.md` theo cấu trúc:
1. `[Tên file](file_path)`: Tóm tắt 1 câu.
2. Token Usage & Timestamp.

---

## 🔗 Integration

- Cache: `.agent/rules/CACHE.md`
- Master rules: `GEMINI.md`
