# `help` — quick reference for dotfiles aliases and functions.
# Sections gate on `command -v` so output matches the active environment.
help() {
  print -P ""
  print -P "%F{cyan}%Bdotfiles%b%f — aliases and functions"
  print -P "%F{242}─────────────────────────────────────────%f"

  print -P ""
  print -P "%F{yellow}%BNavigation%b%f"
  print -P "  %F{green}..  ...  ....%f       cd up 1 / 2 / 3 levels"

  print -P ""
  print -P "%F{yellow}%BGit%b%f"
  print -P "  %F{green}gs%f                  git status"

  print -P ""
  print -P "%F{yellow}%BHistory%b%f"
  print -P "  %F{green}history [N]%f         show last N entries (default 100)"
  print -P "  %F{green}hgrep <phrase>%f      case-insensitive search through history"
  print -P "  %F{green}hdel <phrase>%f       delete every history entry matching phrase"

  print -P ""
  print -P "%F{yellow}%BMisc%b%f"
  print -P "  %F{green}reload%f              re-source ~/.zshrc"
  print -P "  %F{green}smb-mounts%f          list SMB/CIFS mounts grouped by share"
  if [ -x "$HOME/.dotfiles/claude-sessions/claude-sessions" ]; then
    print -P "  %F{green}cs%f                  claude-sessions"
  fi

  print -P ""
  print -P "%F{yellow}%BModern tool replacements%b%f %F{242}(bypass with o<name> or 'command <name>')%f"
  if [ -n "$CLAUDECODE" ]; then
    print -P "  %F{242}skipped inside Claude Code — using vanilla GNU/BSD tools%f"
  else
    if command -v eza &>/dev/null; then
      print -P "  %F{green}ls  ll  la  l%f       eza variants"
      print -P "  %F{green}lls%f                 detailed listing + disk + cwd size"
      print -P "  %F{green}tree%f                eza --tree --icons"
    else
      print -P "  %F{green}ls  ll  la  l%f       colored ls"
      print -P "  %F{green}lls%f                 ls -alFhS + disk + cwd size"
    fi
    command -v bat   &>/dev/null && print -P "  %F{green}cat%f                 bat"
    command -v fd    &>/dev/null && print -P "  %F{green}find%f                fd"
    command -v rg    &>/dev/null && print -P "  %F{green}grep%f                rg (ripgrep)"
    command -v nvim  &>/dev/null && print -P "  %F{green}vim  vi%f             nvim"
    command -v tspin &>/dev/null && print -P "  %F{green}tail  tail -f%f       tspin (falls through on tail-only flags)"
  fi

  print -P ""
  print -P "%F{242}defined in: ~/.dotfiles/zsh/{aliases,zshrc.shared,help}.zsh%f"
  print -P ""
}
