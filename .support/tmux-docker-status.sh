#!/bin/bash

# DOCKER="🐳 "
DOCKER="󰡨"
# DOCKER=""

# timeout 2s docker ps --quiet 1> /dev/null
# [[ $? != 0 ]] && echo "#[fg=red]${DOCKER}#[fg=default]" && exit 0
# echo -n "#[fg=green,bold]${DOCKER}#[fg=default,nobold]"
[ "$(docker desktop status --format=json | jq .Status)" = '"running"' ] &&
    echo -n "#[fg=green,bold]${DOCKER}#[fg=default,nobold]" ||
    echo "#[fg=red]${DOCKER}#[fg=default]"

[ -f "$HOME"/.support/saatchi/tmux-docker-status.sh ] && "$HOME"/.support/saatchi/tmux-docker-status.sh
