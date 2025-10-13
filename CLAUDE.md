# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Repository Overview

This is a personal dotfiles repository that manages configuration files for ZSH, Vim/Neovim, Git, and various CLI tools. It uses **dotbot** as the installation framework to create symlinks and run setup scripts.

## Installation Architecture

The installation process is orchestrated by `./install`, which:
1. Initializes the dotbot submodule
2. Executes dotbot with `install.conf.yaml` configuration
3. Creates symlinks for config files to their target locations:
   - `~/.zshrc` → `zsh/zshrc.zsh`
   - `~/.vimrc` → `vim/vimrc.vim`
   - `~/.config/nvim/init.vim` → `nvim/init.vim`
   - `~/.gitconfig` → `git/gitconfig`
   - `~/.editorconfig` → `editorconfig.ini`
   - `~/.config/starship.toml` → `starship/starship.toml`
4. Runs installation scripts in sequence

## Key Commands

### Initial Setup
```bash
./install                                      # Full installation (creates symlinks, runs all setup scripts)
./scripts/install-dev-environments.sh          # Install nvm, pyenv, rustup (interactive)
```

### Update Dotfiles
```bash
git pull && ./install                          # Pull latest changes and re-run installation
git submodule update --remote dotbot           # Update dotbot framework
```

### Testing Changes (macOS)
```bash
brew bundle --file=Brewfile                    # Install/update packages from Brewfile
```

## Configuration Structure

### Local Override Files
The system creates machine-specific override files (not tracked in git) that are sourced automatically:
- `~/.zshrc.local` - ZSH customizations (aliases, paths, environment variables)
- `~/.vimrc.local` - Vim customizations
- `~/.config/nvim/local.vim` - Neovim-specific customizations
- `~/.gitconfig.local` - Git settings (proxy, credentials, etc)
- `~/.gitconfig.user` - Git user identity (created by setup-git-user.sh)

### Vim/Neovim Plugin Management
- Uses **vim-plug** for plugin management
- Plugins auto-installed on first Vim launch
- CoC extensions auto-install: `coc-tsserver`, `coc-pyright`, `coc-rust-analyzer`
- Key mappings are extensively documented inline at vim/vimrc.vim:59-116

### ZSH Configuration
- Does NOT use oh-my-zsh (lightweight, direct plugin loading)
- Plugins loaded from `~/.zsh/plugins/` directory:
  - zsh-syntax-highlighting
  - zsh-autosuggestions
  - zsh-history-substring-search
- Development environment managers (nvm, pyenv, rustup) initialized at end of zshrc.zsh:81-97
- Starship prompt initialized last (zshrc.zsh:95-97)

### Git Configuration
- User identity stored separately in `~/.gitconfig.user` (not tracked)
- Uses git-delta as pager for enhanced diffs (git/gitconfig:51)
- Extensive git aliases defined (git/gitconfig:9-45)
- Pre-commit hook blocks sensitive terms from being committed

## Important Architecture Notes

1. **Dotbot Installation Flow**: `install.conf.yaml` defines the sequence: clean → link → create → shell commands. Shell commands run setup scripts in order.

2. **Script Dependencies**: The setup scripts (install-tools.sh, install-zsh.sh, setup-git-user.sh, setup-git-hook.sh, install-dev-environments.sh) run sequentially through dotbot. They are designed to be idempotent.

3. **Platform Detection**: Scripts detect macOS vs Linux using `uname` checks. Homebrew/Brewfile only run on macOS.

4. **ZSH Plugin Loading**: Plugins are loaded directly from `~/.zsh/plugins/` without a framework, making the setup lightweight and fast.

5. **Development Environment Initialization Order**: In zshrc.zsh, tools initialize in this order: nvm (82-84) → pyenv (86-89) → cargo (92) → starship (95-97). This order matters for PATH precedence.

## Modifying Configurations

When editing configuration files, remember:
- Main configs are in: `zsh/`, `vim/`, `nvim/`, `git/`, `starship/`
- After editing, run `./install` to update symlinks (though usually unnecessary if symlinks already exist)
- For Vim plugin changes, edit `vim/vimrc.vim` plugin list and run `:PlugInstall` in Vim
- For ZSH changes, source the file or restart shell to test: `source ~/.zshrc`
- For Git alias changes, configs are immediately active (symlinked files)

## Platform-Specific Considerations

**macOS**: Uses Homebrew for package management (Brewfile). Fonts installed as casks.

**Linux**: Assumes package manager already present. Users may need to manually install packages listed in Brewfile using their distro's package manager.

**WSL**: The repository works in WSL2 on Linux (confirmed by env). Same as Linux considerations.
