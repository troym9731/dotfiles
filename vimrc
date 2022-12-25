set nocompatible
filetype off
set t_Co=256

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'sheerun/vim-polyglot'
Plug 'christoomey/vim-tmux-navigator'

call plug#end()

syntax enable
filetype plugin indent on

" The next two settings help in performance, especially in ruby files
" `regexpengine` is set to an old engine that is better at parsing ruby files
set regexpengine=1
set lazyredraw

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

""""" Beginning of some mappings for Leader Key

" Map leader to SPACE key
let mapleader = "\<Space>"

" Map fzf.vim ':Files'
nnoremap <Leader>o :Files<CR>

" Map fzf.vim ':Buffers'
nnoremap <Leader>b :Buffers<CR>

" Map fzf.vim ':Rg' for file searching
nnoremap <Leader>l :Rg<CR>

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

" Get rid of any styling on the line numbers
highlight clear CursorLineNR

let g:delimitMate_expand_cr=1
let g:delimitMate_expand_space=1
let g:jsx_ext_required = 0
let g:vim_json_syntax_conceal = 0
let g:ctrlp_show_hidden = 1

" Enable code blocks in markdown to be highlighted e.g. ```js
let g:markdown_fenced_languages = ['html', 'javascript', 'js=javascript', 'ruby', 'css', 'sass']

" Not sure why yet, but this is necessary to use `crontab`
autocmd filetype crontab setlocal nobackup nowritebackup

set noswapfile
set nobackup nowritebackup
set undodir=~/.vim/undo//
set undofile
set undolevels=1000
set undoreload=10000
