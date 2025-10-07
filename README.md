# Dotfiles

Modern dotfiles setup for macOS and Linux with ZSH, Neovim/Vim, and Git configurations.

## ⚡ Quick Install

```bash
git clone --recursive https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

The install script will:
1. Install Homebrew (macOS only)
2. Install modern CLI tools via Brewfile
3. Set up ZSH with Starship prompt
4. Configure Vim with vim-plug and plugins
5. Set up Git with local user configuration
6. Optionally install development environments (nvm, pyenv, rustup)
7. Create all necessary symlinks using dotbot
8. Create local override files for machine-specific customization

After installation, restart your terminal.

## 🎯 What's Included

### Core Configuration
- **ZSH**: Starship prompt with syntax highlighting and autosuggestions
- **Vim**: Modern editor with plugins via vim-plug
  - **NerdTree** - File explorer
  - **CoC.nvim** - Language server and autocompletion (Python, JavaScript/TypeScript, Rust)
  - **FZF** - Fuzzy file finder
  - **ALE** - Linting and fixing
  - **Gruvbox** - Color scheme with Lightline status bar
  - **vim-gitgutter** - Git diff markers
  - **vim-easymotion** - Enhanced movement
  - **vim-surround** & **auto-pairs** - Text manipulation
- **Git**: Enhanced configuration with delta diff viewer
- **EditorConfig**: Consistent coding style across editors

### Modern CLI Tools (via Brewfile)
- **bat** - Better `cat` with syntax highlighting
- **eza** - Better `ls` with colors and git integration
- **fd** - Better `find` with simpler syntax
- **fzf** - Fuzzy finder for files and command history
- **ripgrep** - Fast code search
- **git-delta** - Syntax-highlighted diffs
- **zoxide** - Smart directory jumper
- **starship** - Fast, minimal prompt
- **gh** - GitHub CLI
- **htop** - Process monitor
- **tldr** - Simplified man pages
- **M+ 1m Nerd Font** - Monospaced font with icons

### Development Environments (Optional)
During installation, you'll be prompted to install:
- **nvm** - Node.js version manager
- **pyenv** - Python version manager
- **rustup** - Rust toolchain installer (includes cargo)

You can also run the installer separately:
```bash
./scripts/install-dev-environments.sh
```

## ⚙️ Local Overrides

Machine-specific customizations go in these files (created automatically, not tracked in git):

- **~/.zshrc.local** - ZSH aliases, paths, environment variables
- **~/.vimrc.local** - Vim customizations
- **~/.config/nvim/local.vim** - Neovim-specific customizations
- **~/.gitconfig.local** - Git settings (proxy, credentials, etc)
- **~/.gitconfig.user** - Git user identity (name/email)
- **~/.dotfiles/.git/hooks/pre-commit** - Pre-commit hook to block sensitive terms from being committed

## 🔧 Updating

Update dotfiles:
```bash
cd ~/.dotfiles
git pull
./install
```

Update dotbot submodule:
```bash
git submodule update --remote dotbot
```
