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
    
    # Check if a summary exists in LLM_Wiki
    if [ ! -f "$WIKI_DIR/Summary - $basename.md" ]; then
        echo "📂 Phát hiện kiến thức mới: $rel_path"
        NEW_FILES=$((NEW_FILES + 1))
        # Thông báo để Agent/Con người xử lý
        echo "INGEST_REQUIRED: $file"
    fi
done

echo "✅ Quy trình kiểm tra hoàn tất."
