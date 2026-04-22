# ZSH Configuration (without oh-my-zsh)

# History settings
HISTFILE=~/.zsh_history
HISTSIZE=100000
SAVEHIST=100000
setopt EXTENDED_HISTORY         # store timestamp + duration per entry
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE        # leading-space commands aren't recorded
setopt HIST_FIND_NO_DUPS
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS       # normalize whitespace before saving
setopt HIST_VERIFY              # !! expansions are editable, not auto-run
setopt INC_APPEND_HISTORY       # write each command as it runs
setopt SHARE_HISTORY            # live-sync across open shells

# `history` defaults to last 100; `history N` shows the last N. Multi-arg
# calls pass through to `fc -l` (e.g. `history 1 50` for an explicit range).
# Note: in zsh `fc -l -N` does NOT mean "last N" — we compute the start event.
history() {
  if (( $# > 1 )); then
    fc -l "$@"
  else
    local n=${1:-100}
    [[ "$n" =~ ^[0-9]+$ ]] || { fc -l "$@"; return; }
    local start=$(( HISTCMD - n + 1 ))
    (( start < 1 )) && start=1
    fc -l $start
  fi
  if [[ -t 1 ]]; then
    print -P -u2 -- ""
    print -P -u2 -- "%F{242}# search: %F{111}hgrep <phrase>%F{242}  |  delete: %F{203}hdel <phrase>%f"
  fi
}

# hgrep <phrase>  —  case-insensitive literal search through full history
hgrep() {
  fc -l 1 | command grep -iF -- "$@"
}

# hdel <phrase>  —  delete every history entry containing <phrase>
# Prompts before deleting. Works on the saved file + current shell.
hdel() {
  emulate -L zsh
  if [[ -z "$1" ]]; then
    print -u2 "usage: hdel <phrase>"
    return 1
  fi
  fc -W  # flush in-memory buffer to $HISTFILE first
  local matches count tmp
  matches=$(command grep -iF -- "$1" "$HISTFILE")
  if [[ -z "$matches" ]]; then
    print -- "no history entries matching: $1"
    return 0
  fi
  count=$(print -r -- "$matches" | wc -l | tr -d ' ')
  print -r -- "$matches"
  print -n -- "delete all $count matches from \$HISTFILE? [y/N] "
  read -r reply
  if [[ "$reply" == [yY] ]]; then
    tmp=$(mktemp) || return 1
    command grep -ivF -- "$1" "$HISTFILE" > "$tmp" && mv "$tmp" "$HISTFILE"
    fc -R
    print -- "deleted $count entries"
  else
    print -- "aborted"
  fi
}

# Environment variables
export EDITOR='vim'
export VISUAL='vim'
export PAGER='less'
export DIRENV_LOG_FORMAT=""  # silence direnv loading messages

# Development environment paths
export PATH="/usr/local/bin:$PATH"
[ -d "/usr/local/go/bin" ] && export PATH="/usr/local/go/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Load aliases
[ -f ~/.dotfiles/zsh/aliases.zsh ] && source ~/.dotfiles/zsh/aliases.zsh

# Auto-update ~/.dotfiles/claude-sessions clone once per 24h, in background.
# Throttle: FETCH_HEAD mtime (git pull refreshes it). No-op when clone absent.
_cs_dir="$HOME/.dotfiles/claude-sessions"
if [ -d "$_cs_dir/.git" ] && { [ ! -f "$_cs_dir/.git/FETCH_HEAD" ] || [ -n "$(command find "$_cs_dir/.git/FETCH_HEAD" -mtime +1 2>/dev/null)" ]; }; then
  (cd "$_cs_dir" && GIT_TERMINAL_PROMPT=0 git pull --ff-only --quiet </dev/null >/dev/null 2>&1 &)
fi
unset _cs_dir

# ZSH plugins (loaded directly, no framework)
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"

# Load zsh-syntax-highlighting
if [ -f "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# Load zsh-autosuggestions
if [ -f "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
  source "$ZSH_PLUGINS_DIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi

# Load zsh-history-substring-search
if [ -f "$ZSH_PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]; then
  source "$ZSH_PLUGINS_DIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
  # Bind up/down arrows
  bindkey '^[[A' history-substring-search-up
  bindkey '^[[B' history-substring-search-down
fi

# Homebrew completion (macOS)
if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

# Docker completion
if command -v docker &> /dev/null; then
  FPATH="$HOME/.docker/completions:${FPATH}"
fi

# Enable completion system (must be after FPATH additions)
# Skip the security check on cached dump if it's <24h old — much faster startup.
autoload -Uz compinit
_zcompdump_fresh=( ${ZDOTDIR:-$HOME}/.zcompdump(Nmh-24) )
if (( $#_zcompdump_fresh )); then
  compinit -C
else
  compinit
fi
unset _zcompdump_fresh

# Menu completion - navigate with arrow keys
zstyle ':completion:*' menu select
setopt AUTO_MENU

# FZF integration
if command -v fzf &> /dev/null; then
  # macOS / manual installs drop a single ~/.fzf.zsh; Debian ships split files.
  if [ -f ~/.fzf.zsh ]; then
    source ~/.fzf.zsh
  else
    [ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
    [ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
  fi

  # FZF configuration
  export FZF_DEFAULT_COMMAND='fd --type f --hidden --follow --exclude .git'
  export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
  export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

  # Tokyo Night colors for fzf
  export FZF_DEFAULT_OPTS='
    --color=fg:#c0caf5,bg:#1a1b26,hl:#bb9af7
    --color=fg+:#c0caf5,bg+:#283457,hl+:#7dcfff
    --color=info:#7aa2f7,prompt:#7dcfff,pointer:#7aa2f7
    --color=marker:#9ece6a,spinner:#9ece6a,header:#9ece6a'
fi

# Zoxide (smarter cd)
if command -v zoxide &> /dev/null; then
  eval "$(zoxide init zsh)"
fi

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# pyenv (Python Version Manager)
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
command -v pyenv &> /dev/null && eval "$(pyenv init -)"

# Rust/Cargo
[ -f "$HOME/.cargo/env" ] && . "$HOME/.cargo/env"

# direnv (per-directory env auto-loader)
if command -v direnv &> /dev/null; then
  eval "$(direnv hook zsh)"
  direnv reload 2>/dev/null  # re-apply env after pyenv/nvm init
fi

# Initialize Starship prompt (must be at the end)
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi
