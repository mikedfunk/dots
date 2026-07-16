#!/usr/bin/env bash

cache_file="/tmp/tmux_battery_status_cache"
cache_ttl=1

if [[ ! -f "$cache_file" || $(($(date +%s) - $(stat -f %m "$cache_file"))) -gt $cache_ttl ]]; then
    pmset -g batt | awk '/InternalBattery/{
        match($0, /[0-9]+%/); pct = substr($0, RSTART, RLENGTH-1)
        split($0, parts, ";"); state = parts[2]
        gsub(/^[ \t]+|[ \t]+$/, "", state)
        print pct, state
    }' >"$cache_file"
fi

read -r pct state <"$cache_file"

thresholds=(5 20 35 50 65 80 95 100)
icons=(󰂃 󱊡 󰁼 󰁽 󰁾 󰁿 󰂀 󰁹)
colors=(colour1 colour1 colour3 colour3 colour3 colour2 colour2 colour2)

for i in "${!thresholds[@]}"; do
    if ((pct <= thresholds[i])); then
        output="#[fg=${colors[i]}]${icons[i]}#[fg=default]"
        break
    fi
done

[[ "$state" == "charging" || "$state" == "charged" ]] && output+=" #[fg=colour2]󰚥#[fg=default]"

echo -n "$output"
