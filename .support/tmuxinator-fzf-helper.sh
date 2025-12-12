#!/usr/bin/env bash
set -euo pipefail

find ~/.config/tmuxinator/*.yml | sed 's/\.yml$//' | xargs basename | fzf --tmux 20%,20% | xargs tmuxinator start --append
