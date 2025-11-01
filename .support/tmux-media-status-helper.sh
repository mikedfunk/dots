#!/usr/bin/env bash

json=$(media-control get)

if [[ "$json" == "null" ]]; then
    echo "󰎊"
    exit 0
fi

playing=$(echo "$json" | jq -r '.playing // empty' | awk '{ if (length > 10) print substr($0, 1, 10) "..." ; else print }')
artist=$(echo "$json" | jq -r '.artist // "Unknown Artist"' | awk '{ if (length > 10) print substr($0, 1, 10) "..." ; else print }')
title=$(echo "$json" | jq -r '.title // "Unknown Title"' | awk '{ if (length > 10) print substr($0, 1, 10) "..." ; else print }')

if [[ "$playing" == "true" ]]; then
    icon="󰐊"
else
    icon="󰏤"
fi

echo "$icon $artist: $title"
