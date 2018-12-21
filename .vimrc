syntax on

set tabstop=4
set softtabstop=4
set shiftwidth=4
set expandtab
set autoindent

set number
set showcmd

set wildmenu
set lazyredraw
set showmatch

set incsearch
set hlsearch

let mapleader=","

set listchars=eol:¬,tab:>·,trail:~,extends:>,precedes:<,space:␣

nnoremap <leader><space> :nohlsearch<CR>
nnoremap / /\c
noremap <F2> :NERDTreeToggle<CR>
noremap <C-h> <C-w>h
noremap <C-j> <C-w>j
noremap <C-k> <C-w>k
noremap <C-l> <C-w>l

noremap zl gt
noremap zh gT

inoremap jk <ESC>

nnoremap <leader>s :Ag <C-R><C-W><CR>
nnoremap <expr> <leader>/ ":Ag ".input("Search term: ")."<CR>"

nnoremap <leader>f :FZF<CR>

if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/bundle')

Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'vim-airline/vim-airline'
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive', { 'on': [] }
Plug 'tomasr/molokai'
Plug 'sheerun/vim-polyglot'

command! Gstatus call LazyLoadFugitive('Gstatus')
command! Gdiff call LazyLoadFugitive('Gdiff')
command! Glog call LazyLoadFugitive('Glog')
command! Gblame call LazyLoadFugitive('Gblame')

function! LazyLoadFugitive(cmd)
  call plug#load('vim-fugitive')
  call fugitive#detect(expand('%:p'))
  exe a:cmd
endfunction

call plug#end()

if filereadable(glob('~/.vim/bundle/molokai/colors/molokai.vim'))
    colorscheme molokai
    " molokai's paren matching is messed up for some terminals
    hi MatchParen ctermfg=yellow ctermbg=233 cterm=bold
else
    colorscheme slate
endif

if exists('+colorcolumn')
    set colorcolumn=100
endif
