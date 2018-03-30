#!/bin/bash
defaults read -g AppleInterfaceStyle &>/dev/null
isDark="$?"

# style 21 will crash if 0 rows :/
# [[ $isDark == 0 ]] && style=22 || style=21

# light style that doesn't crash if no rows
[[ $isDark == 0 ]] && style=22 || style=16

pspg --style=$style --reprint-on-exit --quit-if-one-screen

# change config instead
# gsed -i "s/^theme = .[2]$/theme = ${style}/" "$HOME"/.pspgconf
# pspg
