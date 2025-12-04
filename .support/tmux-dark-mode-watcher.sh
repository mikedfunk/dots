#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:$PATH"
TMUX_CONF="$HOME/.config/tmux/tmux.conf"

CURRENT_MODE=""
while true; do
    NEW_MODE=$([[ "$(defaults read -g AppleInterfaceStyle 2>/dev/null)" == "Dark" ]] && echo dark || echo light)
    if [ "$NEW_MODE" != "$CURRENT_MODE" ]; then
        CURRENT_MODE="$NEW_MODE"
        tmux source-file "$TMUX_CONF"
    fi
    sleep 2
done
