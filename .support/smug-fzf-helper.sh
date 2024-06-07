#!/usr/bin/env bash

set -euo pipefail

get_smug_windows() {
    local files=$(ls "$HOME"/.config/smug | grep '.yml')

    for file in $files; do
        local session=$(echo $file | sed 's/.yml//')
        local windows=$(cat "$HOME"/.config/smug/"$file" | yq '.windows[].name' -)

        for window in $windows; do
            echo "$session:$window"
        done
    done
}

smug $(get_smug_windows | fzf --tmux 20%,20% | awk '{print $1}') --attach >/dev/null 2>&1
