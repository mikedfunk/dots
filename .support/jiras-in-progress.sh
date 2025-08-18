#!/bin/bash
icon=''
keys=$(acli jira workitem search \
    --jql 'assignee = currentUser() AND status = "In Progress" ORDER BY updated DESC' --json | jq -r 'map(.key) | join(", ")')
if [ -z "$keys" ]; then
    echo -n "$icon"
    exit 0
fi
echo -n "$icon $keys"
