#!/bin/bash

# =================================================================
# 🏮 Lò luyện Tri thức v6.1 - "Karpathy Edition"
# Điều phối, kiểm tra và tự động cập nhật Router Index (1-line summaries)
# =================================================================

RAW_DIR="/Users/ha/Project/MyBrain/raw"
WIKI_DIR="/Users/ha/Project/MyBrain/LLM_Wiki"
LOG_FILE="$WIKI_DIR/Knowledge Pulse.md"
INDEX_FILE="$WIKI_DIR/index.md"

# Màu sắc
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m'

echo -e "${BLUE}🏮 [Lão Ní] Đang vận công khởi động Lò luyện v6.1 (Karpathy Edition)...${NC}"

ORPHAN_COUNT=0
LONG_NOTE_COUNT=0
RAW_UNREFINED=0

# --- 1. ROUTER INDEX PREPARATION (Khởi tạo Mục lục định tuyến) ---
TEMP_INDEX=$(mktemp)
echo "---" > "$TEMP_INDEX"
echo "tags: [moc, home, router]" >> "$TEMP_INDEX"
echo "---" >> "$TEMP_INDEX"
echo -e "\n# 🏮 Master Brain: Router Index" >> "$TEMP_INDEX"

echo -e "\n## 🗺️ Bản đồ Tri thức (MOCs)" >> "$TEMP_INDEX"
# Tự động quét mọi file trong thư mục MOCs
find "$WIKI_DIR/MOCs" -type f -name "*.md" | sort | while read -r moc_file; do
    moc_name=$(basename "$moc_file" .md)
    # Trích xuất tóm tắt của MOC
    moc_summary=$(grep -m 1 "^summary:" "$moc_file" | sed 's/summary: //')
    if [ -z "$moc_summary" ]; then
        moc_summary=$(grep -v "^---" "$moc_file" | grep -v "^#" | grep -v "^$" | head -n 1 | cut -c 1-100)
    fi
    echo "- [[$moc_name]]: ${moc_summary:-"Bản đồ tri thức tổng hợp."}" >> "$TEMP_INDEX"
done

echo -e "\n## 🚀 Danh mục Định tuyến (All Notes)" >> "$TEMP_INDEX"

# --- 2. ORE DISCOVERY & GRAPH INTEGRITY ---
echo -e "${PURPLE}🔍 Đang quét quặng và kiểm tra mạng lưới...${NC}"

# Duyệt qua tất cả các file .md trừ index, log và các file hệ thống
find "$WIKI_DIR" -type f -name "*.md" ! -name "index.md" ! -name "log.md" ! -path "*/.*" | sort | while read -r note; do
    filename=$(basename "$note")
    basename="${filename%.md}"
    rel_path=${note#$WIKI_DIR/}
    
    # a. Trích xuất tóm tắt 1 dòng (Ưu tiên frontmatter 'summary' hoặc dòng đầu tiên)
    summary=$(grep -m 1 "^summary:" "$note" | sed 's/summary: //')
    if [ -z "$summary" ]; then
        summary=$(grep -v "^---" "$note" | grep -v "^#" | grep -v "^$" | head -n 1 | cut -c 1-100)
    fi
    [ -z "$summary" ] && summary="Chưa có tóm tắt."
    
    # b. Cập nhật vào Router Index
    echo "- [[$basename]]: $summary" >> "$TEMP_INDEX"
    
    # c. Kiểm tra liên kết (Orphan Check)
    links_out=$(grep -c "\[\[" "$note")
    links_in=$(grep -rl "\[\[$basename" "$WIKI_DIR" | grep -v "$filename" | wc -l)
    if [ "$links_out" -eq 0 ] && [ "$links_in" -eq 0 ]; then
        ORPHAN_COUNT=$((ORPHAN_COUNT + 1))
    fi
    
    # d. Atomic Check
    line_count=$(wc -l < "$note")
    if [ "$line_count" -gt 100 ]; then
        LONG_NOTE_COUNT=$((LONG_NOTE_COUNT + 1))
    fi
done

# Ghi đè file Index cũ bằng bản mới đã cập nhật
mv "$TEMP_INDEX" "$INDEX_FILE"

# --- 3. LOGGING ---
echo -e "\n[$(date +'%Y-%m-%d %H:%M:%S')] Lò luyện v6.1: Cập nhật Router Index. $ORPHAN_COUNT mồ côi, $LONG_NOTE_COUNT quá dài." >> "$LOG_FILE"

echo "---------------------------------------------------------------"
echo -e "${GREEN}✅ Router Index đã được cập nhật mướt rượt!${NC}"
echo -e "${BLUE}👉 Mời đại ca check [[index.md]] để thấy sức mạnh định tuyến.${NC}"
