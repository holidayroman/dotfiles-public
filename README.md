# Dotfiles

Modern dotfiles setup for macOS and Linux (Debian/Ubuntu) with ZSH, Neovim/Vim, and Git configurations.

## ⚡ Quick Install

### macOS
```bash
git clone --recursive https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

### Linux (Debian/Ubuntu)
```bash
git clone --recursive https://github.com/yourusername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

The install script will:
1. Install prerequisites (curl, git, zsh, vim, build-essential on Linux)
2. Install modern CLI tools (via Homebrew on macOS, apt on Debian/Ubuntu)
3. Set up ZSH with Starship prompt
4. Configure Vim with vim-plug and plugins
5. Set up Git with local user configuration
6. Optionally install development environments (nvm, pyenv, rustup)
7. Create all necessary symlinks using dotbot
8. Create local override files for machine-specific customization

**Note for other Linux distros**: Currently only Debian/Ubuntu is fully supported. For Fedora, Arch, or other distros, you'll need to manually install the packages listed in the Brewfile.

### Installing Nerd Fonts

**macOS**: Fonts are automatically installed via Homebrew cask (M+ 1m Nerd Font)

**Linux Desktop**: Install Nerd Fonts manually:
```bash
mkdir -p ~/.local/share/fonts
cd ~/.local/share/fonts
wget https://github.com/ryanoasis/nerd-fonts/releases/latest/download/MPlus.zip
unzip MPlus.zip
rm MPlus.zip
fc-cache -fv
```

**WSL**: Install fonts on Windows (not in WSL):
1. Download Nerd Fonts from: https://github.com/ryanoasis/nerd-fonts/releases
2. Recommended: M+ 1m Nerd Font (MPlus.zip)
3. Extract and right-click fonts → "Install for all users"
4. Configure your Windows terminal to use the font (Windows Terminal, VSCode terminal, etc.)

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
