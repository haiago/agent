---
name: master-brain-management
description: Quy trình và công cụ để quản lý bộ não trung tâm (Master Brain), luyện hóa tri thức thô thành tinh hoa.
---

# Master Brain Management Skill

Skill này định nghĩa cách thức Agent tương tác với hệ thống MyBrain để duy trì và phát triển kho tri thức cá nhân (LLM Wiki).

## 🧩 Cấu Trúc Hệ Thống
- `/raw`: Nơi chứa tài liệu nguồn chưa qua xử lý.
- `/LLM_Wiki`: Obsidian Vault chứa tri thức đã được luyện hóa (Summary, Concepts).
- `.agent/skills`: Nơi lưu trữ các kỹ năng của bộ não.

## 🛠️ Công Cụ Hỗ Trợ
- `scripts/ingest-memory.sh`: Script v5.1 tự động hóa việc kiểm tra, tóm tắt và cập nhật mục lục/nhật ký.

## 🔄 Quy Trình Ingest 5 Bước (MANDATORY)
Mỗi khi có dữ liệu mới trong `/raw`, Agent phải tuân thủ:

1. **Research**: Sử dụng `ls` và `cat` để đọc hiểu tài liệu nguồn trong `/raw`.
2. **Brainstorm**: (Sử dụng skill `brainstorming`) Để trích xuất các keyword, khái niệm và góc nhìn giá trị.
3. **Plan**: (Sử dụng skill `writing-plans`) Lên danh sách các file Summary và Concept cần tạo/cập nhật.
4. **Execute**: 
   - Viết Summary theo chuẩn: `Summary - [Project] - [Filename]`.
   - Gắn thẻ Project: `#ProjectName`.
   - Tạo liên kết Wiki: `[[SourceFile]]`.
5. **Log & Index**: Chạy script `ingest-memory.sh` để đồng bộ hóa nhật ký và mục lục.

## ⚠️ Nguyên Tắc Luyện Não (Anti-Slop)
- **Không tóm tắt hời hợt**: Phải trích xuất được giá trị kỹ thuật hoặc tư duy thực tế.
- **Tính nhất quán**: Luôn kiểm tra `index.md` và `log.md` để tránh trùng lặp.
- **Bảo mật**: Không đưa thông tin nhạy cảm (API Key, Secret) vào `/LLM_Wiki`.

## 🚀 Kích Hoạt
Sử dụng skill này khi:
- Cần dọn dẹp hoặc tổ chức lại kho tri thức.
- Có tài liệu mới cần "luyện hóa".
- Cần tra cứu tri thức tổng quát từ nhiều dự án khác nhau.
