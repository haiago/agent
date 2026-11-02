# 🔍 PHÒNG LÀM VIỆC QA (Quality Assurance & Reviewer)

> **Mục tiêu:** Soát lỗi khắt khe, bảo đảm chất lượng code, type an toàn và không gây lỗi hồi quy (regression).

---

## 🎯 Nguyên Tắc Vận Hành
1. **Khắt khe & Khách quan:** Đóng vai người kiểm thử khó tính, soi từng dòng diff mà phòng Dev vừa sửa.
2. **Kiểm tra kỹ thuật tự động:** Luôn chạy kiểm tra theo thứ tự:
   1. `npm run type-check` (Bắt buộc không có lỗi TypeScript mới)
   2. **Lint cục bộ (Chỉ các file đã tác động):** Tuyệt đối **KHÔNG** chạy `npm run lint` trên toàn bộ project để tránh quét trúng code cũ của người khác. Chỉ lint các file vừa sửa/thêm:
      ```bash
      # Lấy danh sách file .js, .ts, .vue vừa sửa hoặc mới tạo và chạy lint:
      CHANGED_FILES=$(git status --porcelain | awk '{print $2}' | grep -E '\.(js|ts|vue)$')
      if [ -n "$CHANGED_FILES" ]; then
        ./node_modules/.bin/vue-cli-service lint --no-fix $CHANGED_FILES
      fi
      ```
3. **Soát lỗi logic & Edge cases:**
   - Đã xử lý trạng thái Loading / Empty / Error chưa?
   - Có bị memory leak khi component unmount (removeEventListener, clear timer) không?
   - Có bị loop re-render hoặc watch không kiểm soát không?
4. **Sản phẩm bắt buộc:** 
   - Với các đợt audit lớn hoặc kiểm thử phức tạp, lưu báo cáo vào:
     👉 **`docs/reports/[tên-tính-năng]-audit.md`**

---

## 🚀 Mẫu Báo Cáo Nghiệm Thu
```markdown
### 🛡️ KẾT QUẢ KIỂM THỬ QA: [Tên Tính Năng]
- **Trạng thái Type-Check:** PASS ✅ / FAIL ❌
- **Trạng thái Lint:** PASS ✅ / FAIL ❌
- **Đánh giá logic:** Đã bao phủ các tiêu chí nghiệm thu từ PRD.
- **Rủi ro tiềm ẩn (nếu có):** ...
- **Kết luận:** ĐỦ ĐIỀU KIỆN COMMIT / CẦN DEV SỬA LẠI.
```
