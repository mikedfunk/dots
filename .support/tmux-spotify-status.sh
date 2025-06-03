#!/usr/bin/env bash

# throttle, otherwise `spotify ...` will launch the spotify client when it's
# quit because it's process hasn't finished exiting yet :/
# sleep 4
# if pgrep '^Spotify$' &>/dev/null; then
#     if spotify status | head -n 1 | grep --silent playing; then
#         status="󰐊"
#     else
#         status="󰏤"
#     fi
#     echo -n "$status $(spotify status artist): $(spotify status track)"
# else
#     echo -n "󰎊"
# fi

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
