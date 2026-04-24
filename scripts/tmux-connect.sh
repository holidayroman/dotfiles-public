#!/usr/bin/env bash
# Interactive tmux session picker for SSH logins.
#
# Flow:
#   - lists existing tmux sessions
#   - offers [new session] and [no tmux — plain shell] entries
#   - falls back to plain "attach or create default session" if fzf is missing
#   - auto-suffixes duplicate session names (session, session-2, session-3…)
#
# Wire up in ~/.ssh/config. The Match-exec guard is important: without it,
# scp/rsync/sftp/git sessions get hijacked by the RemoteCommand and break.
#
#   Host myhost
#     ...
#   Match host myhost exec "! ps -o comm= -p $(ps -o ppid= -p $PPID | tr -d ' ') 2>/dev/null | grep -qiE '^(scp|rsync|sftp|git)'"
#     RequestTTY yes
#     RemoteCommand if [ -x ~/.dotfiles/scripts/tmux-connect.sh ]; then \
#       ~/.dotfiles/scripts/tmux-connect.sh; else tmux new -As main; fi

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEATSHEET="${SCRIPT_DIR}/../tmux/cheatsheet.sh"
DEFAULT_NAME="session"

# Return a session name based on $1 that doesn't already exist — appends
# -2, -3, ... until a free name is found. Avoids `tmux new -s` failing on
# duplicate names when picking [new session] with a default.
unique_session_name() {
  local base="$1" candidate="$1" i=2
  while tmux has-session -t="$candidate" 2>/dev/null; do
    candidate="${base}-${i}"
    i=$((i + 1))
  done
  printf '%s' "$candidate"
}

SESSIONS=$(tmux ls 2>/dev/null | awk -F: '{print $1}' || true)

# Graceful fallback if fzf isn't installed
if ! command -v fzf >/dev/null 2>&1; then
  if [ -z "$SESSIONS" ]; then
    exec tmux new -s "$DEFAULT_NAME"
  else
    exec tmux attach
  fi
fi

# Build picker options: [existing sessions...] [new session] [no tmux]
OPTIONS=""
[ -n "$SESSIONS" ] && OPTIONS="${SESSIONS}"$'\n'
OPTIONS="${OPTIONS}[new session]"$'\n'"[no tmux — plain shell]"

# One-line header above the fzf list — picker stays clean, full cheat sheet
# is one keystroke away (Ctrl-Space ?) once you're inside tmux.
HEADER='prefix: Ctrl-Space    d=detach  c=new-win  |/-=split  arrows=move  n/p=tabs  ?=help'

CHOICE=$(printf '%s\n' "$OPTIONS" | fzf \
  --height=60% --reverse --border \
  --prompt='tmux> ' --header="$HEADER" --no-info)

case "$CHOICE" in
  "")
    # User hit Esc — just drop into a shell rather than disconnecting
    exec "${SHELL:-/bin/bash}" -l
    ;;
  "[new session]")
    printf 'Session name [%s]: ' "$DEFAULT_NAME"
    read -r NAME
    NAME=$(unique_session_name "${NAME:-$DEFAULT_NAME}")
    exec tmux new -s "$NAME"
    ;;
  "[no tmux — plain shell]")
    [ -x "$CHEATSHEET" ] && "$CHEATSHEET"
    exec "${SHELL:-/bin/bash}" -l
    ;;
  *)
    exec tmux attach -t "$CHOICE"
    ;;
esac
