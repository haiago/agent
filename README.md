# 🛠️ Agent Superpowers & Shared Governance (v5.x)

Thư mục này là "trung tâm điều khiển" chứa toàn bộ kỹ năng (skills), quy tắc (rules), và công cụ quản trị dành cho các AI Agent (Gemini CLI, Claude Code, Cursor, v.v.).

Đây là một submodule được thiết kế để dùng chung (shared) giữa nhiều dự án, giúp duy trì sự nhất quán trong cách Agent suy nghĩ, làm việc và tương tác với bộ não tri thức (**Master Brain**).

## 📂 Cấu trúc chính

- **`rules/`**: Định nghĩa "nhân cách" và quy tắc ứng xử cốt lõi (`PERSONALITY.md`, `GEMINI.md`). Đây là nơi thiết lập các mandate về bảo mật, phong cách code và quản trị bộ não.
- **`skills/`**: Thư viện kỹ năng thực chiến.
  - `master-brain-management`: Quy trình luyện hóa tri thức, ingest memory.
  - `test-driven-development`: Quy trình RED-GREEN-REFACTOR bắt buộc.
  - `brainstorming`: Thiết kế hệ thống thông qua hỏi đáp Socratic.
  - `systematic-debugging`: Quy trình 4 bước truy tìm root cause.
- **`scripts/`**: Các công cụ bảo trì.
  - `setup-agent.sh`: Cài đặt nhanh môi trường.
  - `ingest-memory.sh`: (Nằm trong skill master-brain) Dùng để cập nhật `LLM_Wiki`.
- **`agents/`**: Định nghĩa các chuyên gia (Sub-agents) như `code-reviewer`.

## 🚀 Cách sử dụng

### 1. Đối với Gemini CLI
Hệ thống sẽ tự động nhận diện các skill trong thư mục này. Để kích hoạt một kỹ năng cụ thể:
```text
activate_skill(name="master-brain-management")
```
Hoặc đơn giản là yêu cầu Agent thực hiện nhiệm vụ liên quan (ví dụ: "ingest memory"), Agent sẽ tự động tìm skill phù hợp thông qua `intelligent-routing`.

### 2. Đối với Claude Code
Cài đặt như một plugin:
```bash
/plugin install superpowers@superpowers-marketplace
```

### 3. Tích hợp vào dự án mới (Submodule)
Để dùng bộ rules và skills này cho một project khác:
```bash
git submodule add <url-repo-mybrain> .agent
```
Sau đó cấu hình `GEMINI.md` của project đó để trỏ về shared rules trong `.agent/rules/`.

## 🧠 Master Brain Ingest Workflow

Đây là tính năng quan trọng nhất để bảo trì tri thức. Khi có thông tin mới cần "luyện hóa" vào `LLM_Wiki`, hãy chạy:

```bash
bash .agent/skills/master-brain-management/scripts/ingest-memory.sh
```

Quy trình này sẽ:
1. Tổng hợp các note từ `raw/`.
2. Kiểm tra tính atomic và broken links.
3. Cập nhật `LLM_Wiki/index.md` và `Wiki Health MOC`.

## 📜 Triết lý làm việc

- **Grounding First**: Luôn đọc file/tra cứu tri thức trước khi trả lời.
- **TDD Mandatory**: Không có test = không có code hoàn tất.
- **Evidence over Claims**: Xác minh kết quả bằng lệnh thực tế, không hứa suông.

---
*Duy trì bởi Lão Ní & Đội ngũ Sentinel.*
