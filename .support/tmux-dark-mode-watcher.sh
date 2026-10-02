#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:$PATH"

# tmux-cpu / tmux-battery plugins were removed (status uses ~/.support scripts), so no re-run needed.
defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark &&
    tmux source "$XDG_CONFIG_HOME"/tmux/tmuxline-dark.conf || tmux source "$XDG_CONFIG_HOME"/tmux/tmuxline-light.conf
