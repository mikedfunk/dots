#!/usr/bin/env bash

helper_src="${0%/*}/tmux-wifi-rssi.swift"
helper_bin="${0%/*}/tmux-wifi-rssi"

[[ ! -x "$helper_bin" || "$helper_src" -nt "$helper_bin" ]] && swiftc -O "$helper_src" -o "$helper_bin" 2>/dev/null

rssi=$("$helper_bin")

thresholds=(-80 -67 -60 -50)
icons=(󰤭 󰤟 󰤢 󰤥 󰤨)
colors=(red yellow green green green)

if [[ "$rssi" == "off" ]]; then
    echo -n "#[fg=red]睊#[fg=default]"
    exit
fi

for i in "${!thresholds[@]}"; do
    if ((rssi <= thresholds[i])); then
        echo -n "#[fg=${colors[i]}]${icons[i]}#[fg=default]"
        exit
    fi
done

echo -n "#[fg=${colors[4]}]${icons[4]}#[fg=default]"
