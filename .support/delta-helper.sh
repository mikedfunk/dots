#!/bin/bash
defaults read -g AppleInterfaceStyle &>/dev/null
isDark="$?"
[[ $isDark == 0 ]] && theme='--dark' || theme='--light'
[[ $isDark == 0 ]] && syntax='Monokai Extended' || syntax='Monokai Extended Light'

delta --syntax-theme="$syntax" -- $@
