#!/usr/bin/env bash
# SetupAgent: Khai thông kinh mạch cho Master Brain Consumer
# Refinery-v7.3 S-Tier Standard

set -euo pipefail

log_step() { echo -e "\033[0;36m$1\033[0m"; }
log_info() { echo -e "\033[0;34m$1\033[0m"; }
log_warn() { echo -e "\033[1;33m$1\033[0m"; }

PROJECT_ROOT="$(pwd)"
AGENT_DIR=".agent"

if [ ! -d "$AGENT_DIR" ]; then
    echo "❌ Không tìm thấy thư mục $AGENT_DIR. Hãy đảm bảo bạn đang đứng ở root project và đã init submodule."
    exit 1
fi

log_step "🔄 Đang khai thông kinh mạch cho project: $(basename "$PROJECT_ROOT")"

# 1. Tạo symlinks cho Gemini CLI
mkdir -p .gemini
log_info "  - Nối kinh mạch Agents..."
rm -rf .gemini/agents && ln -s ../.agent/agents .gemini/agents
log_info "  - Nối kinh mạch Skills..."
rm -rf .gemini/skills && ln -s ../.agent/skills .gemini/skills

# 2. Kiểm tra và nạp linh hồn vào GEMINI.md
GEMINI_FILE="GEMINI.md"
SOUL_IMPORTS=(
    "@.agent/rules/SHARED.md"
    "@.agent/rules/GEMINI.md"
    "@.agent/rules/PERSONALITY.md"
    "@./AGENTS.md"
)

if [ ! -f "$GEMINI_FILE" ]; then
    log_info "  - Tạo mới GEMINI.md với linh hồn v7.3..."
    printf "# 🏯 Master Brain Consumer\n\n" > "$GEMINI_FILE"
    for imp in "${SOUL_IMPORTS[@]}"; do
        echo "$imp" >> "$GEMINI_FILE"
    done
    echo -e "\n## 🚀 Project Execution Rules\n- " >> "$GEMINI_FILE"
else
    log_info "  - Kiểm tra linh hồn trong GEMINI.md hiện tại..."
    # Tạo file tạm để build header mới
    TEMP_HEADER=$(mktemp)
    printf "# 🏯 Master Brain Consumer\n\n" > "$TEMP_HEADER"
    
    # Nạp các import bắt buộc
    for imp in "${SOUL_IMPORTS[@]}"; do
        echo "$imp" >> "$TEMP_HEADER"
    done
    
    # Lấy nội dung cũ (bỏ qua header cũ và các dòng @ tương tự để tránh trùng)
    grep -v "^# " "$GEMINI_FILE" | grep -v "^@" | grep -v "^[[:space:]]*$" >> "$TEMP_HEADER" || true
    
    # Ghi đè lại file chính
    mv "$TEMP_HEADER" "$GEMINI_FILE"
    log_info "  - Đã cập nhật và sắp xếp lại linh hồn trong GEMINI.md"
fi

log_step "✅ Xong! Linh hồn S-Tier đã nhập xác. Múa lửa thôi ní! 🏮🔥🍻"
