#!/bin/bash

# Install development environment tools (nvm, pyenv, rustup)
# Shell config is already in zsh/zshrc.zsh

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}Development Environment Setup${NC}\n"

# nvm + Node.js
echo -e "${BLUE}=== Node.js (nvm) ===${NC}"
if [ ! -d "$HOME/.nvm" ]; then
    read -p "Install nvm? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
        export NVM_DIR="$HOME/.nvm"
        [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
        nvm install --lts
        nvm alias default 'lts/*'
        echo -e "${GREEN}✓ Installed nvm and Node.js LTS${NC}"
    fi
else
    export NVM_DIR="$HOME/.nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
    if ! command -v node &> /dev/null; then
        nvm install --lts
        nvm alias default 'lts/*'
        echo -e "${GREEN}✓ Installed Node.js LTS${NC}"
    else
        echo -e "${GREEN}✓ Already installed${NC}"
    fi
fi

# pyenv + Python
echo -e "\n${BLUE}=== Python (pyenv) ===${NC}"
if ! command -v pyenv &> /dev/null; then
    read -p "Install pyenv? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        if [[ "$OSTYPE" == "darwin"* ]] && command -v brew &> /dev/null; then
            brew install pyenv
        else
            curl https://pyenv.run | bash
        fi
        echo -e "${GREEN}✓ Installed pyenv${NC}"
    fi
fi

if command -v pyenv &> /dev/null; then
    export PYENV_ROOT="$HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"

    if ! command -v python &> /dev/null; then
        latest=$(pyenv install --list | grep -E '^\s*3\.[0-9]+\.[0-9]+$' | tail -1 | xargs)
        pyenv install "$latest"
        pyenv global "$latest"
        echo -e "${GREEN}✓ Installed Python $latest${NC}"
    else
        echo -e "${GREEN}✓ Already installed${NC}"
    fi
fi

# rustup + Rust
echo -e "\n${BLUE}=== Rust (rustup) ===${NC}"
if ! command -v cargo &> /dev/null; then
    read -p "Install rustup? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
        . "$HOME/.cargo/env"
        echo -e "${GREEN}✓ Installed Rust${NC}"
    fi
else
    echo -e "${GREEN}✓ Already installed${NC}"
fi

echo -e "\n${GREEN}Done! Restart your shell.${NC}"
