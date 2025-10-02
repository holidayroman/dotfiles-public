# System aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."

# Git shortcuts
alias gs="git status"

# Modern replacements (if available)
if command -v eza &> /dev/null; then
  alias ls="eza"
  alias ll="eza -alF"
  alias la="eza -A"
  alias l="eza -F"
  alias tree="eza --tree --icons"
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

# Ripgrep reminder
if command -v rg &> /dev/null; then
  function grep() {
    echo "💡 Tip: Consider using 'rg' instead of grep for faster searches"
    command grep "$@"
  }
fi

# Development shortcuts
if command -v nvim &> /dev/null; then
  alias vim="nvim"
  alias vi="nvim"
  alias ovim="/usr/bin/vim"  # original vim
fi