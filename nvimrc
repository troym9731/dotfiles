function! DoRemote(arg)
  UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

" Keyword completion system: Requires python3 and pip3
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }

" Airline at the bottom of Vim
Plug 'bling/vim-airline'

" File tree
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }

" Surround characters with whatever
Plug 'tpope/vim-surround'

" Use 'gc' to comment out lines. 'gcc' for one line
Plug 'tpope/vim-commentary'

" Repeat more complicated actions, like those with vim-surround
Plug 'tpope/vim-repeat'

" Allows for file line '+' and '-' in the gutter based on Git
Plug 'mhinz/vim-signify'

" Allows for git related commands, such as 'Gblame' to see who touched which line in a file
Plug 'tpope/vim-fugitive'

" Extra functionality for vim-fugitive
Plug 'tpope/vim-rhubarb'

" Used to delimit certain things like adding spaces between '{}'
Plug 'Raimondi/delimitMate'

" Naviagte between tmux panes easily
Plug 'christoomey/vim-tmux-navigator'

" Used for asynchronous linting
Plug 'w0rp/ale'

" Language syntax
Plug 'sheerun/vim-polyglot'

" Framework/Related syntax
Plug 'tpope/vim-rails', { 'for': 'ruby' }
Plug 'tpope/vim-endwise'
" required for some navigation features of phoenix.vim
Plug 'tpope/vim-projectionist'
Plug 'c-brenn/phoenix.vim', { 'for': 'elixir' }

" Color Schemes
Plug 'trevordmiller/nova-vim'

" Emmet for Vim
Plug 'mattn/emmet-vim'

" Devicons
Plug 'ryanoasis/vim-devicons'

" Search functionality
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }

" Vim related features for fzf
Plug 'junegunn/fzf.vim'

call plug#end()

syntax enable
filetype plugin indent on

" Enable True Color
set termguicolors

colorscheme nova
set background=dark

" The next two settings help in performance, especially in ruby files
" `regexpengine` is set to an old engine that is better at parsing ruby files
set regexpengine=1
set lazyredraw

" automatically rebalance windows on vim resize
autocmd VimResized * :wincmd =

" zoom a vim pane, <C-w>= to re-balance
nnoremap <leader>- :wincmd _<cr>:wincmd \|<cr>
nnoremap <leader>= :wincmd =<cr>

" Use deoplete.
let g:deoplete#enable_at_startup = 1
" python3 for deoplete even in virtual environments
let g:python3_host_prog = '/usr/local/bin/python3'

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

""""" Beginning of some mappings for Leader Key

" Map leader to SPACE key
let mapleader = "\<Space>"

" Map fzf.vim ':Files'
nnoremap <Leader>o :Files<CR>

" Map fzf.vim ':Buffers'
nnoremap <Leader>b :Buffers<CR>

" Map fzf.vim ':Rg' for file searching
nnoremap <Leader>l :Rg<CR>

" Toggle NerdTree
nnoremap <Leader>e :NERDTreeToggle<CR>

" Reload ~/.nvimrc
nnoremap <Leader>R :so ~/.nvimrc<CR>

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

"""" INCOMING HACK
"""""""""""""""""""""""""""""""""
" Used to grab the 'backspace' event sent by C-h for Neovim to use for
" vim-tmux-navigator
nnoremap <silent> <BS> :TmuxNavigateLeft<cr>
"""""""""""""""""""""""""""""""""

""" Ale configuration
" Remove highlighting of words
let g:ale_set_highlights = 0
" Only run the checker on save and file enter
let g:ale_lint_on_text_changed = 0
" Open up window for more detailed errors
nmap <Leader>g :ALEDetail<CR>


" Enable specific linters
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'html': [],
\   'elixir': ['credo', 'mix']
\}

" Enable Ale fixers (for prettier formatting)
let g:ale_fixers = {}
let g:ale_fixers['javascript'] = ['prettier']
let g:ale_fixers['scss'] = ['prettier']
let g:ale_fixers['css'] = ['prettier']
let g:ale_fixers['html'] = ['prettier']
let g:ale_fixers['elixir'] = ['mix_format']
let g:ale_fix_on_save = 1
let g:ale_javascript_prettier_options = '--single-quote --no-semi'

"""" FZF
" [Buffers] Jump to the existing window if possible
let g:fzf_buffers_jump = 1

" Highlights the current line number (Currently provided by Nova)
" hi CursorLineNR guifg=#ffffff

" Remove the cursor line (possibly temporary)
hi CursorLine guibg=NONE guifg=NONE

set backspace=indent,eol,start
set cursorline
set noshowmode
set guifont=Hasklug\ Nerd\ Font\ Mono:h14

" Set where splits appear (which feels more natural)
set splitbelow
set splitright

" When reaching the end of the screen horizontally, it just moves it by one character
set sidescroll=1

" Sets relative line number while still showing current line number
set relativenumber number
set hidden

" 2 spaces
set tabstop=2
set shiftwidth=2

" Spaces instead of tabs
set expandtab
set mouse=a

" Allows for modifying new NERDTree buffers
set modifiable

" Turns off visual line wrapping
set nowrap

" Turns of physical line wrapping
set textwidth=0 wrapmargin=0

" Ignores case when there is none. However, when given capital letters, then use smart case
set ignorecase smartcase
set tags+=tags

" Auto read when a file is changed on disk
set autoread
au CursorHold * checktime

" Do not highlight search items
set nohlsearch

" Customize whitespace to match Nova colorscheme
highlight ExtraWhitespace guibg=#D18EC2
match ExtraWhitespace /\s\+$/
autocmd BufWinEnter * match ExtraWhitespace /\s\+$/
autocmd InsertEnter * match ExtraWhitespace /\s\+\%#\@<!$/
autocmd InsertLeave * match ExtraWhitespace /\s\+$/
autocmd BufWinLeave * call clearmatches()

" Enable highlighting for JSDoc
let g:javascript_plugin_jsdoc = 1

let g:delimitMate_expand_cr=1
let g:delimitMate_expand_space=1
let g:jsx_ext_required = 0
let g:vim_json_syntax_conceal=0

" vim-signify configuration
let g:signify_vcs_list = ['git']
highlight link SignifySignAdd GitGutterAdd
highlight link SignifySignDelete GitGutterDelete
highlight link SignifySignChange GitGutterChange
highlight SignColumn ctermbg=NONE cterm=NONE guibg=NONE gui=NONE

" Vim Airline configuration
let g:airline#extensions#tabline#enabled=1
let g:airline#extensions#tabline#fnamemod=':t'
let g:airline#extensions#tabline#show_tab_nr=1
let g:airline#extensions#ale#enabled = 1 " Allow for ale to show error messages
let g:airline_powerline_fonts=1
let g:airline_theme='nova'

" NERDTree show hidden files
let NERDTreeShowHidden=1

" elm-vim configuration
" elm-format on save
let g:elm_format_autosave = 1
" Don't have a popup with the failure
let g:elm_format_fail_silently = 1

" Enable code blocks in markdown to be highlighted e.g. ```js
let g:markdown_fenced_languages = ['html', 'javascript', 'js=javascript', 'ruby', 'css', 'sass']

" Devicons configuration
let g:WebDevIconsNerdTreeAfterGlyphPadding = ' '

" NERDTress File highlighting
function! NERDTreeHighlightFile(extension, fg, bg, guifg, guibg)
  exec 'autocmd FileType nerdtree highlight ' . a:extension .' ctermbg='. a:bg .' ctermfg='. a:fg .' guibg='. a:guibg .' guifg='. a:guifg
  exec 'autocmd FileType nerdtree syn match ' . a:extension .' #^\s\+.*'. a:extension .'$#'
endfunction

call NERDTreeHighlightFile('md', 'blue', 'none', '#83AFE5', 'none')
call NERDTreeHighlightFile('config', 'yellow', 'none', '#DADA93', 'none')
call NERDTreeHighlightFile('conf', 'yellow', 'none', '#DADA93', 'none')
call NERDTreeHighlightFile('json', 'green', 'none', '#A8CE93', 'none')
call NERDTreeHighlightFile('yml', 'green', 'none', '#A8CE93', 'none')
call NERDTreeHighlightFile('html', 'green', 'none', '#A8CE93', 'none')
call NERDTreeHighlightFile('css', 'Magenta', 'none', '#D18EC2', 'none')
call NERDTreeHighlightFile('scss', 'Magenta', 'none', '#D18EC2', 'none')
" call NERDTreeHighlightFile('js', 'Red', 'none', '#DF8C8C', 'none')
call NERDTreeHighlightFile('js', 'yellow', 'none', '#DADA93', 'none')
call NERDTreeHighlightFile('ts', 'Blue', 'none', '#6699cc', 'none')
call NERDTreeHighlightFile('ds_store', 'Gray', 'none', '#686868', 'none')
call NERDTreeHighlightFile('gitconfig', 'black', 'none', '#1E272C', 'none')
call NERDTreeHighlightFile('gitignore', 'Gray', 'none', '#6A7D89', 'none')

" Prevent Emmet from creating global mappings
let g:user_emmet_install_global=0
autocmd FileType html,css,ejs EmmetInstall

" Not sure why yet, but this is necessary to use `crontab`
autocmd filetype crontab setlocal nobackup nowritebackup

set backupdir=~/.vim/backup//
set directory=~/.vim/swap//
set undodir=~/.vim/undo//
set undofile
set undolevels=1000
set undoreload=10000
