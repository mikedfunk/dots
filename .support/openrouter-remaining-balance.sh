#!/usr/bin/env bash
# vim: set fdm=marker:

CACHE_FILE="/tmp/openrouter_balance.cache"
ICON='󰑩'
CACHE_TTL=$((1 * 60)) # 5 minutes
# CACHE_TTL=0

# Check if cache exists and is fresh {{{
if [ -f "$CACHE_FILE" ]; then
    LAST_MODIFIED=$(stat -f "%m" "$CACHE_FILE") # macOS
    NOW=$(date +%s)
    AGE=$((NOW - LAST_MODIFIED))

    if [ "$AGE" -lt "$CACHE_TTL" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi
# }}}

# Fetch new balance {{{
balance=$(curl -sS -H "Authorization: Bearer $OPENROUTER_API_KEY" \
    https://openrouter.ai/api/v1/credits | jq '.data.total_credits - .data.total_usage')
balance_formatted=$(printf "%.2f" "$balance")

printf "%s $%s\n" "$ICON" "$balance_formatted" >"$CACHE_FILE"
cat "$CACHE_FILE"
# }}}
