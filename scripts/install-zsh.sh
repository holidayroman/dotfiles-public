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

  # Find fzf install script based on OS
  if [ "$(uname)" = "Darwin" ] && command -v brew > /dev/null 2>&1; then
    # macOS with Homebrew
    FZF_INSTALL="$(brew --prefix)/opt/fzf/install"
  elif [ -f "/usr/share/doc/fzf/examples/key-bindings.zsh" ]; then
    # Debian/Ubuntu - fzf shell integration installed separately
    echo "FZF installed via apt - shell integration files available in /usr/share/doc/fzf/examples/"
    echo "These will be sourced automatically by zshrc if fzf is installed"
    FZF_INSTALL=""
  else
    # Try to find fzf install script in common locations
    for loc in ~/.fzf/install /usr/local/opt/fzf/install; do
      if [ -f "$loc" ]; then
        FZF_INSTALL="$loc"
        break
      fi
    done
  fi

  # Run fzf install if found
  if [ -n "$FZF_INSTALL" ] && [ -f "$FZF_INSTALL" ]; then
    $FZF_INSTALL --key-bindings --completion --no-update-rc
  fi
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
