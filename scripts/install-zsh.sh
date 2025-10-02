#!/usr/bin/env bash

set -e

echo "Setting up ZSH..."

# Create plugins directory
ZSH_PLUGINS_DIR="$HOME/.zsh/plugins"
mkdir -p "$ZSH_PLUGINS_DIR"

# Install zsh-syntax-highlighting
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting" ]; then
  echo "Installing zsh-syntax-highlighting..."
  git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$ZSH_PLUGINS_DIR/zsh-syntax-highlighting"
fi

# Install zsh-autosuggestions
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-autosuggestions" ]; then
  echo "Installing zsh-autosuggestions..."
  git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_PLUGINS_DIR/zsh-autosuggestions"
fi

# Install zsh-history-substring-search
if [ ! -d "$ZSH_PLUGINS_DIR/zsh-history-substring-search" ]; then
  echo "Installing zsh-history-substring-search..."
  git clone https://github.com/zsh-users/zsh-history-substring-search "$ZSH_PLUGINS_DIR/zsh-history-substring-search"
fi

# Setup fzf shell integration
if command -v fzf > /dev/null 2>&1 && [ ! -f "$HOME/.fzf.zsh" ]; then
  echo "Setting up fzf shell integration..."
  $(brew --prefix)/opt/fzf/install --key-bindings --completion --no-update-rc
fi

# Make zsh default shell
if [ "$SHELL" != "$(which zsh)" ]; then
  echo "Making zsh the default shell..."
  if ! grep -q "$(which zsh)" /etc/shells; then
    echo "$(which zsh)" | sudo tee -a /etc/shells
  fi
  chsh -s "$(which zsh)" || echo "Note: You may need to manually change your shell to zsh"
fi

echo "✅ ZSH setup complete!"
echo "💡 Restart your terminal to use the new configuration"
