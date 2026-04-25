#!/bin/bash

# =================================================================
# 🏮 Lò luyện Tri thức v6.2 - "Sentinel Edition"
# Điều phối, Bảo trì mạng lưới và Kiểm toán MOC (Map of Content)
# =================================================================

RAW_DIR="/Users/ha/Project/MyBrain/raw"
WIKI_DIR="/Users/ha/Project/MyBrain/LLM_Wiki"
MOC_DIR="$WIKI_DIR/MOCs"
LOG_FILE="$WIKI_DIR/Knowledge Pulse.md"
INDEX_FILE="$WIKI_DIR/index.md"

# Màu sắc
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}🏮 [Lão Ní] Khởi động Lò luyện v6.2 (Sentinel Edition)...${NC}"

ORPHAN_COUNT=0
MOC_MISSING_COUNT=0
BROKEN_LINK_COUNT=0
LONG_NOTE_COUNT=0

# --- 1. ROUTER INDEX PREPARATION ---
TEMP_INDEX=$(mktemp)
echo "---" > "$TEMP_INDEX"
echo "tags: [moc, home, router, sentinel]" >> "$TEMP_INDEX"
echo "---" >> "$TEMP_INDEX"
echo -e "\n# 🏮 Master Brain: Router Index" >> "$TEMP_INDEX"
echo -e "\n## 🗺️ Bản đồ Tri thức (MOCs)" >> "$TEMP_INDEX"

find "$MOC_DIR" -type f -name "*.md" | sort | while read -r moc_file; do
    moc_name=$(basename "$moc_file" .md)
    moc_summary=$(grep -m 1 "^summary:" "$moc_file" | sed 's/summary: //')
    if [ -z "$moc_summary" ]; then
        moc_summary=$(grep -v "^---" "$moc_file" | grep -v "^#" | grep -v "^$" | head -n 1 | cut -c 1-100)
    fi
    echo "- [[$moc_name]]: ${moc_summary:-"Bản đồ tri thức tổng hợp."}" >> "$TEMP_INDEX"
done

echo -e "\n## 🚀 Danh mục Định tuyến (All Notes)" >> "$TEMP_INDEX"

# --- 2. SENTINEL AUDIT (Quét mạng lưới) ---
echo -e "${PURPLE}🛡️ Sentinel đang tuần tra mạng lưới...${NC}"

find "$WIKI_DIR" -type f -name "*.md" ! -name "index.md" ! -name "Knowledge Pulse.md" ! -path "*/.*" | sort | while read -r note; do
    filename=$(basename "$note")
    basename="${filename%.md}"
    
    # a. Router Summary Update
    summary=$(grep -m 1 "^summary:" "$note" | sed 's/summary: //')
    if [ -z "$summary" ]; then
        summary=$(grep -v "^---" "$note" | grep -v "^#" | grep -v "^$" | head -n 1 | cut -c 1-100)
    fi
    echo "- [[$basename]]: ${summary:-"Chưa có tóm tắt."}" >> "$TEMP_INDEX"
    
    # b. Topic MOC Audit (Note có nằm trong MOC nào không?)
    if [[ "$note" != *"/MOCs/"* ]]; then
        is_in_moc=$(grep -rl "\[\[$basename" "$MOC_DIR" | wc -l)
        if [ "$is_in_moc" -eq 0 ]; then
            echo -e "${RED}⚠️  MOC MISSING:${NC} $basename (Chưa đăng ký vào Topic MOC)"
            MOC_MISSING_COUNT=$((MOC_MISSING_COUNT + 1))
        fi
    fi
    
    # c. Broken Link Detection
    # Tìm các [[Link]] nhưng file đích không tồn tại
    grep -o "\[\[[^]]*\]\]" "$note" | sed 's/\[\[//;s/\]\]//' | while read -r link; do
        # Xử lý alias [[link|alias]]
        link_target=$(echo "$link" | cut -d'|' -f1)
        if [ ! -f "$WIKI_DIR/Concepts/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/Tools/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/Projects/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/MOCs/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/$link_target.md" ]; then
            echo -e "${YELLOW}🚫 BROKEN LINK:${NC} In $basename -> [[$link_target]]"
            BROKEN_LINK_COUNT=$((BROKEN_LINK_COUNT + 1))
        fi
    done
    
    # d. Atomic Check
    line_count=$(wc -l < "$note")
    if [ "$line_count" -gt 100 ]; then
        echo -e "${RED}📏 VI PHẠM ATOMIC:${NC} $basename ($line_count dòng)"
        LONG_NOTE_COUNT=$((LONG_NOTE_COUNT + 1))
    fi
done

mv "$TEMP_INDEX" "$INDEX_FILE"

# --- 3. LOGGING ---
echo -e "\n[$(date +'%Y-%m-%d %H:%M:%S')] Sentinel v6.2: $MOC_MISSING_COUNT thiếu MOC, $BROKEN_LINK_COUNT link gãy, $LONG_NOTE_COUNT quá dài." >> "$LOG_FILE"

echo "---------------------------------------------------------------"
echo -e "${GREEN}✅ Tuần tra hoàn tất!${NC}"
if [ $MOC_MISSING_COUNT -gt 0 ]; then
    echo -e "${CYAN}👉 Đại ca ơi, có $MOC_MISSING_COUNT note đang 'vô gia cư', nhét chúng vào MOC đi!${NC}"
fi
