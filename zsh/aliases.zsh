# Navigation
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git shortcuts
alias gs="git status"

# claude-sessions (private repo cloned by scripts/install-claude-sessions.sh)
if [ -x "$HOME/.dotfiles/claude-sessions/claude-sessions" ]; then
  alias cs="$HOME/.dotfiles/claude-sessions/claude-sessions"
fi

# Modern replacements (if available). Each shadows the standard tool; bypass
# with `o<name>` (e.g. ogrep) or `command <name>` (always works, also from
# scripts that don't load this file).
#
# Skipped inside Claude Code ($CLAUDECODE=1): Claude's Bash tool runs zsh
# with a snapshot of this shell env, so these aliases were leaking in and
# changing flag semantics on tools Claude invokes by name (rg vs grep,
# fd vs find, bat vs cat, tspin vs tail). Keeping them out of Claude's
# shell gives it vanilla GNU/BSD behavior without changing the interactive
# experience.
if [ -z "$CLAUDECODE" ]; then
  if command -v eza &> /dev/null; then
    alias ls="eza"
    alias ll="eza -alF"
    alias la="eza -A"
    alias l="eza -F"
    alias tree="eza --tree --icons=auto"
    alias ols="/bin/ls"  # original ls
  else
    alias ls="ls -G"  # colorize on macOS
    alias ll="ls -alF"
    alias la="ls -A"
    alias l="ls -CF"
  fi

  if command -v bat &> /dev/null; then
    alias cat="bat"
    alias ocat="/bin/cat"  # original cat
  fi

  if command -v fd &> /dev/null; then
    alias find="fd"
    alias ofind="/usr/bin/find"  # original find
  fi

  if command -v rg &> /dev/null; then
    alias grep="rg"
    alias ogrep="/usr/bin/grep"  # original grep
  fi

  if command -v nvim &> /dev/null; then
    alias vim="nvim"
    alias vi="nvim"
    alias ovim="/usr/bin/vim"  # original vim
  fi

  # tail wrapper — `tail file.log` and `tail -f file.log` colorize via tspin.
  # Tspin shares some flags with tail (-f, -p, -h, -V) but not others (-n, -c,
  # -5, -q, -r, -F, ...). When any tail-only flag is present we fall through to
  # real tail so scripts/agents keep working. `--opt=value` form is handled.
  if command -v tspin &> /dev/null; then
    tail() {
      local -a tspin_flags=(
        -f --follow
        -p --print
        -e --exec
        -h --help
        -V --version
        --config-path
        --highlight
        --enable --disable --extras
        --disable-builtin-keywords
        --pager
      )
      local arg flag
      for arg in "$@"; do
        [[ "$arg" == -* ]] || continue
        flag=${arg%%=*}
        if (( ${tspin_flags[(I)$flag]} == 0 )); then
          command tail "$@"
          return
        fi
      done
      command tspin "$@"
    }
    alias otail="/usr/bin/tail"  # original tail
  fi
fi
