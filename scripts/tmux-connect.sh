#!/usr/bin/env bash
# Interactive tmux session picker for SSH logins.
#
# Flow:
#   - lists existing tmux sessions
#   - offers [new session] and [no tmux — plain shell] entries
#   - falls back to plain "attach or create main" if fzf is missing
#
# Wire up in ~/.ssh/config with:
#   RemoteCommand if [ -x ~/.dotfiles/scripts/tmux-connect.sh ]; then \
#     ~/.dotfiles/scripts/tmux-connect.sh; else tmux new -As main; fi

set -u

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CHEATSHEET="${SCRIPT_DIR}/../tmux/cheatsheet.txt"

SESSIONS=$(tmux ls 2>/dev/null | awk -F: '{print $1}' || true)

# Graceful fallback if fzf isn't installed
if ! command -v fzf >/dev/null 2>&1; then
  if [ -z "$SESSIONS" ]; then
    exec tmux new -s main
  else
    exec tmux attach
  fi
fi

# Build picker options: [existing sessions...] [new session] [no tmux]
OPTIONS=""
[ -n "$SESSIONS" ] && OPTIONS="${SESSIONS}"$'\n'
OPTIONS="${OPTIONS}[new session]"$'\n'"[no tmux — plain shell]"

# One-line header above the fzf list — picker stays clean, full cheat sheet
# is one keystroke away (Ctrl-a h) once you're inside tmux.
HEADER='prefix: Ctrl-Space    d=detach  c=new-win  |/-=split  arrows=move  n/p=tabs  h=help'

CHOICE=$(printf '%s\n' "$OPTIONS" | fzf \
  --height=60% --reverse --border \
  --prompt='tmux> ' --header="$HEADER" --no-info)

case "$CHOICE" in
  "")
    # User hit Esc — just drop into a shell rather than disconnecting
    exec "${SHELL:-/bin/bash}" -l
    ;;
  "[new session]")
    printf 'Session name [main]: '
    read -r NAME
    exec tmux new -s "${NAME:-main}"
    ;;
  "[no tmux — plain shell]")
    [ -r "$CHEATSHEET" ] && cat "$CHEATSHEET"
    exec "${SHELL:-/bin/bash}" -l
    ;;
  *)
    exec tmux attach -t "$CHOICE"
    ;;
esac
