#!/usr/bin/env bash

set -e

echo "Installing development tools..."

# macOS - use Homebrew
if [ "$(uname)" = "Darwin" ]; then
  # Install Homebrew if not present
  if ! command -v brew > /dev/null 2>&1; then
    echo "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Install packages from Brewfile
  if command -v brew > /dev/null 2>&1; then
    echo "Installing packages from Brewfile..."
    SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
    brew bundle --file="$SCRIPT_DIR/../Brewfile"
  fi

# Linux - use package manager
else
  if command -v apt-get &> /dev/null; then
    echo "Debian/Ubuntu detected - installing packages..."

    # Update package list
    sudo apt-get update

    # Install packages available in standard repos (skip neovim, will install separately)
    sudo apt-get install -y \
      bat \
      fd-find \
      fzf \
      ripgrep \
      zoxide \
      htop \
      tldr

    # Install neovim - Debian repos have old version (0.7.x), CoC requires 0.8.0+
    # Use AppImage for latest stable version
    if ! command -v nvim &> /dev/null || ! nvim --version | grep -q "NVIM v0\.[8-9]\|NVIM v[1-9]"; then
      echo ""
      echo "Installing newer neovim (Debian repos have outdated version)..."
      echo "Using AppImage for latest stable neovim..."

      # Download AppImage
      curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
      chmod u+x nvim.appimage

      # Move to local bin
      mkdir -p ~/.local/bin
      mv nvim.appimage ~/.local/bin/nvim

      echo "✓ Installed neovim AppImage to ~/.local/bin/nvim"
    fi

    # Create symlinks for Debian package names
    # bat is installed as batcat on Debian
    if ! command -v bat &> /dev/null && command -v batcat &> /dev/null; then
      mkdir -p ~/.local/bin
      ln -sf /usr/bin/batcat ~/.local/bin/bat
      echo "Created bat -> batcat symlink"
    fi

    # fd is installed as fdfind on Debian
    if ! command -v fd &> /dev/null && command -v fdfind &> /dev/null; then
      mkdir -p ~/.local/bin
      ln -sf /usr/bin/fdfind ~/.local/bin/fd
      echo "Created fd -> fdfind symlink"
    fi

    # Install eza (better ls) - needs cargo or manual installation
    if ! command -v eza &> /dev/null; then
      echo ""
      echo "⚠️  eza not found in apt repos"
      if command -v cargo &> /dev/null; then
        echo "Installing eza via cargo..."
        cargo install eza
      else
        echo "Install cargo (via rustup) to get eza, or install manually"
        echo "See: https://github.com/eza-community/eza#installation"
      fi
    fi

    # Install starship prompt - needs curl installation
    if ! command -v starship &> /dev/null; then
      echo ""
      echo "Installing starship prompt..."
      curl -sS https://starship.rs/install.sh | sh -s -- -y
    fi

    # Install git-delta - needs manual installation on Debian
    if ! command -v delta &> /dev/null; then
      echo ""
      echo "⚠️  git-delta not found in apt repos"
      echo "Install manually from: https://github.com/dandavison/delta/releases"
      echo "Or via cargo: cargo install git-delta"
    fi

    # Install GitHub CLI from official repo
    if ! command -v gh &> /dev/null; then
      echo ""
      echo "Installing GitHub CLI..."
      curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
      sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg
      echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
      sudo apt-get update
      sudo apt-get install -y gh
    fi

    echo ""
    echo "✅ Debian packages installed successfully!"

  elif command -v dnf &> /dev/null; then
    echo "⚠️  Fedora/RHEL detected but not yet supported"
    echo "Please manually install packages equivalent to Brewfile"

  elif command -v pacman &> /dev/null; then
    echo "⚠️  Arch Linux detected but not yet supported"
    echo "Please manually install packages equivalent to Brewfile"

  else
    echo "⚠️  Unsupported Linux distribution"
    echo "Please manually install packages from Brewfile"
  fi
fi

echo "✅ Tools installation complete!"
