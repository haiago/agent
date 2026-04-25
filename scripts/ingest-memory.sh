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
        echo "📂 Phát hiện kiến thức mới từ [$project_name]: $rel_path"
        NEW_FILES=$((NEW_FILES + 1))
        
        # 1. Giả lập việc tạo file summary (Agent sẽ thực hiện thực tế)
        SUMMARY_FILE="$WIKI_DIR/$summary_filename"
        echo "# Summary - $project_name - $basename" > "$SUMMARY_FILE"
        echo "Project: #$project_name" >> "$SUMMARY_FILE"
        echo "Source: [[$rel_path]]" >> "$SUMMARY_FILE"
        
        # 2. Tự động ghi Log
        echo "- [$(date +'%Y-%m-%d %H:%M')] Ingested [$project_name]: $rel_path" >> "$LOG_FILE"
        
        # 3. Tự động cập nhật Index
        echo "  - [[$summary_filename]]" >> "$WIKI_DIR/index.md"
    fi
done

echo "✅ Quy trình kiểm tra hoàn tất."
