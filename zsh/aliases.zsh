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

# List currently mounted SMB/CIFS shares, grouped by remote source so multiple
# bind mounts of the same share (e.g. //server/backups → 4 local paths) are
# obvious at a glance.
smb-mounts() {
  local out
  out=$(mount 2>/dev/null | awk '
    $5 ~ /^(cifs|smbfs|smb3)$/ {
      remote = $1
      mp = $3
      if (!(remote in seen)) { order[++n] = remote; seen[remote] = 1 }
      list[remote] = list[remote] (list[remote] ? "\n" : "") "  " mp
    }
    END {
      for (i = 1; i <= n; i++) {
        if (i > 1) print ""
        print order[i]
        print list[order[i]]
      }
    }
  ')
  if [[ -z "$out" ]]; then
    print "No SMB/CIFS mounts."
  else
    print -- "$out"
  fi
}

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
  # One-line filesystem usage summary appended after lls. Picks fields by
  # position so it works on both BSD and GNU df (mount point is always $NF).
  # If cwd lives on a network filesystem (cifs/smb/nfs/sshfs/fuse), df reports
  # that share's stats — often misleading (e.g. unraid CIFS reports 0 used of
  # 489G). Detect those via `df -T` (GNU) and fall back to / so the summary
  # always reflects the local machine disk. On BSD `df -T` fails, type stays
  # empty, and behavior matches the original (cwd's filesystem).
  _lls_disk_summary() {
    local target=. type fs
    type=$(df -T . 2>/dev/null | awk 'NR==2 {print $2}')
    case "$type" in
      cifs|smbfs|smb3|nfs|nfs4|sshfs|fuse|fuse.*) target=/ ;;
    esac
    fs=$(df -h "$target" 2>/dev/null | awk 'NR==2 { printf "%s used of %s (%s) on %s", $3, $2, $5, $NF }')
    [[ -n "$fs" ]] && print -P "%F{242}── %F{111}${fs//\%/%%}%f"
  }

  # Absolute path + total size of the directory lls just listed, on its own
  # line so the path is easy to double-click/copy. Picks the first existing
  # non-flag arg from "$@" (the path lls was given), defaulting to ".".
  _lls_dir_summary() {
    local arg target=.
    for arg in "$@"; do
      [[ "$arg" == -* ]] && continue
      [[ -e "$arg" ]] || continue
      target=$arg
      break
    done
    local abspath=${target:A} size
    size=$(du -sh "$target" 2>/dev/null | awk '{print $1}')
    [[ -n "$size" ]] && print -P "%F{242}── %F{222}${size}%f  %F{255}${abspath}%f"
  }

  if command -v eza &> /dev/null; then
    alias ls="eza"
    alias ll="eza -alF"
    lls() { command eza -alF --total-size --sort=size --reverse --group-directories-first --time-style=long-iso "$@"; _lls_disk_summary; _lls_dir_summary "$@"; }
    alias la="eza -A"
    alias l="eza -F"
    alias tree="eza --tree --icons=auto"
    alias ols="/bin/ls"  # original ls
  else
    alias ls="ls -G"  # colorize on macOS
    alias ll="ls -alF"
    # GNU ls supports --group-directories-first and --time-style; BSD/macOS ls
    # uses -T for a full-precision (year-included) timestamp instead.
    if command ls --version &> /dev/null; then
      lls() { command ls -alFhS --group-directories-first --time-style=long-iso "$@"; _lls_disk_summary; _lls_dir_summary "$@"; }
    else
      lls() { command ls -alFhST "$@"; _lls_disk_summary; _lls_dir_summary "$@"; }
    fi
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
