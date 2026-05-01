#!/bin/bash

# Install claude-sessions alongside dotfiles. Repo URL is read from the
# CLAUDE_SESSIONS_REPO env var so this dotfiles repo can stay public without
# disclosing which repo you actually point at.
#
# Easiest setup: add a line to ~/.config-private/dotfiles.env (or any other
# file you source from your shell):
#
#     export CLAUDE_SESSIONS_REPO=git@github.com:youraccount/claude-sessions.git
#
# If the env var isn't set, this step is skipped — useful on work machines or
# anywhere without access to the configured repo.

set -e

GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
NC='\033[0m'

# Pull in optional private env (won't fail if missing)
[ -f "$HOME/.config-private/dotfiles.env" ] && source "$HOME/.config-private/dotfiles.env"

DOTFILES_DIR="$(cd "$(dirname "$0")/.." && pwd)"
TARGET_DIR="$DOTFILES_DIR/claude-sessions"

echo -e "${BLUE}=== claude-sessions ===${NC}"

if [ -d "$TARGET_DIR/.git" ]; then
  echo "Updating existing checkout at $TARGET_DIR..."
  git -C "$TARGET_DIR" pull --ff-only || echo -e "${YELLOW}⚠️  Pull failed; leaving as-is${NC}"
  echo -e "${GREEN}✓ Up to date${NC}"
  exit 0
fi

if [ -z "${CLAUDE_SESSIONS_REPO:-}" ]; then
  echo "CLAUDE_SESSIONS_REPO not set — skipping. (See top of this script for setup.)"
  exit 0
fi

read -p "Install claude-sessions from $CLAUDE_SESSIONS_REPO ? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
  echo "Skipped."
  exit 0
fi

if ! git clone "$CLAUDE_SESSIONS_REPO" "$TARGET_DIR"; then
  echo -e "${YELLOW}⚠️  Clone failed — skipping claude-sessions setup${NC}"
  exit 0
fi

echo -e "${GREEN}✓ Cloned to $TARGET_DIR (cs alias wired up in zsh/aliases.zsh)${NC}"
