#!/usr/bin/env bash

set -e

# TPM's install_plugins shells out to `tmux show-options` to read the plugin
# list, so it needs tmux on PATH. On hosts without tmux (e.g. local Mac that
# only uses tmux over SSH), skip cleanly instead of failing the whole install.
if ! command -v tmux >/dev/null 2>&1; then
  echo "tmux not installed on this host — skipping plugin setup"
  echo "(re-run ./install once tmux is available, or run this script directly)"
  exit 0
fi

echo "Setting up tmux plugins..."

TPM_DIR="$HOME/.tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
  echo "Cloning TPM..."
  git clone --depth=1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
fi

# Idempotent: TPM clones missing plugins and leaves existing ones alone.
if [ -x "$TPM_DIR/bin/install_plugins" ]; then
  echo "Installing/updating tmux plugins via TPM..."
  "$TPM_DIR/bin/install_plugins"
fi

echo "✅ tmux plugins ready"
echo "💡 Reload tmux config (prefix r) or restart tmux to pick up changes"
