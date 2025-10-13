#!/usr/bin/env bash

# Install prerequisite packages needed for dotfiles installation
# Runs before other installation scripts

set -e

echo "Installing prerequisites..."

# Detect OS
if [ "$(uname)" = "Darwin" ]; then
  echo "macOS detected - prerequisites handled by Homebrew"
  exit 0
fi

# Linux - detect package manager
if command -v apt-get &> /dev/null; then
  echo "Debian/Ubuntu detected - using apt-get"

  # Update package list
  echo "Updating package list..."
  sudo apt-get update

  # Install prerequisites
  echo "Installing base packages..."
  sudo apt-get install -y \
    curl \
    git \
    zsh \
    vim \
    build-essential \
    ca-certificates

  echo "✅ Prerequisites installed successfully!"

elif command -v dnf &> /dev/null; then
  echo "⚠️  Fedora/RHEL detected but not yet supported"
  echo "Please manually install: curl git zsh vim gcc make"
  exit 1

elif command -v pacman &> /dev/null; then
  echo "⚠️  Arch Linux detected but not yet supported"
  echo "Please manually install: curl git zsh vim base-devel"
  exit 1

else
  echo "⚠️  Unsupported Linux distribution"
  echo "Please manually install: curl git zsh vim build-essential"
  exit 1
fi
