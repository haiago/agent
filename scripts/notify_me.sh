#!/bin/bash
# Lão Ní's Notification Script 🏮

# Xác định đường dẫn file brain.env một cách an toàn (tính từ vị trí script đang nằm)
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENV_FILE="$SCRIPT_DIR/../../brain.env"

# Parse brain.env — hỗ trợ cả KEY=value và KEY="value" và export KEY=value
TELEGRAM_BOT_TOKEN=$(grep -E "^(export )?TELEGRAM_BOT_TOKEN=" "$ENV_FILE" 2>/dev/null | cut -d'=' -f2- | tr -d '"')
TELEGRAM_CHAT_ID=$(grep -E "^(export )?TELEGRAM_CHAT_ID=" "$ENV_FILE" 2>/dev/null | cut -d'=' -f2- | tr -d '"')

# Debug: uncomment nếu cần kiểm tra
# echo "TOKEN: '$TELEGRAM_BOT_TOKEN'"
# echo "CHAT_ID: '$TELEGRAM_CHAT_ID'"

MESSAGE="$1"
if [ -z "$MESSAGE" ]; then
    MESSAGE="✅ Task xong rồi đại ca ơi!"
fi

if [ -z "$TELEGRAM_BOT_TOKEN" ] || [ -z "$TELEGRAM_CHAT_ID" ]; then
    echo "❌ Lỗi: Không lấy được TOKEN hoặc ID từ brain.env"
    exit 1
fi

RESPONSE=$(curl -s -X POST "https://api.telegram.org/bot${TELEGRAM_BOT_TOKEN}/sendMessage" \
    --data-urlencode "chat_id=${TELEGRAM_CHAT_ID}" \
    --data-urlencode "text=${MESSAGE}")

if echo "$RESPONSE" | grep -q '"ok":true'; then
    echo "🔔 Đã hú đại ca thành công!"
else
    echo "❌ Hú đại ca thất bại. Chi tiết lỗi:"
    echo "$RESPONSE"
fi