#!/bin/bash
# vim: set fdm=marker:

# not cached version {{{

# icon=''
# keys=$(acli jira workitem search \
#     --jql 'assignee = currentUser() AND status = "In Progress" ORDER BY updated DESC' --json |
#     jq -r 'map(.key) | join(", ")')
# if [ -z "$keys" ]; then
#     echo -n "$icon"
#     exit 0
# fi
# }}}

# cached version (run every 5 mins): {{{

CACHE_FILE="/tmp/tmux_jira_status.cache"
ICON=''
CACHE_TTL=$((5 * 60)) # 5 minutes

# Check if cache exists and is fresh
if [ -f "$CACHE_FILE" ]; then
    LAST_MODIFIED=$(stat -f "%m" "$CACHE_FILE") # macOS
    NOW=$(date +%s)
    AGE=$((NOW - LAST_MODIFIED))

    if [ "$AGE" -lt "$CACHE_TTL" ]; then
        cat "$CACHE_FILE"
        exit 0
    fi
fi

# Generate new status
keys=$(acli jira workitem search \
    --jql 'assignee = currentUser() AND status = "In Progress" ORDER BY updated DESC' --json |
    jq -r 'map(.key) | join(", ")')

if [ -z "$keys" ]; then
    printf "%s\n" "$ICON" >"$CACHE_FILE"
    cat "$CACHE_FILE"
    exit 0
fi

printf "%s %s\n" "$ICON" "$keys" >"$CACHE_FILE"
cat "$CACHE_FILE"
# }}}
