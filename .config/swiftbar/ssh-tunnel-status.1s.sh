#!/bin/bash
# <bitbar.title>SSH Tunnel Status</bitbar.title>
# <bitbar.desc>Shows SSH tunnel status in the menubar using SSH control socket</bitbar.desc>
# <bitbar.version>1.1</bitbar.version>
# <bitbar.author>Mike Funk</bitbar.author>

# SSH tunnel configuration
SSH_HOST="saatchi-tunnel-aws-ssm"
CONTROL_SOCKET="$HOME/.ssh/saatchi-tunnel-aws-ssm.sock"
SSH_CONFIG="$HOME/.ssh/config"

# Check tunnel status using SSH control socket
if ssh -S "$CONTROL_SOCKET" "$SSH_HOST" -O check 2>/dev/null; then
    status="connected"
else
    status="disconnected"
fi

case "$status" in
    connected)
        echo "󰌘 | color=green"
        echo "---"
        echo "Tunnel is active"
        echo "Disconnect | bash='/usr/bin/ssh' param1='-S' param2='$CONTROL_SOCKET' param3='$SSH_HOST' param4='-O' param5='exit' terminal=false refresh=true"
        ;;
    disconnected)
        echo "󰌙 | color=red"
        echo "---"
        echo "Tunnel is inactive"
        # Build connect command: source shell config, AWS SSO check, start privoxy, create tunnel
        # Uses login shell to get full user environment (AWS config, SSH config, etc.)
        echo "Connect | bash='/bin/zsh' param1='-ilc' param2='export PATH=\"/opt/homebrew/bin:/usr/local/bin:\$PATH\"; aws sts get-caller-identity >/dev/null 2>&1 || aws sso login; if ! [ \$(brew services info privoxy --json 2>/dev/null | jq -r \".[0].running\") = \"true\" ]; then brew services start privoxy; fi; ssh -f -M -S \"$CONTROL_SOCKET\" -F \"$SSH_CONFIG\" \"$SSH_HOST\"' terminal=true refresh=true"
        ;;
esac
