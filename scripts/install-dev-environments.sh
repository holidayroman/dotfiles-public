#!/bin/bash

# Install development environment tools (nvm, pyenv, rustup)
# This script checks if tools are already installed and prompts for installation

set -e

# Colors for output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Detect shell config file
detect_shell_config() {
    if [ -n "$ZSH_VERSION" ]; then
        echo "$HOME/.zshrc"
    elif [ -n "$BASH_VERSION" ]; then
        if [ -f "$HOME/.bash_profile" ]; then
            echo "$HOME/.bash_profile"
        else
            echo "$HOME/.bashrc"
        fi
    else
        echo "$HOME/.profile"
    fi
}

SHELL_CONFIG=$(detect_shell_config)

# Check if a line exists in shell config
config_has_line() {
    local pattern="$1"
    grep -q "$pattern" "$SHELL_CONFIG" 2>/dev/null
}

# Add line to shell config if it doesn't exist
add_to_config() {
    local line="$1"
    local comment="$2"

    if ! grep -Fq "$line" "$SHELL_CONFIG" 2>/dev/null; then
        echo "" >> "$SHELL_CONFIG"
        [ -n "$comment" ] && echo "# $comment" >> "$SHELL_CONFIG"
        echo "$line" >> "$SHELL_CONFIG"
        echo -e "${GREEN}Added to $SHELL_CONFIG${NC}"
    else
        echo -e "${YELLOW}Already in $SHELL_CONFIG${NC}"
    fi
}

# Install nvm (Node Version Manager)
install_nvm() {
    echo -e "\n${BLUE}=== Node Version Manager (nvm) ===${NC}"

    if [ -d "$HOME/.nvm" ] || command -v nvm &> /dev/null; then
        echo -e "${GREEN}nvm is already installed${NC}"
        return
    fi

    read -p "Install nvm? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping nvm"
        return
    fi

    echo "Installing nvm..."
    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

    # Add to shell config
    if ! config_has_line "NVM_DIR"; then
        cat >> "$SHELL_CONFIG" << 'EOF'

# nvm (Node Version Manager)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
EOF
        echo -e "${GREEN}Added nvm to $SHELL_CONFIG${NC}"
    fi

    echo -e "${GREEN}nvm installed successfully!${NC}"
    echo "Restart your shell or run: source $SHELL_CONFIG"
}

# Install pyenv (Python Version Manager)
install_pyenv() {
    echo -e "\n${BLUE}=== Python Version Manager (pyenv) ===${NC}"

    if command -v pyenv &> /dev/null; then
        echo -e "${GREEN}pyenv is already installed${NC}"
        return
    fi

    read -p "Install pyenv? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping pyenv"
        return
    fi

    echo "Installing pyenv..."

    # Check OS and install accordingly
    if [[ "$OSTYPE" == "darwin"* ]]; then
        if command -v brew &> /dev/null; then
            brew install pyenv
        else
            echo -e "${YELLOW}Homebrew not found, using curl installer${NC}"
            curl https://pyenv.run | bash
        fi
    else
        curl https://pyenv.run | bash
    fi

    # Add to shell config
    if ! config_has_line "pyenv init"; then
        cat >> "$SHELL_CONFIG" << 'EOF'

# pyenv (Python Version Manager)
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init -)"
EOF
        echo -e "${GREEN}Added pyenv to $SHELL_CONFIG${NC}"
    fi

    echo -e "${GREEN}pyenv installed successfully!${NC}"
    echo "Restart your shell or run: source $SHELL_CONFIG"
}

# Install rustup (Rust toolchain installer)
install_rustup() {
    echo -e "\n${BLUE}=== Rust Toolchain (rustup) ===${NC}"

    if command -v rustup &> /dev/null || command -v cargo &> /dev/null; then
        echo -e "${GREEN}rustup/cargo is already installed${NC}"
        return
    fi

    read -p "Install rustup? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Skipping rustup"
        return
    fi

    echo "Installing rustup..."
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

    # Add to shell config (rustup installer usually does this, but check)
    if ! config_has_line "cargo/env"; then
        add_to_config '. "$HOME/.cargo/env"' "Rust/Cargo"
    fi

    echo -e "${GREEN}rustup installed successfully!${NC}"
    echo "Restart your shell or run: source $SHELL_CONFIG"
}

# Main execution
main() {
    echo -e "${BLUE}Development Environment Setup${NC}"
    echo "This will optionally install: nvm, pyenv, rustup"
    echo "Shell config: $SHELL_CONFIG"
    echo

    install_nvm
    install_pyenv
    install_rustup

    echo -e "\n${GREEN}Done!${NC}"
    echo "Remember to restart your shell or run: source $SHELL_CONFIG"
}

main
