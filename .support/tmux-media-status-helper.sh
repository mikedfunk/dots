#!/usr/bin/env bash

json=$(media-control get)

if [[ "$json" == "null" ]]; then
    echo "󰎊"
    exit 0
fi

playing=$(echo "$json" | jq -r '.playing // empty')
artist=$(echo "$json" | jq -r '.artist // "Unknown Artist"')
title=$(echo "$json" | jq -r '.title // "Unknown Title"')

if [[ "$playing" == "true" ]]; then
    icon="󰐊"
else
    icon="󰏤"
fi

echo "$icon $artist: $title"
