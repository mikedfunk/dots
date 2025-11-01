#!/bin/bash
# vim: set fdm=marker:

eval "$(mise activate bash)"

# not cached version {{{

# icon=''
# keys=$(acli jira workitem search \
#     --jql 'assignee = currentUser() AND status = "In Progress" ORDER BY updated DESC' --json |
#     jq -r 'map(.key) | join(", ")')
# if [ -z "$keys" ]; then
#     echo -n "$icon"
#     exit 0
# fi
#
# printf "%s %s\n" "$icon" "$keys"
# }}}

# cached version (run every 5 mins): {{{

cache_file="/tmp/tmux_jira_status.cache"
icon=''
cache_ttl=$((5 * 60)) # 5 minutes

# Check if cache exists and is fresh
if [ -f "$cache_file" ]; then
    last_modified=$(stat -f "%m" "$cache_file") # macOS
    now=$(date +%s)
    age=$((now - last_modified))

    if [ "$age" -lt "$cache_ttl" ]; then
        cat "$cache_file"
        exit 0
    fi
fi

# Generate new status
first_two_keys=$(acli jira workitem search \
    --jql 'assignee = currentUser() AND status = "In Progress" ORDER BY updated DESC' --json |
    jq -r 'map(.key)[0:2] | join(", ")')

if [ -z "$first_two_keys" ]; then
    printf "%s\n" "$icon" >"$cache_file"
    cat "$cache_file"
    exit 0
fi

printf "%s %s\n" "$icon" "$first_two_keys" >"$cache_file"
cat "$cache_file"
# # }}}
