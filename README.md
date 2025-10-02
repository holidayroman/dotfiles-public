# Dotfiles

A modern, feature-rich dotfiles setup for macOS and Linux with enhanced ZSH, Neovim/Vim, and Git configurations.

## ⚡ Quick Install

```bash
git clone --recursive https://github.com/YourUsername/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install
```

This will:
1. Install Homebrew (macOS only)
2. Install modern CLI tools via Brewfile
3. Set up ZSH with Starship prompt and essential plugins
4. Configure Vim and Neovim with shared vimrc
5. Set up Git with enhanced aliases and delta
6. Install EditorConfig support
7. Create all necessary symlinks using dotbot
8. Make ZSH your default shell

After installation, restart your terminal or run `source ~/.zshrc`.

## 🎯 What's Included

### Core Tools
- **ZSH**: Lightweight setup with Starship prompt, syntax highlighting, and autosuggestions (no framework)
- **Neovim/Vim**: Shared configuration with modern plugins and colorschemes
- **Git**: Enhanced aliases, delta diff viewer, and smart defaults
- **EditorConfig**: Consistent coding style across editors

### Modern CLI Tools (installed via Brewfile)
- **bat** - Better `cat` with syntax highlighting (aliased, use `ocat` for original)
- **eza** - Better `ls` with colors and git integration (aliased, use `ols` for original)
- **fd** - Better `find` with simpler syntax (aliased, use `ofind` for original)
- **fzf** - Fuzzy finder for files and command history (Ctrl+R, Ctrl+P in vim)
- **ripgrep** - Fast code search tool (use `rg`, `grep` shows reminder)
- **git-delta** - Syntax-highlighted diffs with side-by-side view
- **zoxide** - Smart directory jumper (use `z <dir>` or `zi` for interactive)
- **starship** - Fast, minimal, cross-shell prompt
- **gh** - GitHub CLI
- **htop** - Better process monitor
- **tldr** - Simplified man pages

### Fonts
- **M+ 1m Nerd Font** - Monospaced font with icons for terminal/vim

## 🔧 Installation Details

This setup uses [dotbot](https://github.com/anishathalye/dotbot) for automated installation and symlink management. The configuration is defined in `install.conf.yaml`.

**Updating dotbot:**
```bash
git submodule update --remote dotbot
```

## 🎨 Features

### ZSH Enhancements
- **Starship prompt** - Fast, minimal prompt showing git status, execution time, and language versions
- **Essential plugins** (loaded directly, no framework):
  - `zsh-syntax-highlighting` - Command syntax highlighting
  - `zsh-autosuggestions` - Fish-like autosuggestions
  - `zsh-history-substring-search` - Better history search with up/down arrows
- **Better history**: 10k entries, deduplication, smart search
- **Menu completion**: Tab through options with arrow keys
- **Modern aliases**:
  - Navigation: `..`, `...`, `....`
  - Git shortcuts: `gs`, `ga`, `gc`, `gp`, `gl`, `gd`, `gco`, `gb`
  - Docker: `d`, `dc`, `dps`, `dex` (if docker installed)
  - Fallbacks: `ols`, `ocat`, `ofind`, `ovim` for original commands

### Neovim/Vim Configuration
- **Shared config** - Both vim and neovim use the same vimrc
- **Alias**: `vim` and `vi` open neovim (use `ovim` for original vim)
- **Modern colorschemes**: Gruvbox (default), OneDark, Dracula, Nord
- **FZF integration**:
  - `Ctrl+P` - Fuzzy find files
  - `<leader>f` - Search file contents
  - `<leader>b` - Switch buffers
- **Plugins**:
  - vim-airline for status line
  - NERDTree for file explorer
  - ALE for syntax checking
  - vim-gitgutter for git diff in gutter
  - auto-pairs, surround, easymotion, and more
- **Font**: M+ 1m Nerd Font with icon support

### Git Workflow
- **Delta integration**: Beautiful syntax-highlighted diffs
- **Powerful aliases**:
  - `git lg` - Pretty graph log
  - `git recent` - Show recent branches
  - `git today` - Show today's commits
  - `git cleanup` - Remove merged branches
  - `git unstage` - Unstage files
- **Smart defaults**:
  - Rebase on pull
  - `main` as default branch
  - Auto-correct typos
  - Remember merge conflict resolutions (rerere)

## ⚙️ Customization

### Local Overrides
- **ZSH**: Add local customizations to `~/.zshrc.local`
- **Vim**: Add local customizations to `~/.vimrc-local`
- **Starship**: Edit `~/.config/starship.toml` to customize your prompt

### First-Time Setup
After running `./install`:

1. **Restart your terminal** - Or run `source ~/.zshrc`
2. **Install vim plugins**: Open vim/nvim and run `:PlugInstall`
3. **Set git user info**: Edit `git/gitconfig` with your name and email
4. **Install language version managers**:
   - Node: Install `nvm` or `fnm`
   - Python: Install `pyenv`
   - Rust: Install `rustup`
   - Go: Install via `asdf` or official installer

## 📦 Requirements

- **Git** - Version control (with submodule support)
- **macOS**: Homebrew will be installed automatically by the install script
- **Linux**:
  - ZSH should be installed manually if not present
  - Homebrew or manual tool installation required (see Brewfile for list)

## 🔧 Troubleshooting

### fzf keyboard shortcuts not working
Restart your terminal or run `source ~/.zshrc`

### Vim plugins not installed
Open vim/nvim and run `:PlugInstall`

### Airline theme errors in neovim
Run `:PlugInstall` to install vim-airline-themes

### zoxide not tracking directories
Start visiting directories - it learns over time. Use `z` after a few visits.

## 📝 Notes

- Programming languages (Node, Python, Go, Rust) are NOT installed via Homebrew
  - Use version managers instead (nvm, pyenv, rustup, asdf)
- The `vim` command is aliased to `nvim` if neovim is installed
- Original commands available: `ols`, `ocat`, `ofind`, `ovim`, `ogrep`
- Some plugins may require additional setup - check plugin documentation
