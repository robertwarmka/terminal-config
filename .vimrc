syntax enable
set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab

set number
set showcmd
set wildmenu
set lazyredraw
set showmatch
set incsearch
set hlsearch

filetype indent on

let mapleader=","

if executable('ag')
    set grepprg=ag
endif

" Search is case-insensitive by default
nnoremap / /\c
" Highlight mapping
nnoremap <leader><space> :nohlsearch<CR>
" Window-moving mappings
nnoremap <C-h> <C-W>h
nnoremap <C-j> <C-W>j
nnoremap <C-k> <C-W>k
nnoremap <C-l> <C-W>l
" NERDTree mapping
nnoremap <F2> :NERDTreeToggle<CR>
" FZF mapping
nnoremap <leader>f :FZF<CR>
" Grep mappings - search current word, input search term
nnoremap <leader>s :grep '<C-R><C-W>' *<CR>:cw<CR>
nnoremap <expr> <leader>/ ':grep '.input("Search term: ").' * <CR>:cw<CR>'
" Quickfix mappings
nnoremap <leader>j :cnext<CR>
nnoremap <leader>k :cprev<CR>
nnoremap <leader>q :ccl<CR>
nnoremap <leader>o :cope<CR>

call plug#begin('~/.vim/plugged')

Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-airline/vim-airline'
Plug 'rakr/vim-one'
Plug 'tomasr/molokai'

call plug#end()

if filereadable(glob('~/.vim/plugged/vim-one/colors/one.vim'))
    colorscheme one
    set background=dark
else
    colorscheme slate
endif
