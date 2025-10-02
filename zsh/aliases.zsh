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

# Docker aliases (if docker is available)
if command -v docker &> /dev/null; then
  alias d="docker"
  alias dc="docker-compose"
  alias dps="docker ps"
  alias dex="docker exec -it"
fi

# Development shortcuts
if command -v nvim &> /dev/null; then
  alias vim="nvim"
  alias vi="nvim"
  alias ovim="/usr/bin/vim"  # original vim
fi
alias reload="source ~/.zshrc"
alias zshconfig="vim ~/.zshrc"
alias vimconfig="vim ~/.vimrc"

# Network
if [[ "$OSTYPE" != "cygwin" ]]; then
	alias ports="sudo lsof -Pan -i tcp -i udp"
fi

# macOS specific
if [[ "$OSTYPE" == "darwin"* ]]; then
  alias showfiles="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
  alias hidefiles="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"
  alias flushdns="sudo dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
fi
