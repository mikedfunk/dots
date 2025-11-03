#!/bin/bash
# <bitbar.title>Zoom Mic Status</bitbar.title>
# <bitbar.desc>Shows Zoom mic status in the menubar</bitbar.desc>
# <bitbar.version>1.6</bitbar.version>
# <bitbar.author>Mike Funk</bitbar.author>

status=$(
    /usr/bin/osascript <<'APPLESCRIPT'
tell application "System Events"
    try
        if not (exists process "zoom.us") then return "closed"
        tell process "zoom.us"
            if not (exists menu bar item "Meeting" of menu bar 1) then return "closed"
            tell menu bar item "Meeting" of menu bar 1
                set m to menu 1
                if exists menu item "Mute Audio" of m then return "on"
                if exists menu item "Unmute Audio" of m then return "off"
                return "off"
            end tell
        end tell
    on error
        return "closed"
    end try
end tell
APPLESCRIPT
)

case "$status" in
on) echo ":microphone.fill: | sfcolor=green" ;;
off) echo ":microphone.slash.fill: | sfcolor=red" ;;
closed) echo "" ;; # Show nothing when Zoom is not running
*) echo "" ;;
esac
