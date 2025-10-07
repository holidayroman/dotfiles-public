set nocompatible
filetype off

"""""""""""
" Plugins "
"""""""""""
" Auto-install vim-plug if not installed
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

" Colorscheme
Plug 'morhetz/gruvbox'

" Status line (lightweight, works in vim and neovim)
Plug 'itchyny/lightline.vim'

" File explorer
Plug 'preservim/nerdtree'

" Language server and autocompletion
Plug 'neoclide/coc.nvim', {'branch': 'release'}

" Git integration
Plug 'airblade/vim-gitgutter'

" Fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

" Linting and fixing
Plug 'dense-analysis/ale'

" Text manipulation
Plug 'tpope/vim-surround'
Plug 'jiangmiao/auto-pairs'

" Movement
Plug 'easymotion/vim-easymotion'

" EditorConfig support
Plug 'editorconfig/editorconfig-vim'

" Language support
Plug 'sheerun/vim-polyglot'

call plug#end()

""""""""""""""""""
" Plugin Config "
""""""""""""""""""
"""""""""""
" General "
"""""""""""
let mapleader = " "     " set leader key to space
filetype plugin on
set encoding=utf8       " force utf8 encoding
set visualbell          " use visual bell
set mouse=a             " enables mouse handling
set backspace=2         " allow backspacing over indent, eol, and start

" NerdTree mappings
nmap <leader>n :NERDTreeToggle<CR>  " Space+n: toggle file explorer

" NerdTree config
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.DS_Store$', 'node_modules']
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1

" CoC extensions to auto-install
let g:coc_global_extensions = ['coc-tsserver', 'coc-pyright', 'coc-rust-analyzer']

" CoC config - Tab completion
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"      " Tab: next completion
inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"  " Shift+Tab: prev completion
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"      " Enter: accept completion
nmap <silent> gd <Plug>(coc-definition)     " gd: go to definition
nmap <silent> gr <Plug>(coc-references)     " gr: find references

" FZF mappings
nmap <C-p> :Files<CR>           " Ctrl+p: fuzzy find files by name
nmap <leader>b :Buffers<CR>     " Space+b: list open buffers
nmap <leader>f :Rg<CR>          " Space+f: search file contents (ripgrep)
nmap <leader>t :Tags<CR>        " Space+t: search tags (requires ctags)

" Make Rg respect .gitignore and exclude .git directory
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --glob "!.git" '.shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview(),
  \   <bang>0)

" Window navigation
nnoremap <C-h> <C-w>h  " Ctrl+h: move to left window
nnoremap <C-j> <C-w>j  " Ctrl+j: move to bottom window
nnoremap <C-k> <C-w>k  " Ctrl+k: move to top window
nnoremap <C-l> <C-w>l  " Ctrl+l: move to right window

" Convenience mappings
map <Leader>ws :w !sudo tee %  " Space+ws: save file with sudo
imap jk <ESC>                  " jk: exit insert mode (alternative to ESC)
map ; :                        " ;: enter command mode (no shift needed)
map <leader>q :q<CR>           " Space+q: quit
map <leader>w :w<CR>           " Space+w: save
map <leader>wq :wq<CR>         " Space+wq: save and quit
map <leader>j <C-f>            " Space+j: page down
map <leader>k <C-b>            " Space+k: page up

" Easymotion mappings (override default f/F)
map f <Plug>(easymotion-bd-f)  " f: jump to any character on screen
map F <Plug>(easymotion-bd-w)  " F: jump to any word on screen
"""""""""""""""""
" Style Options "
"""""""""""""""""
syntax on               " enable syntax highlighting
set nospell             " disable spell checking by default
set number              " line numbers
set cursorline          " current line indicator
set scrolloff=8         " adds padding to the current line
set showmatch           " highlights matching bracket
set signcolumn=yes      " always show sign column

" Terminal and color settings
set termguicolors       " enable true color support
set t_Co=256

" Colorscheme
set background=dark
try
  colorscheme gruvbox
catch
  colorscheme default
endtry

set laststatus=2
set noshowmode          " hide the current mode (lightline shows it)
set ttimeoutlen=100

" Lightline
let g:lightline = {
      \ 'colorscheme': 'gruvbox',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'readonly', 'filename', 'modified' ] ],
      \   'right': [ [ 'lineinfo' ],
      \              [ 'percent' ],
      \              [ 'fileformat', 'fileencoding', 'filetype' ] ]
      \ },
      \ }


"""""""""""""""""""""""""""
" Indentation and spacing "
"""""""""""""""""""""""""""
set smartindent         " usually does what we want
set expandtab           " spaces instead of tabs
set smarttab            " interprets consecutive spaces as tabs
set shiftwidth=2        " tab = 4 spaces
set softtabstop=2
set nowrap              " disables line wrapping

"""""""""""""
" Searching "
"""""""""""""
set incsearch           " incremental searching
set hlsearch            " highlight matching results
set ignorecase          " ignore case in search
set smartcase           " override ignorecase if capital letter is used

"""""""""""""""""""
" Command options "
"""""""""""""""""""
set showcmd             " shows command information at bottom
set wildmenu            " autocomplete commands


"""""""""""""""""""
" Local Overrides "
"""""""""""""""""""
if filereadable(expand("~/.vimrc.local"))
  source ~/.vimrc.local
endif
