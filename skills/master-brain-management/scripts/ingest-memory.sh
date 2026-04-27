#!/bin/bash

set -euo pipefail

# =================================================================
# Master Brain ingest pipeline
# - Portable path resolution for shared submodule usage
# - Stable public outputs: LLM_Wiki/index.md + Wiki Health MOC.md
# - Stronger health checks without breaking existing note layouts
# =================================================================

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DEFAULT_BRAIN_ROOT="$(cd "$SCRIPT_DIR/../../../.." && pwd)"

MASTER_BRAIN_ROOT="${MASTER_BRAIN_ROOT:-$DEFAULT_BRAIN_ROOT}"
MASTER_BRAIN_WIKI_DIR="${MASTER_BRAIN_WIKI_DIR:-$MASTER_BRAIN_ROOT/LLM_Wiki}"
MASTER_BRAIN_RAW_DIR="${MASTER_BRAIN_RAW_DIR:-$MASTER_BRAIN_ROOT/raw}"
MASTER_BRAIN_VERSION_FILE="${MASTER_BRAIN_VERSION_FILE:-$MASTER_BRAIN_ROOT/.agent/VERSION}"
MASTER_BRAIN_STRICT_SUMMARY="${MASTER_BRAIN_STRICT_SUMMARY:-1}"
MASTER_BRAIN_IGNORE_DRAFT_LINKS="${MASTER_BRAIN_IGNORE_DRAFT_LINKS:-1}"
MASTER_BRAIN_ATOMIC_LINE_LIMIT="${MASTER_BRAIN_ATOMIC_LINE_LIMIT:-100}"

RAW_DIR="$MASTER_BRAIN_RAW_DIR"
WIKI_DIR="$MASTER_BRAIN_WIKI_DIR"
MOC_DIR="$WIKI_DIR/MOCs"
INDEX_FILE="$WIKI_DIR/index.md"
HEALTH_FILE="$MOC_DIR/Wiki Health MOC.md"
VERSION_FILE="$MASTER_BRAIN_VERSION_FILE"
CURRENT_VERSION="$(cat "$VERSION_FILE")"
export CURRENT_VERSION

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m'

log_info() {
    echo -e "${BLUE}$1${NC}"
}

log_step() {
    echo -e "${CYAN}$1${NC}"
}

log_warn() {
    echo -e "${YELLOW}$1${NC}"
}

log_error() {
    echo -e "${RED}$1${NC}"
}

frontmatter_value() {
    local file="$1"
    local key="$2"
    awk -v key="$key" '
        BEGIN { in_fm = 0; started = 0 }
        NR == 1 && $0 == "---" { in_fm = 1; started = 1; next }
        started && in_fm && $0 == "---" { exit }
        in_fm && index($0, key ":") == 1 {
            value = substr($0, length(key) + 2)
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", value)
            print value
            exit
        }
    ' "$file"
}

body_summary() {
    local file="$1"
    awk '
        BEGIN { in_fm = 0; started = 0 }
        NR == 1 && $0 == "---" { in_fm = 1; started = 1; next }
        started && in_fm && $0 == "---" { in_fm = 0; next }
        in_fm { next }
        /^#/ { next }
        /^\[\[/ { next }
        /^---$/ { next }
        /^[[:space:]]*$/ { next }
        {
            line = $0
            gsub(/^[[:space:]]+|[[:space:]]+$/, "", line)
            print substr(line, 1, 140)
            exit
        }
    ' "$file"
}

note_summary() {
    local file="$1"
    local summary

    summary="$(frontmatter_value "$file" "summary" || true)"
    if [ -n "$summary" ]; then
        printf '%s\n' "$summary"
        return
    fi

    body_summary "$file"
}

has_summary() {
    local file="$1"
    [ -n "$(frontmatter_value "$file" "summary" || true)" ]
}

note_status() {
    local file="$1"
    frontmatter_value "$file" "status" || true
}

safe_replace_version() {
    local file="$1"
    [ -f "$file" ] || return 0
    perl -0pi -e 's/(?:Refinery-)?v6\.\d+/$ENV{CURRENT_VERSION}/g' "$file"
}

note_exists() {
    local link_target="$1"

    if [[ "$link_target" == */* ]]; then
        [ -f "$WIKI_DIR/$link_target.md" ] && return 0
    fi

    [ -f "$WIKI_DIR/Concepts/$link_target.md" ] && return 0
    [ -f "$WIKI_DIR/Tools/$link_target.md" ] && return 0
    [ -f "$WIKI_DIR/Projects/$link_target.md" ] && return 0
    [ -f "$WIKI_DIR/MOCs/$link_target.md" ] && return 0
    [ -f "$WIKI_DIR/$link_target.md" ] && return 0

    return 1
}

should_ignore_link() {
    local link_target="$1"
    local source_line="$2"

    [[ "$link_target" == *"liên quan"* ]] && return 0
    [[ "$link_target" == *"cha"* ]] && return 0

    if [ "$MASTER_BRAIN_IGNORE_DRAFT_LINKS" = "1" ]; then
        [[ "$source_line" == *"Pending Harvest"* ]] && return 0
        [[ "$source_line" == *"Draft"* ]] && return 0
        [[ "$source_line" == *"Planned"* ]] && return 0
        [[ "$source_line" == *"TBD"* ]] && return 0
    fi

    return 1
}

project_note_link_target() {
    local note="$1"
    local basename="$2"

    case "$note" in
        "$WIKI_DIR/Concepts/"*)
            printf '[[%s MOC]]' "$basename"
            ;;
        "$WIKI_DIR/Tools/"*)
            printf '[[Master Brain MOC]]'
            ;;
        "$WIKI_DIR/Projects/"*)
            printf '[[Projects MOC]]'
            ;;
        *)
            printf 'Chưa rõ'
            ;;
    esac
}

log_info "🏮 Khởi động Master Brain ingest $CURRENT_VERSION"
log_step "Root: $MASTER_BRAIN_ROOT"
log_step "Wiki: $WIKI_DIR"
log_step "Raw:  $RAW_DIR"

if [ ! -d "$WIKI_DIR" ] || [ ! -d "$MOC_DIR" ]; then
    log_error "❌ Không tìm thấy thư mục wiki hoặc MOC. Kiểm tra MASTER_BRAIN_ROOT / MASTER_BRAIN_WIKI_DIR."
    exit 1
fi

log_step "🔄 Đồng bộ version string trong các tài liệu điều phối..."
files_to_sync=(
    "$MASTER_BRAIN_ROOT/GEMINI.md"
    "$MASTER_BRAIN_ROOT/README.md"
    "$MASTER_BRAIN_ROOT/.agent/rules/GEMINI.md"
    "$MASTER_BRAIN_ROOT/.agent/skills/master-brain-management/SKILL.md"
    "$WIKI_DIR/Concepts/LLM Wiki.md"
    "$WIKI_DIR/Concepts/Master Brain Sharing Guide.md"
    "$WIKI_DIR/MOCs/Master Brain MOC.md"
    "$WIKI_DIR/MOCs/Projects MOC.md"
)

for file in "${files_to_sync[@]}"; do
    safe_replace_version "$file"
done

cat > "$HEALTH_FILE" <<EOF
---
tags: [moc, maintenance, health]
summary: "Báo cáo chi tiết sức khỏe mạng lưới tri thức $CURRENT_VERSION."
---

# 🏥 Wiki Health MOC

> [!INFO] Cập nhật lần cuối: $(date +'%Y-%m-%d %H:%M:%S')

## 📋 Danh sách Cần chữa lành
| Loại lỗi | Note | Chi tiết / Gợi ý |
| :--- | :--- | :--- |
EOF

TEMP_INDEX="$(mktemp)"
cat > "$TEMP_INDEX" <<EOF
---
tags: [moc, home, router, healer]
---

# 🏮 Master Brain: Router Index

## 🗺️ Bản đồ Tri thức (MOCs)
EOF

while read -r moc_file; do
    moc_name="$(basename "$moc_file" .md)"
    moc_summary="$(note_summary "$moc_file")"
    echo "- [[${moc_name}]]: ${moc_summary:-Bản đồ tri thức tổng hợp.}" >> "$TEMP_INDEX"
done < <(find "$MOC_DIR" -type f -name "*.md" | sort)

echo "" >> "$TEMP_INDEX"
echo "## 🚀 Danh mục Định tuyến (All Notes)" >> "$TEMP_INDEX"

MOC_MISSING_COUNT=0
BROKEN_LINK_COUNT=0
LONG_NOTE_COUNT=0
MISSING_SUMMARY_COUNT=0
TOTAL_NOTES=0

log_step "🩺 Đang chẩn đoán mạng lưới tri thức..."

while read -r note; do
    filename="$(basename "$note")"
    basename="${filename%.md}"
    TOTAL_NOTES=$((TOTAL_NOTES + 1))

    summary="$(note_summary "$note")"
    echo "- [[${basename}]]: ${summary:-Chưa có tóm tắt.}" >> "$TEMP_INDEX"

    if [ "$MASTER_BRAIN_STRICT_SUMMARY" = "1" ] && ! has_summary "$note"; then
        echo "| 📝 Missing Summary | [[${basename}]] | Thêm frontmatter \`summary:\` để tăng chất lượng router index |" >> "$HEALTH_FILE"
        MISSING_SUMMARY_COUNT=$((MISSING_SUMMARY_COUNT + 1))
    fi

    note_lines="$(wc -l < "$note" | tr -d ' ')"
    status="$(note_status "$note")"
    if [ "$note_lines" -gt "$MASTER_BRAIN_ATOMIC_LINE_LIMIT" ] && [ "$status" != "reference" ] && [ "$status" != "archived" ]; then
        echo "| ✂️ Atomic Too Long | [[${basename}]] | ${note_lines} dòng > giới hạn ${MASTER_BRAIN_ATOMIC_LINE_LIMIT} |" >> "$HEALTH_FILE"
        LONG_NOTE_COUNT=$((LONG_NOTE_COUNT + 1))
    fi

        if [ "$is_in_moc" -eq 0 ]; then
            suggested_moc="$(project_note_link_target "$note" "$basename")"
            echo "| 🏠 MOC Missing | [[${basename}]] | Gợi ý: ${suggested_moc} |" >> "$HEALTH_FILE"
            MOC_MISSING_COUNT=$((MOC_MISSING_COUNT + 1))
        fi
    fi

    # [NEW] Kiểm tra Tag Mandatory cho MOCs
    if [[ "$note" == *"/MOCs/"* ]]; then
        tags="$(frontmatter_value "$note" "tags" || true)"
        if [[ "$tags" != *"moc"* ]]; then
            echo "| 🏷️ Missing Tag | [[${basename}]] | Thiếu tag \`#moc\` bắt buộc cho MOC |" >> "$HEALTH_FILE"
        fi
        if [[ "$basename" == *"MOC"* ]] && [[ "$basename" != "Master Brain MOC" ]] && [[ "$basename" != "Projects MOC" ]]; then
             if [[ "$tags" != *"projects"* ]]; then
                echo "| 🏷️ Missing Tag | [[${basename}]] | Thiếu tag \`#projects\` cho Project MOC |" >> "$HEALTH_FILE"
             fi
        fi
    fi

    inside_code=0
    while IFS= read -r line || [ -n "$line" ]; do
        if [[ "$line" == *'```'* ]]; then
            if [ "$inside_code" -eq 0 ]; then
                inside_code=1
            else
                inside_code=0
            fi
            continue
        fi

        [ "$inside_code" -eq 1 ] && continue

        while [[ "$line" =~ \[\[([^]]+)\]\] ]]; do
            raw_link="${BASH_REMATCH[1]}"
            link_target="${raw_link%%|*}"

            if should_ignore_link "$link_target" "$line"; then
                line="${line#*"[[${raw_link}]]"}"
                continue
            fi

            if ! note_exists "$link_target"; then
                echo "| 🔗 Broken Link | [[${basename}]] | Đích đến: [[${link_target}]] không tồn tại |" >> "$HEALTH_FILE"
                BROKEN_LINK_COUNT=$((BROKEN_LINK_COUNT + 1))
            fi

            line="${line#*"[[${raw_link}]]"}"
        done
    done < "$note"
done < <(find "$WIKI_DIR" -type f -name "*.md" ! -name "index.md" ! -path "*/.*" ! -path "*/MOCs/*" | sort)

mv "$TEMP_INDEX" "$INDEX_FILE"

cat >> "$HEALTH_FILE" <<EOF

## 📊 Thống kê Sức khỏe
- **Tổng số note đã quét**: $TOTAL_NOTES
- **Thiếu MOC**: $MOC_MISSING_COUNT
- **Thiếu Summary**: $MISSING_SUMMARY_COUNT
- **Link gãy**: $BROKEN_LINK_COUNT
- **Vi phạm Atomic**: $LONG_NOTE_COUNT
EOF

echo "---------------------------------------------------------------"
log_info "✅ Hoàn tất. Kiểm tra [[index]] và [[Wiki Health MOC]]."
