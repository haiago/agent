# 🏯 Agent Superpowers & Master Brain Hub (v7.7 / Superpowers v7.0.1)

> **"Code mướt, múa lửa, tri thức kết tinh."**  
> *Trung tâm điều hành kỹ năng (Skills), hiến pháp quản trị (Rules), và hạ tầng tác chiến dành cho toàn bộ AI Agent (Gemini 3.8, Codex, Claude Code) trong hệ sinh thái của Đại Ca.*

---

## 🌟 Điểm nổi bật & Phiên bản

* **Superpowers Core:** `v7.0.1` (Upstream từ `obra/superpowers` — tương thích native Antigravity IDE & Gemini CLI).
* **Master Brain Protocol:** `v7.7` (Quy chuẩn Sentinel, Zettelkasten MOC Diary, 1-line footer integrity, chống Creative Slop).
* **Persona:** Lão Ní Senior Pro (Pragmatic, witty, grounding-first, triệt tiêu slop).

---

## 🚀 Kiến trúc Triển khai (Deployment)

### 1. Chuẩn Hiện đại: Antigravity Global Plugin (Zero-Submodule — Khuyến nghị)
Không cần nhúng submodule vào từng project con. Cài đặt **1 lần duy nhất** để dùng chung cho toàn máy:

```bash
# Clone repo về thư mục trung tâm
git clone https://github.com/haiago/agent.git /Users/ha/Project/agent

# Tạo symlink vào plugins của Antigravity
ln -sfn /Users/ha/Project/agent ~/.gemini/config/plugins/superpowers
```

> **Lợi ích:** Mọi dự án (`WorkDone`, `WorkChat`, `WorkAI`, `TiTach`...) tự động thừa hưởng toàn bộ vũ khí và rules mới nhất. Khi cần nâng cấp, chỉ cần `git pull` hoặc sửa tại `/Users/ha/Project/agent` — không lo lệch version hay kẹt lock sandbox.

### 2. Chuẩn Legacy: Git Submodule
Dành cho các repo cần đóng gói submodule độc lập:

```bash
git submodule add https://github.com/haiago/agent.git .agent
```

---

## 📂 Cấu trúc Hub

```text
agent/
├── .antigravity-plugin/      # Manifest tích hợp native cho Antigravity IDE
│   └── plugin.json
├── rules/                    # Hiến pháp quản trị đa Engine (Multi-Engine Governance)
│   ├── SHARED.md             # Quy tắc chung: Memory contract, Note quality, Anti-slop
│   ├── PERSONALITY.md        # Nhân cách "Lão Ní Senior Pro" (SOI → CHIA → MÚA → SOÁT → KHẮC)
│   ├── GEMINI.md             # Engine policy P0 cho Google Gemini
│   ├── CODEX.md              # Engine policy cho OpenAI Codex
│   └── model-registry.md     # Danh bạ các model tier (Pro / Flash / Flash-Lite)
├── skills/                   # Kho vũ khí tác chiến (Composable Skills)
│   ├── using-superpowers/    # Điều phối kích hoạt skill tự động
│   ├── brainstorming/        # [v7.0.1] Interactive Discovery & Builder Check subagent
│   ├── writing-plans/        # Lập kế hoạch triển khai chi tiết (TDD, YAGNI, DRY)
│   ├── executing-plans/      # [v7.0.1] Native execution engine, tối ưu token
│   ├── subagent-driven-development/ # Quy trình phối hợp subagents chuyên biệt
│   ├── diagnosing-superpowers/      # [Mới] Khám bệnh & phân tích khi agent lệch ray
│   ├── systematic-debugging/        # Truy vết nguyên nhân gốc rễ (Root Cause)
│   ├── test-driven-development/     # Red/Green/Refactor thực chiến
│   ├── master-brain-management/     # Sentinel v7.7: Ingest & Audit sức khỏe Zettelkasten
│   ├── clean-code/           # Chuẩn mực code sạch, chống over-engineering
│   ├── frontend-design/      # Tư duy thiết kế UI/UX hiện đại
│   └── ...                   # Hơn 20+ specialized domain skills khác
└── RELEASE-NOTES.md          # Lịch sử nâng cấp chi tiết từ upstream
```

---

## ⚡ Kho Vũ Khí Cốt Lõi (Core Superpowers v7.0.1)

1. **🧠 Interactive Brainstorming & Builder Check:**
   * Không vội viết code ngay. Agent hỏi sâu, lặp lại ý hiểu để tinh chỉnh yêu cầu.
   * Spawn subagent độc lập đóng vai **"Thợ Build" (Builder Check)** để soi trước toàn bộ lỗ hổng spec và rủi ro kỹ thuật.
2. **⚡ Native Executing-Plans:**
   * Chạy kế hoạch một cách tinh gọn, tự động theo dõi task (`task-start`, `task-done`), tiết kiệm tối đa token mà không bắt buộc phải spawn subagent cồng kềnh cho mọi việc nhỏ.
3. **🩺 Diagnosing Superpowers:**
   * Tự động audit, chẩn đoán phiên làm việc khi gặp sự cố, lặp lại công việc (repeated work), hoặc đi chệch khỏi kế hoạch đã duyệt.
4. **🛡️ Triệt tiêu Slop & Token Bloat:**
   * Chuẩn hóa prompt reviewers (`spec-reviewer-prompt.md`, `code-quality-reviewer-prompt.md`), cắt bỏ nội dung trùng lặp giữa các engine profiles.

---

## ⚖️ Kỷ luật Thực chiến (The Unbreakable Rules)

1. **Grounding First (Bắt buộc):** Luôn `read_file`, `grep` hoặc verify thực tế trước khi khẳng định hay sửa code. Tuyệt đối không suy diễn, không đoán mò.
2. **Stop & Confirm (Bắt buộc):** Với mọi task có Plan/Spec hoặc Subagent, Agent **PHẢI DỪNG LẠI**, trình bày rõ ràng và chờ sự đồng ý (intent-based approval) của Đại Ca trước khi chạm vào code.
3. **Múa Protocol:** Tuân thủ 5 bước: **SOI** (đọc hiểu) ➔ **CHIA** (chia nhỏ) ➔ **MÚA** (thực thi) ➔ **SOÁT** (kiểm thử) ➔ **KHẮC** (đúc kết vào Master Brain).
4. **Chat Cleanliness:** Tuyệt đối không chèn footer Zettelkasten (`[[index]] | [[MOC]]`) vào tin nhắn chat hoặc tool output.

---

## 🔄 Quy trình Nâng cấp & Bảo trì (Maintenance)

* Khi có bản phát hành mới từ upstream `obra/superpowers`:
  1. Fetch upstream tags: `git fetch upstream`
  2. Thực hiện **Selective Sync** các core skills trong thư mục `skills/`.
  3. Bảo toàn 100% các file rules trong `rules/` và skill `master-brain-management/`.
  4. Test manifest: `.antigravity-plugin/plugin.json`.
  5. Commit và push lên `origin main`.

---

*Được rèn giũa và nâng cấp bởi **Lão Ní Senior Pro** — Master Brain Sentinel.*
