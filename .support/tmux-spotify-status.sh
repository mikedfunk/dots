#!/usr/bin/env bash

osascript <<'EOF'
if application "Spotify" is running then
  tell application "Spotify"
    if player state is playing then
      return "󰐊 " & artist of current track & ": " & name of current track
    else if player state is paused then
      return "󰏤 " & artist of current track & ": " & name of current track
    else
      return "󰓛"
    end if
  end tell
else
  return "󰎊"
end if
EOF
