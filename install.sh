#!/bin/bash

curl -fLo "$HOME"/.bin/yadm https://github.com/yadm-dev/yadm/raw/master/yadm >/tmp/yadm
chmod +x /tmp/yadm

/tmp/yadm clone git@github.com:mikedfunk/dots.git --bootstrap
