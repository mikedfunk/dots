#!/usr/bin/env bash

# throttle
sleep 2

# DOCKER="🐳 "
DOCKER="󰡨"
# DOCKER=""

# timeout 2s docker ps --quiet 1> /dev/null
# [[ $? != 0 ]] && echo "#[fg=red]${DOCKER}#[fg=default]" && exit 0
# echo -n "#[fg=green,bold]${DOCKER}#[fg=default,nobold]"
case "$(docker desktop status --format=json | jq -r .Status)" in
running)
    echo "#[fg=green,bold]${DOCKER}#[fg=default,nobold]"
    ;;
paused)
    echo "#[fg=yellow]${DOCKER}#[fg=default]"
    exit 0
    ;;
*)
    echo "#[fg=red]${DOCKER}#[fg=default]"
    exit 0
    ;;
esac
# [ "$(docker desktop status --format=json | jq -r .Status)" = 'running' ] &&
#     echo -n "#[fg=green,bold]${DOCKER}#[fg=default,nobold]" ||
#     echo "#[fg=red]${DOCKER}#[fg=default]"

[ -f "$HOME"/.support/saatchi/tmux-docker-status.sh ] && "$HOME"/.support/saatchi/tmux-docker-status.sh
