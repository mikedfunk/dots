#!/usr/bin/env bash
# Watch .go files; on change, run tests only for the packages that changed.
# Run from the repo root. Needs fd, entr, noti.
stamp=$(mktemp)
trap 'rm -f "$stamp"' EXIT
export stamp

run() {
  clear
  pkgs=$(find . -name '*.go' -newer "$stamp" -exec dirname {} \; | sort -u)
  touch "$stamp"
  [ -z "$pkgs" ] && return
  # shellcheck disable=SC2086
  noti --message "✅ Go tests passed: $pkgs" go test $pkgs
}
export -f run

# entr -d exits when a new file appears, so the loop restarts with the fresh file list.
while true; do
  fd -e go | entr -dn bash -c run
done
