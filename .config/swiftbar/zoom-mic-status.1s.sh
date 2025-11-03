#!/bin/bash
# <bitbar.title>Zoom Mic Status</bitbar.title>
# <bitbar.desc>Shows Zoom mic status in the menubar (fast, every second)</bitbar.desc>
# <bitbar.version>1.5</bitbar.version>
# <bitbar.author>Mike Funk</bitbar.author>

status=$(
    /usr/bin/osascript <<'APPLESCRIPT'
tell application "System Events"
    try
        if not (exists process "zoom.us") then return "off"
        tell process "zoom.us"
            if not (exists menu bar item "Meeting" of menu bar 1) then return "off"
            tell menu bar item "Meeting" of menu bar 1
                set m to menu 1
                if exists menu item "Mute Audio" of m then return "on"
                if exists menu item "Unmute Audio" of m then return "off"
                return "off"
            end tell
        end tell
    on error
        return "off"
    end try
end tell
APPLESCRIPT
)

if [[ "$status" == "on" ]]; then
    echo ":microphone.fill:"
elif [[ "$status" == "off" ]]; then
    echo ":microphone.slash.fill: | color=red"
else
    echo ""
fi
