#!/bin/bash

# Install claude-sessions (private repo) alongside dotfiles.
# Gated behind a prompt so work machines / anyone without SSH access to the
# private repo can skip it without failing the dotfiles install.

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

REPO_URL="git@github.com:holidayroman/claude-sessions.git"
DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$DOTFILES_DIR/claude-sessions"

echo -e "${BLUE}=== claude-sessions ===${NC}"

if [ -d "$TARGET_DIR/.git" ]; then
  echo "Updating existing checkout at $TARGET_DIR..."
  git -C "$TARGET_DIR" pull --ff-only || echo -e "${YELLOW}⚠️  Pull failed; leaving as-is${NC}"
  echo -e "${GREEN}✓ Up to date${NC}"
  exit 0
fi

read -p "Install claude-sessions? (requires SSH access to holidayroman/claude-sessions) (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Skipped."
  exit 0
fi

if ! git clone "$REPO_URL" "$TARGET_DIR"; then
  echo -e "${YELLOW}⚠️  Clone failed — skipping claude-sessions setup${NC}"
  exit 0
fi

echo -e "${GREEN}✓ Cloned to $TARGET_DIR (cs alias wired up in zsh/aliases.zsh)${NC}"
