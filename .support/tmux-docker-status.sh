#!/usr/bin/env bash

DOCKER="󰡨"
cache_file="/tmp/docker_status_cache"
cache_ttl=2

# Refresh cache if missing or older than TTL
if [[ ! -f "$cache_file" || $(($(date +%s) - $(stat -f %m "$cache_file"))) -gt $cache_ttl ]]; then
    docker desktop status --format=json >"$cache_file" 2>/dev/null
fi

status=$(jq -r .Status <"$cache_file" 2>/dev/null)

# Build output buffer instead of printing twice
output=""

case "$status" in
running)
    output+="#[fg=green,bold]${DOCKER}#[fg=default,nobold]"
    ;;
paused)
    output+="#[fg=yellow]${DOCKER}#[fg=default]"
    ;;
*)
    output+="#[fg=red]${DOCKER}#[fg=default]"
    ;;
esac

# Append the saatchi docker status on the same line
saatchi_status=$(bash "$HOME/.support/saatchi/tmux-docker-status.sh" 2>/dev/null)
[[ -n "$saatchi_status" ]] && output+=" ${saatchi_status}"

# Print once
echo -n "$output"
