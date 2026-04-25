#!/bin/bash

# Lò luyện Tri thức v5.1 - "Lão Ní Edition"
# Tự động hóa việc kiểm tra và quản lý Summary trong LLM_Wiki

RAW_DIR="/Users/ha/Project/MyBrain/raw"
WIKI_DIR="/Users/ha/Project/MyBrain/LLM_Wiki"
LOG_FILE="$WIKI_DIR/log.md"
INDEX_FILE="$WIKI_DIR/index.md"

# Màu sắc cho nó rực rỡ
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 [Lão Ní] Đang khởi động Lò luyện Tri thức...${NC}"

NEW_FILES=0

# Tìm tất cả file trong raw (trừ thư mục .git và .agent)
find "$RAW_DIR" -type f \( -name "*.md" -o -name "*.txt" -o -name "*.pdf" \) \
    ! -path "*/.*" | while read -r file; do
    
    filename=$(basename "$file")
    rel_path=${file#$RAW_DIR/}
    basename="${filename%.*}"
    
    # Lấy tên dự án từ thư mục cha
    project_name=$(basename "$(dirname "$file")")
    if [ "$project_name" == "raw" ]; then
        project_name="General"
    fi
    
    summary_filename="Summary - $project_name - $basename.md"
    
    # Kiểm tra xem đã có bản tóm tắt chưa
    if [ ! -f "$WIKI_DIR/$summary_filename" ]; then
        echo -e "${RED}🚨 THIẾU TÓM TẮT:${NC} [$project_name] $rel_path"
        echo -e "   ${YELLOW}-> Cần tạo:${NC} $WIKI_DIR/$summary_filename"
        NEW_FILES=$((NEW_FILES + 1))
    else
        # Nếu đã có summary, cập nhật Index nếu chưa có
        if ! grep -q "$summary_filename" "$INDEX_FILE"; then
            echo -e "${GREEN}✨ Đang thêm vào Mục lục:${NC} $summary_filename"
            echo "  - [[$summary_filename]]" >> "$INDEX_FILE"
        fi
    fi
done

echo "-----------------------------------------------"
if [ $NEW_FILES -eq 0 ]; then
    echo -e "${GREEN}✅ CHÚC MỪNG ĐẠI CA! Mọi kiến thức đã được luyện hóa mướt rượt!${NC}"
else
    echo -e "${YELLOW}⚠️ CẢNH BÁO:${NC} Còn ${RED}$NEW_FILES${NC} file chưa được tóm tắt."
    echo -e "${BLUE}👉 Hãy bảo Agent: \"Luyện hóa đống file còn thiếu đi ní!\"${NC}"
fi
