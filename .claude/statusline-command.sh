#!/usr/bin/env bash
# Claude Code statusLine — mirrors p10k segments: dir, git, context, model, context window
input=$(cat)

cwd=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // empty')
model=$(echo "$input" | jq -r '.model.display_name // empty')
used=$(echo "$input" | jq -r '.context_window.used_percentage // empty')
total_in=$(echo "$input" | jq -r '.context_window.total_input_tokens // empty')
total_out=$(echo "$input" | jq -r '.context_window.total_output_tokens // empty')

# Shorten home directory
short_cwd="${cwd/#$HOME/\~}"

# Git branch (skip optional lock)
branch=""
if git -C "$cwd" rev-parse --is-inside-work-tree &>/dev/null 2>&1; then
  branch=$(git -C "$cwd" -c core.hooksPath=/dev/null symbolic-ref --short HEAD 2>/dev/null \
           || git -C "$cwd" -c core.hooksPath=/dev/null rev-parse --short HEAD 2>/dev/null)
fi

# Build status line using printf with ANSI colors (dimmed-friendly)
parts=()

# dir (cyan)
parts+=("$(printf '\033[36m%s\033[0m' "$short_cwd")")

# git branch (green)
[ -n "$branch" ] && parts+=("$(printf '\033[32m %s\033[0m' "$branch")")

# model (blue)
[ -n "$model" ] && parts+=("$(printf '\033[34m%s\033[0m' "$model")")

# combined context segment: "context: 8.4K / 14%"
if [ -n "$total_in" ] && [ -n "$total_out" ]; then
  total=$(( total_in + total_out ))
  if [ "$total" -ge 1000 ]; then
    tok_fmt="$(awk "BEGIN { printf \"%.1fK\", $total/1000 }")"
  else
    tok_fmt="$total"
  fi
  if [ -n "$used" ]; then
    parts+=("$(printf '\033[35mcontext: %s / %s%%\033[0m' "$tok_fmt" "$(printf '%.0f' "$used")")")
  else
    parts+=("$(printf '\033[35mcontext: %s\033[0m' "$tok_fmt")")
  fi
fi

# Join with separator
(IFS=' | '; echo "${parts[*]}")
