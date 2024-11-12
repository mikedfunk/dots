#!/bin/bash
defaults read -g AppleInterfaceStyle &>/dev/null
isDark="$?"
# [[ $isDark == 0 ]] && theme='--dark' || theme='--light'
# [[ $isDark == 0 ]] && syntax='Monokai Extended' || syntax='Monokai Extended Light'
[[ $isDark == 0 ]] && syntax='zebra-dark' || syntax='zebra-light'

delta \
    --diff-so-fancy \
    --syntax-theme="$syntax" \
    -- $@
