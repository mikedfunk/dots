#!/usr/bin/env bash

export PATH="/opt/homebrew/bin:$PATH"

# these tmux plugins must be loaded after theme change or they stop working
# in statusbar because the script just sets tmux variables which are set by their tmux plugins.
(
    defaults read -g AppleInterfaceStyle 2>/dev/null | grep -q Dark &&
        tmux source "$XDG_CONFIG_HOME"/tmux/tmuxline-dark.conf || tmux source "$XDG_CONFIG_HOME"/tmux/tmuxline-light.conf
) &&
    tmux run-shell "$TMUX_PLUGIN_MANAGER_PATH"/tmux-cpu/cpu.tmux &&
    tmux run-shell "$TMUX_PLUGIN_MANAGER_PATH"/tmux-battery/battery.tmux
