#!/bin/bash

_log_info() { echo -e "$(tput setaf 2)$(tput rev)$(tput bold) \xE2\x9C\x93 $1 $(tput sgr0)"; }

_install_yadm_if_missing() {
    _log_info "installing yadm"
    curl -fLo /usr/local/bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm && chmod a+x /usr/local/bin/yadm
    export PATH="/usr/local/bin:$PATH"
}

_install_yadm_if_missing
yadm clone git@github.com:mikedfunk/dots.git --bootstrap
