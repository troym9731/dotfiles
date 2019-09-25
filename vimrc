set nocompatible
filetype off
set t_Co=256

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'VundleVim/Vundle.vim'
" Plugin 'bling/vim-airline'
Plugin 'kien/ctrlp.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-repeat'
Plugin 'reedes/vim-thematic'
Plugin 'tpope/vim-fugitive'
Plugin 'jisaacks/GitGutter'
Plugin 'Raimondi/delimitMate'
Plugin 'tpope/vim-rails'
Plugin 'othree/yajs.vim'
Plugin 'mxw/vim-jsx'
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'Xuyuanp/nerdtree-git-plugin'
Plugin 'elzr/vim-json'
Plugin 'mhartington/oceanic-next'
Plugin 'gavocanov/vim-js-indent'
Plugin 'moll/vim-node'
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()
syntax enable
filetype plugin indent on

colorscheme elflord

""""" Beginning of some mappings for Leader Key

" Map leader to SPACE key
let mapleader = "\<Space>"

" Map CtrlP to Leader o
nnoremap <Leader>o :CtrlP<CR>

" Toggle NerdTree to Leader e
nnoremap <Leader>e :NERDTreeToggle<CR>

" Map system clipboard
vmap <Leader>y "+y
nmap <Leader>p "+p
nmap <Leader>P "+P
vmap <Leader>p "+p
vmap <Leader>P "+P

" Map vertical and horizontal splitting
nmap <Leader>\ :vsplit<CR>
nmap <Leader>- :split<CR>

" Map closing a split
nmap <Leader>d :close<CR>

" Map previous buffer
nmap <Leader>s :b#<CR>

"""""""""""""" End of Leader Key common mappings

set backspace=indent,eol,start
set relativenumber number
set hidden
set tabstop=2
set shiftwidth=2
set expandtab
set mouse=a
set background=dark
set autoread
set modifiable
set nowrap
set ignorecase smartcase
set tags+=tags
set incsearch

" Set where splits appear (which feels more natural)
set splitbelow
set splitright

let g:delimitMate_expand_cr=1
let g:delimitMate_expand_space=1
let g:jsx_ext_required = 0
let g:vim_json_syntax_conceal = 0
let g:ctrlp_show_hidden = 1

" Enable code blocks in markdown to be highlighted e.g. ```js
let g:markdown_fenced_languages = ['html', 'javascript', 'js=javascript', 'ruby', 'css', 'sass']

" Not sure why yet, but this is necessary to use `crontab`
autocmd filetype crontab setlocal nobackup nowritebackup

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set undolevels=1000
set undoreload=10000
