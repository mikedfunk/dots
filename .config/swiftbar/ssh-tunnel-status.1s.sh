#!/bin/bash
# <bitbar.title>SSH Tunnel Status</bitbar.title>
# <bitbar.desc>Shows SSH tunnel status in the menubar using SSH control socket</bitbar.desc>
# <bitbar.version>1.1</bitbar.version>
# <bitbar.author>Mike Funk</bitbar.author>

# SSH tunnel configuration
SSH_HOST="saatchi-tunnel-aws-ssm"
CONTROL_SOCKET="$HOME/.ssh/saatchi-tunnel-aws-ssm.sock"

# Check tunnel status using SSH control socket
if ssh -S "$CONTROL_SOCKET" "$SSH_HOST" -O check 2>/dev/null; then
    status="connected"
else
    status="disconnected"
fi

case "$status" in
connected)
    echo ":icloud.and.arrow.up: | sfcolor=green"
    echo "---"
    echo "Tunnel is active"
    echo "Disconnect | bash='/usr/bin/ssh' param1='-S' param2='$CONTROL_SOCKET' param3='$SSH_HOST' param4='-O' param5='exit' terminal=false refresh=true"
    ;;
disconnected)
    echo ":icloud.slash: | sfcolor=red"
    echo "---"
    echo "Tunnel is inactive"
    # doesn't work
    # Build connect command: source shell config, AWS SSO check, start privoxy, create tunnel
    # Uses login shell to get full user environment (AWS config, SSH config, etc.)
    # echo "Connect | $HOME/.support/saatchi/start-tunnel.sh terminal=true refresh=true"
    ;;
esac
