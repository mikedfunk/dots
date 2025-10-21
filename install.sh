#!/bin/bash

_log_info() { echo -e "$(tput setaf 2)$(tput rev)$(tput bold) \xE2\x9C\x93 $1 $(tput sgr0)"; }

curl https://mise.run | sh
mise use yadm -y -q
bash -c "$HOME/.bin/yadm clone git@github.com:mikedfunk/dots.git --bootstrap"
