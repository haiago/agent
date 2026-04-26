#!/bin/bash

# =================================================================
# 🏮 Lò luyện Tri thức v6.5 - "Automator Edition"
# Điều phối, Bảo trì và Tự động đồng bộ Phiên bản (Global Version Sync)
# =================================================================

RAW_DIR="/Users/ha/Project/MyBrain/raw"
WIKI_DIR="/Users/ha/Project/MyBrain/LLM_Wiki"
MOC_DIR="$WIKI_DIR/MOCs"
INDEX_FILE="$WIKI_DIR/index.md"
HEALTH_FILE="$WIKI_DIR/MOCs/Wiki Health MOC.md"
VERSION_FILE="/Users/ha/Project/MyBrain/.agent/VERSION"
CURRENT_VERSION=$(cat "$VERSION_FILE")

# Màu sắc
GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

echo -e "${BLUE}🏮 [Lão Ní] Khởi động Lò luyện $CURRENT_VERSION (Automator Edition)...${NC}"

# --- 0. GLOBAL VERSION SYNC (Tự động đồng bộ phiên bản) ---
echo -e "${CYAN}🔄 Đang đồng bộ phiên bản $CURRENT_VERSION toàn hệ thống...${NC}"
# Quét và thay thế các chuỗi version cũ (v6.X hoặc Refinery-v6.X) bằng phiên bản hiện tại
files_to_sync=("$WIKI_DIR/Concepts/LLM Wiki.md" "$WIKI_DIR/MOCs/Master Brain MOC.md" "/Users/ha/Project/MyBrain/GEMINI.md" "/Users/ha/Project/MyBrain/.agent/skills/master-brain-management/SKILL.md")

for file in "${files_to_sync[@]}"; do
    if [ -f "$file" ]; then
        # Sử dụng sed để thay thế linh hoạt các pattern version cũ sang Refinery-v6.5
        sed -i '' "s/\(Refinery-\)\{0,1\}v6\.[0-9]/$CURRENT_VERSION/g" "$file"
    fi
done

# Khởi tạo Dashboard Sức khỏe
echo "---" > "$HEALTH_FILE"
echo "tags: [moc, maintenance, health]" >> "$HEALTH_FILE"
echo "summary: \"Báo cáo chi tiết sức khỏe mạng lưới tri thức v6.3.\"" >> "$HEALTH_FILE"
echo "---" >> "$HEALTH_FILE"
echo -e "\n# 🏥 Wiki Health MOC" >> "$HEALTH_FILE"
echo -e "\n> [!INFO] Cập nhật lần cuối: $(date +'%Y-%m-%d %H:%M:%S')" >> "$HEALTH_FILE"

ORPHAN_COUNT=0
MOC_MISSING_COUNT=0
BROKEN_LINK_COUNT=0
LONG_NOTE_COUNT=0

# --- 1. ROUTER INDEX PREPARATION ---
TEMP_INDEX=$(mktemp)
echo "---" > "$TEMP_INDEX"
echo "tags: [moc, home, router, healer]" >> "$TEMP_INDEX"
echo "---" >> "$TEMP_INDEX"
echo -e "\n# 🏮 Master Brain: Router Index" >> "$TEMP_INDEX"
echo -e "\n## 🗺️ Bản đồ Tri thức (MOCs)" >> "$TEMP_INDEX"

find "$MOC_DIR" -type f -name "*.md" | sort | while read -r moc_file; do
    moc_name=$(basename "$moc_file" .md)
    moc_summary=$(grep -m 1 "^summary:" "$moc_file" | sed 's/summary: //')
    echo "- [[$moc_name]]: ${moc_summary:-"Bản đồ tri thức tổng hợp."}" >> "$TEMP_INDEX"
done

echo -e "\n## 🚀 Danh mục Định tuyến (All Notes)" >> "$TEMP_INDEX"

# --- 2. HEALER AUDIT ---
echo -e "${PURPLE}🩺 Healer đang chẩn đoán mạng lưới...${NC}"

echo -e "\n## 📋 Danh sách Cần chữa lành" >> "$HEALTH_FILE"
echo "| Loại lỗi | Note | Chi tiết / Gợi ý |" >> "$HEALTH_FILE"
echo "| :--- | :--- | :--- |" >> "$HEALTH_FILE"

# Dùng process substitution để giữ biến không bị mất trong subshell
while read -r note; do
    filename=$(basename "$note")
    basename="${filename%.md}"
    [ "$basename" == "Wiki Health MOC" ] && continue
    
    # a. Router Summary
    summary=$(grep -m 1 "^summary:" "$note" | sed 's/summary: //')
    if [ -z "$summary" ]; then
        summary=$(grep -v "^---" "$note" | grep -v "^#" | grep -v "^$" | head -n 1 | cut -c 1-100)
    fi
    echo "- [[$basename]]: ${summary:-"Chưa có tóm tắt."}" >> "$TEMP_INDEX"
    
    # b. MOC Missing & Smart Suggest
    if [[ "$note" != *"/MOCs/"* ]]; then
        is_in_moc=$(grep -rl "\[\[$basename" "$MOC_DIR" | wc -l)
        if [ "$is_in_moc" -eq 0 ]; then
            # Gợi ý động: So khớp từng tag của note với tên các file MOC hiện có
            suggested_moc="Chưa rõ"
            # Lấy danh sách tags, bỏ dấu phẩy và ngoặc vuông, chuyển thành mảng
            tags_list=$(grep "tags:" "$note" | sed 's/tags: //' | tr -d '[],' | tr '[:upper:]' '[:lower:]')
            
            for tag in $tags_list; do
                # Tìm file MOC nào có tên chứa cái tag này (không phân biệt hoa thường)
                moc_match=$(find "$MOC_DIR" -type f -iname "*$tag*MOC.md" | head -n 1)
                if [ -n "$moc_match" ]; then
                    suggested_moc="[$(basename "$moc_match" .md)]]"
                    suggested_moc="[[${suggested_moc}" # Đảm bảo đúng định dạng [[...]]
                    suggested_moc=$(echo "$suggested_moc" | sed 's/\[\[\[/\[\[/') # Sửa lỗi ngoặc dư
                    break
                fi
            done
            
            echo -e "${RED}⚠️  MOC MISSING:${NC} $basename -> Suggest: $suggested_moc"
            echo "| 🏠 MOC Missing | [[$basename]] | Gợi ý: $suggested_moc |" >> "$HEALTH_FILE"
            MOC_MISSING_COUNT=$((MOC_MISSING_COUNT + 1))
        fi
    fi
    
    # c. Broken Link with Code Immunity
    clean_content=$(sed '/```/,/```/d' "$note")
    while read -r link; do
        link_target=$(echo "$link" | cut -d'|' -f1)
        [[ "$link_target" == *"liên quan"* ]] || [[ "$link_target" == *"cha"* ]] && continue
        
        if [ ! -f "$WIKI_DIR/Concepts/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/Tools/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/Projects/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/MOCs/$link_target.md" ] && \
           [ ! -f "$WIKI_DIR/$link_target.md" ]; then
            echo -e "${YELLOW}🚫 BROKEN LINK:${NC} $basename -> [[$link_target]]"
            echo "| 🔗 Broken Link | [[$basename]] | Đích đến: [[$link_target]] không tồn tại |" >> "$HEALTH_FILE"
            BROKEN_LINK_COUNT=$((BROKEN_LINK_COUNT + 1))
        fi
    done < <(echo "$clean_content" | grep -o "\[\[[^]]*\]\]" | sed 's/\[\[//;s/\]\]//')

done < <(find "$WIKI_DIR" -type f -name "*.md" ! -name "index.md" ! -path "*/.*" | sort)

mv "$TEMP_INDEX" "$INDEX_FILE"

echo -e "\n## 📊 Thống kê Sức khỏe" >> "$HEALTH_FILE"
echo "- **Thiếu MOC**: $MOC_MISSING_COUNT" >> "$HEALTH_FILE"
echo "- **Link gãy**: $BROKEN_LINK_COUNT" >> "$HEALTH_FILE"
echo "- **Vi phạm Atomic**: $LONG_NOTE_COUNT" >> "$HEALTH_FILE"

echo "---------------------------------------------------------------"
echo -e "${GREEN}✅ Chẩn đoán xong! Dashboard đã sẵn sàng tại [[Wiki Health MOC]].${NC}"
