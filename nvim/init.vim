" Neovim configuration that sources shared vimrc
" This allows vim and neovim to share the same configuration

" Set vim compatibility paths
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath

" Source the shared vimrc
source ~/.vimrc

" Neovim-specific configurations can go below this line
" (Currently empty - add as needed)

" Neovim-specific local overrides
if filereadable(expand("~/.config/nvim/local.vim"))
  source ~/.config/nvim/local.vim
endif
