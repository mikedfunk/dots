#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:$PATH"

# tmux-cpu / tmux-battery plugins were removed (status uses ~/.support scripts), so no re-run needed.
# no tmux server running (e.g. right after reboot) = nothing to theme, and tmux would print a connect error
tmux has-session 2>/dev/null || exit 0

defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark &&
    tmux source "$XDG_CONFIG_HOME"/tmux/tmuxline-dark.conf || tmux source "$XDG_CONFIG_HOME"/tmux/tmuxline-light.conf
