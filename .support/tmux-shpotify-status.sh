#!/usr/bin/env bash

if pgrep "^Spotify$" &>/dev/null; then
    echo -n "󰎆 $(spotify status artist): $(spotify status track)"
else
    echo -n "󱑙"
fi
