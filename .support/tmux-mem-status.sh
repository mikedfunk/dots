#!/usr/bin/env bash

cache_file="/tmp/tmux_mem_status_cache"
cache_ttl=1

if [[ ! -f "$cache_file" || $(($(date +%s) - $(stat -f %m "$cache_file"))) -gt $cache_ttl ]]; then
    page_size=$(sysctl -n hw.pagesize)
    total_pages=$(($(sysctl -n hw.memsize) / page_size))
    used_pages=$(vm_stat | awk '/Pages active|Pages wired down|Pages occupied by compressor/{gsub(/[^0-9]/,"",$NF); sum+=$NF} END{print sum}')
    awk -v used="$used_pages" -v total="$total_pages" 'BEGIN { printf "%.0f", 100 * used / total }' >"$cache_file"
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
