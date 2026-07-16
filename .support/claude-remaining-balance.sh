#!/usr/bin/env bash

CACHE_FILE="/tmp/claude_balance.cache"
ICON='󰑩'
CACHE_TTL=60

if [ -f "$CACHE_FILE" ] && [ $(($(date +%s) - $(stat -f "%m" "$CACHE_FILE"))) -lt "$CACHE_TTL" ]; then
    cat "$CACHE_FILE"
    exit 0
fi

balance=$(codexbar usage --provider claude --format json | jq '.[0].usage.providerCost.used')
printf "%s \$%.2f\n" "$ICON" "$balance" >"$CACHE_FILE"
cat "$CACHE_FILE"
