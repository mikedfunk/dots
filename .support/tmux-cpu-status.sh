#!/usr/bin/env bash

cache_file="/tmp/tmux_cpu_status_cache"
cache_ttl=1

if [[ ! -f "$cache_file" || $(($(date +%s) - $(stat -f %m "$cache_file"))) -gt $cache_ttl ]]; then
    idle=$(top -l 2 -s 1 -n 0 | awk -F'[:,]' '/CPU usage/{gsub(/[^0-9.]/,"",$4); print $4}' | tail -1)
    awk -v idle="$idle" 'BEGIN { printf "%.0f", 100 - idle }' >"$cache_file"
fi

usage=$(<"$cache_file")

thresholds=(49 79 100)
icons=("=" ≡ ≣)
colors=(colour2 colour3 colour1)

for i in "${!thresholds[@]}"; do
    if ((usage <= thresholds[i])); then
        echo -n "#[fg=${colors[i]}]${icons[i]}#[fg=default]"
        break
    fi
done
