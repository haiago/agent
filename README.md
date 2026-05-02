# 🛠️ Agent Superpowers & Shared Governance (v7.3)

Thư mục này là "trung tâm điều hành" (Central Control Hub) chứa toàn bộ kỹ năng (skills), quy tắc (rules), và hạ tầng quản trị dành cho các AI Agent trong hệ sinh thái của Đại Ca.

Đây là một submodule được thiết kế để dùng chung (shared) giữa nhiều dự án, giúp duy trì sự nhất quán trong "nhân cách" và workflow thực chiến của Agent.

## 📂 Cấu trúc Core

- **`rules/`**: Định nghĩa bản sắc và kỷ luật vận hành cốt lõi.
  - `PERSONALITY.md`: Linh hồn Senior Engineer "Lão Ní" v7.3.
  - `GEMINI.md`: Hiến pháp Master Brain (Grounding, Ingest, Boundary Awareness).
- **`skills/`**: Thư viện kỹ năng chuyên biệt hóa.
  - `master-brain-management`: Hệ thống quản trị tri thức Zettelkasten (Sentinel v7.3).
  - `app-builder`: Orchestrator xây dựng ứng dụng full-stack.
  - `architecture`: Khung ra quyết định và thiết kế hệ thống.
  - `intelligent-routing`: Tự động điều phối Agent và Skill.
- **`scripts/`**: Công cụ hỗ trợ & Automation.
  - `notify_me.sh`: Script "Hú Đại Ca" qua Telegram (Mandatory Ping).
  - `ingest-memory.sh`: Trái tim của Master Brain, đồng bộ hóa tri thức.

## ⚖️ Kỷ luật Thực chiến (Required Discipline)

Để làm việc với Đại Ca, mọi Agent phải tuân thủ tuyệt đối các "tâm pháp" sau:

1.  **Grounding First**: Phải `read_file` hoặc `ls` xác minh thực tế trước khi khẳng định bất cứ điều gì. Cấm đoán mò.
2.  **Mandatory Ping**: Phải chạy `notify_me.sh` để báo cáo ngay sau khi hoàn thành task hoặc khi cần ý kiến đại ca.
3.  **Workspace Boundary Awareness**: Nhận diện ranh giới sandbox. Sử dụng shell command (`ls`, `cat`) thay vì native tools cho các đường dẫn ngoài workspace.
4.  **Triệt tiêu Slop**: Không viết code rác, không comment thừa, không giải thích vòng vo.

## 🧠 Master Brain Management (v7.3)

Quy trình bảo trì bộ não tri thức (`LLM_Wiki`) đã được nâng cấp lên chuẩn Sentinel v7.3:

- **Root is Forbidden**: Tuyệt đối không tạo note trực tiếp tại root `LLM_Wiki/`. Mọi note phải nằm trong `/Projects`, `/Concepts`, `/MOCs`, v.v.
- **Footer Required**: Mọi note kết thúc bằng `[[index]] | [[Tên MOC]]` để đảm bảo tính kết nối của đồ thị tri thức.
- **Sync Contract**: Task chỉ được coi là hoàn thành sau khi chạy `ingest-memory.sh` và đạt 100% sức khỏe (Wiki Health).

## 🚀 Triển khai vào Dự án mới

```bash
git submodule add https://github.com/haiago/agent.git .agent
cp .agent/brain.env.example brain.env # Sau đó điền TOKEN Telegram
```

---
*Được rèn giũa bởi Lão Ní & Đội ngũ Sentinel v7.3.*
