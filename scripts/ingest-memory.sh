#!/usr/bin/env bash
# ingest-memory.sh - Advanced Ingest Process for MyBrain
# Created by Lão Ní Senior Engineer

RAW_DIR="/Users/ha/Project/MyBrain/raw"
WIKI_DIR="/Users/ha/Project/MyBrain/LLM_Wiki"
LOG_FILE="$WIKI_DIR/log.md"

echo "🚀 Bắt đầu quy trình Ingest kiến thức mới..."

# Tìm các file trong raw chưa có bản tóm tắt tương ứng trong Wiki
NEW_FILES=0

# Xử lý cả file trong thư mục con (như WorkAI)
find "$RAW_DIR" -type f \( -name "*.md" -o -name "*.txt" \) | while read -r file; do
    filename=$(basename -- "$file")
    rel_path=${file#$RAW_DIR/}
    basename="${filename%.*}"
    
    # Get project name from parent directory
    project_name=$(basename $(dirname "$file"))
    
    # Check if a summary exists in LLM_Wiki
    summary_filename="Summary - $project_name - $basename.md"
    if [ ! -f "$WIKI_DIR/$summary_filename" ]; then
        echo "🚨 THIẾU TÓM TẮT: [$project_name] $rel_path"
        echo "   -> Cần tạo: $WIKI_DIR/$summary_filename"
        NEW_FILES=$((NEW_FILES + 1))
    else
        # Nếu đã có summary, đảm bảo nó có trong index và log (nếu chưa có)
        if ! grep -q "$summary_filename" "$WIKI_DIR/index.md"; then
            echo "  - [[$summary_filename]]" >> "$WIKI_DIR/index.md"
        fi
    fi
done

if [ $NEW_FILES -eq 0 ]; then
    echo "✅ Mọi kiến thức đã được luyện hóa mướt rượt!"
else
    echo "⚠️ Còn $NEW_FILES file chưa được tóm tắt. Đại ca bảo Agent múa đi!"
fi
