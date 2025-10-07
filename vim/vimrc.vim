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
let mapleader = " "
filetype plugin on
set encoding=utf8       " force utf8 encoding
set visualbell          " use visual bell
set mouse=a             " enables mouse handling
set backspace=2         " allow backspacing over indent, eol, and start
if !has('nvim')
  set pastetoggle=<F2>  " map key for toggling pastemode (vim only, neovim handles paste automatically)
endif

" NerdTree mappings
nmap <leader>n :NERDTreeToggle<CR>
nmap <leader>nf :NERDTreeFind<CR>

" NerdTree config
let NERDTreeShowHidden=1
let NERDTreeIgnore=['\.git$', '\.DS_Store$', 'node_modules']
let NERDTreeMinimalUI=1
let NERDTreeDirArrows=1

" CoC config - Tab completion
inoremap <silent><expr> <TAB> coc#pum#visible() ? coc#pum#next(1) : "\<Tab>"
inoremap <silent><expr> <S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<S-Tab>"
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm() : "\<CR>"

" CoC extensions to auto-install
let g:coc_global_extensions = ['coc-tsserver', 'coc-pyright', 'coc-rust-analyzer']

" FZF mappings
nmap <C-p> :Files<CR>
nmap <leader>b :Buffers<CR>
nmap <leader>f :Rg<CR>
nmap <leader>t :Tags<CR>

" Make Rg respect .gitignore and exclude .git directory
command! -bang -nargs=* Rg
  \ call fzf#vim#grep(
  \   'rg --column --line-number --no-heading --color=always --smart-case --glob "!.git" '.shellescape(<q-args>),
  \   1,
  \   fzf#vim#with_preview(),
  \   <bang>0)

" Convenience mappings
map <Leader>ws :w !sudo tee %
imap jk <ESC>
map ; :
map <leader>q :q<CR>
map <leader>w :w<CR>
map <leader>wq :wq<CR>
map <leader>j <C-f>
map <leader>k <C-b>

" Easymotion mappings (override default f/F)
map f <Plug>(easymotion-bd-f)
map F <Plug>(easymotion-bd-w)
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
