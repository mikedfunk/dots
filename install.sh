#!/bin/bash

mkdir -p "$HOME"/.bin &&
    curl -fLo "$HOME"/.bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm &&
    chmod +x "$HOME"/.bin/yadm

"$HOME"/.bin/yadm clone git@github.com:mikedfunk/dots.git --bootstrap
