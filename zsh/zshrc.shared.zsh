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

# Homebrew env — handles Apple Silicon (/opt/homebrew) and Intel
# (/usr/local) paths plus MANPATH/INFOPATH. No-op on Linux if brew absent.
if [ -x /opt/homebrew/bin/brew ]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
  eval "$(/usr/local/bin/brew shellenv)"
fi

# Development environment paths
export PATH="/usr/local/bin:$PATH"
[ -d "/usr/local/go/bin" ] && export PATH="/usr/local/go/bin:$PATH"
[ -d "$HOME/.cargo/bin" ] && export PATH="$HOME/.cargo/bin:$PATH"
[ -d "$HOME/.local/bin" ] && export PATH="$HOME/.local/bin:$PATH"

# Load aliases
[ -f ~/.dotfiles/zsh/aliases.zsh ] && source ~/.dotfiles/zsh/aliases.zsh

# Load `help` command
[ -f ~/.dotfiles/zsh/help.zsh ] && source ~/.dotfiles/zsh/help.zsh

# Auto-update ~/.dotfiles/claude-sessions clone once per 24h, in background.
# Throttle: FETCH_HEAD mtime (git pull refreshes it). No-op when clone absent.
_cs_dir="$HOME/.dotfiles/claude-sessions"
if [ -d "$_cs_dir/.git" ] && { [ ! -f "$_cs_dir/.git/FETCH_HEAD" ] || [ -n "$(command find "$_cs_dir/.git/FETCH_HEAD" -mtime +1 2>/dev/null)" ]; }; then
  (cd "$_cs_dir" && GIT_TERMINAL_PROMPT=0 git pull --ff-only --quiet </dev/null >/dev/null 2>&1 &)
fi
unset _cs_dir

# Dotfiles auto-updater — once per 24h in background. Fast-forwards main and
# relinks (no sudo, no prompts). If the update touched setup scripts or the
# Brewfile, writes .git/update-pending so the next shell reminds you to run
# ./install manually (which needs sudo / interactive input).
_df_dir="$HOME/.dotfiles"
_df_pending="$_df_dir/.git/update-pending"

if [[ -t 2 ]] && [ -f "$_df_pending" ]; then
  print -P -u2 -- ""
  print -P -u2 -- "%F{214}⚠ dotfiles: setup scripts changed upstream — run %F{111}cd ~/.dotfiles && ./install%F{214} to apply%f"
  print -P -u2 -- ""
fi

if [ -d "$_df_dir/.git" ] && { [ ! -f "$_df_dir/.git/FETCH_HEAD" ] || [ -n "$(command find "$_df_dir/.git/FETCH_HEAD" -mtime +1 2>/dev/null)" ]; }; then
  (
    cd "$_df_dir" || exit
    [ "$(git symbolic-ref --short HEAD 2>/dev/null)" = "main" ] || exit
    _before=$(git rev-parse HEAD 2>/dev/null) || exit
    GIT_TERMINAL_PROMPT=0 git pull --ff-only --quiet </dev/null >/dev/null 2>&1 || exit
    _after=$(git rev-parse HEAD 2>/dev/null)
    [ "$_before" = "$_after" ] && exit  # nothing new
    # Relink only — safe without sudo. Skips the shell-install steps.
    ./dotbot/bin/dotbot -d "$_df_dir" -c install.conf.yaml --only link create clean </dev/null >/dev/null 2>&1
    # Flag non-link changes so next shell reminds user to run ./install.
    if git diff --name-only "$_before..$_after" 2>/dev/null | grep -qE '^(scripts/|Brewfile|install$|install\.conf\.yaml$)'; then
      : > "$_df_pending"
    fi
  ) &!
fi
unset _df_dir _df_pending

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

# 1Password SSH agent (macOS) — point all tools at the 1P agent socket.
# `ssh` itself already uses it via `IdentityAgent` in ~/.ssh/config; this also
# covers ssh-add, rsync, ansible, language SDKs, etc. that read SSH_AUTH_SOCK.
_op_agent_sock="$HOME/Library/Group Containers/2BUA8C4S2C.com.1password/t/agent.sock"
if [[ "$OSTYPE" == "darwin"* ]] && [[ -S "$_op_agent_sock" ]]; then
  export SSH_AUTH_SOCK="$_op_agent_sock"
fi
unset _op_agent_sock

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

# nvm (Node Version Manager) — lazy-loaded.
# Sourcing nvm.sh eagerly costs ~150ms of shell startup (per zprof) which
# widens the race window where Warp's SSH bootstrap script echoes visibly
# before our end-of-rcfile Warpify DCS fires. Stub functions for
# nvm/node/npm/npx source nvm.sh on first use instead.
export NVM_DIR="$HOME/.nvm"
if [ -s "$NVM_DIR/nvm.sh" ]; then
  _load_nvm() {
    unset -f nvm node npm npx _load_nvm
    \. "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  }
  for _cmd in nvm node npm npx; do
    eval "$_cmd() { _load_nvm; $_cmd \"\$@\"; }"
  done
  unset _cmd
fi

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
