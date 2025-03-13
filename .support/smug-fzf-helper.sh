#!/usr/bin/env bash
set -euo pipefail

get_smug_windows() {
    local session windows
    for file in ~/.config/smug/*.yml; do
        session=$(basename "$file" | sed 's/.yml//')
        windows=$(yq '.windows[].name' - <"$file")

        for window in $windows; do
            echo "$session:$window"
        done
    done
}

smug start "$(get_smug_windows | fzf --tmux 20%,20% | awk '{print $1}')" --attach >/dev/null 2>&1
