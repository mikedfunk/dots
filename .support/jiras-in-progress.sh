#!/bin/bash
icon=''
keys=$(acli jira workitem search \
    --jql 'assignee = currentUser() AND status = "In Progress" ORDER BY updated DESC' --json | jq -r 'map(.key) | join(", ")')
echo -n "$icon $keys"
