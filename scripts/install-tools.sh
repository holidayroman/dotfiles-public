#!/usr/bin/env bash

set -e

echo "Installing development tools..."

# Install Homebrew (macOS)
if [ "$(uname)" = "Darwin" ] && ! command -v brew > /dev/null 2>&1; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

# Install packages from Brewfile
if [ "$(uname)" = "Darwin" ] && command -v brew > /dev/null 2>&1; then
  echo "Installing packages from Brewfile..."
  SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
  brew bundle --file="$SCRIPT_DIR/../Brewfile"
fi

echo "✅ Tools installation complete!"
