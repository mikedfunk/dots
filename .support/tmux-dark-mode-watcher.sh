#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:$PATH"
TMUX_CONF="$HOME/.config/tmux/tmux.conf"

CURRENT_MODE=""
while true; do
    NEW_MODE=$(osascript -e 'tell application "System Events" to tell appearance preferences to get dark mode' |
        grep true &>/dev/null && echo dark || echo light)
    if [ "$NEW_MODE" != "$CURRENT_MODE" ]; then
        CURRENT_MODE="$NEW_MODE"
        tmux source-file "$TMUX_CONF"
    fi
    sleep 2
done
