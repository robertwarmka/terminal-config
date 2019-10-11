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

set mouse=a

" Unmap mouse clicking for all(?) modes
noremap <LeftMouse> <nop>
noremap <2-LeftMouse> <nop>
noremap <3-LeftMouse> <nop>
noremap <4-LeftMouse> <nop>
noremap <4-LeftMouse> <nop>
noremap <RightMouse> <nop>
noremap <2-RightMouse> <nop>
noremap <3-RightMouse> <nop>
noremap <4-RightMouse> <nop>

inoremap <LeftMouse> <nop>
inoremap <2-LeftMouse> <nop>
inoremap <3-LeftMouse> <nop>
inoremap <4-LeftMouse> <nop>
inoremap <4-LeftMouse> <nop>
inoremap <RightMouse> <nop>
inoremap <2-RightMouse> <nop>
inoremap <3-RightMouse> <nop>
inoremap <4-RightMouse> <nop>

let mapleader=","

set listchars=tab:>-,trail:~

function! HeaderSource()
    " Determine if we're a header or source, get other potential extention
    let ext = expand('%:e') =~# '[hH][hpx+]*' ? '.[cC]*' : '.[hH]*'
    let i = 1
    while i <= 5
        " Set up expand string to get shorter paths on further iterations
        let dirstr = '%:p' . repeat(':h', i)
        let filename = expand('%:t:r')
        " If we find a matching file, open and exit loop
        let path = globpath(expand(dirstr), '**/' . filename . ext, 0, 1) " Create a list
        for item in path
            let valid = item =~# (filename . '\.[chCH][chpx+]*$') ? item : ''
            if valid != ''
                :execute 'edit' valid
                return
            endif
        endfor
        let i += 1
    endwhile
endfunction

function! ClangFormat()
    let pos = line('.')
    let formatted_buffer = system('clang-format ' . expand('%:p'))
    :1,$d
    :put =formatted_buffer
    :1,1d
    :call cursor(pos, 1)
endfunction

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

nnoremap <leader>g :FZF -q <C-R><C-W><CR>
nnoremap <leader>f :FZF<CR>

nnoremap <leader>t :tabnew<CR>

nnoremap <leader>c :call HeaderSource()<CR>

nnoremap <leader>x :call ClangFormat()<CR>

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
Plug 'kburdett/vim-nuuid'

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

" set UUID case to upper
let g:nuuid_case = "upper"

" set no mappings so we can customize ours
let g:nuuid_no_mappings = 1

function! GenIncludeGuard()
    let guard  = join(["INCLUDE_GUARD", substitute(NuuidNewUuid(), '-', '_', 'g')], "_")
    let ifndef = join(["#ifndef",   guard], " ")
    let define = join(["#define",   guard], " ")
    let endif  = join(["#endif //", guard], " ")
    " Extra empty strings included here to insert another newline before the endif
    return join([ifndef, define, "", "", "", endif], "\n")
endfunction

nnoremap <leader>u i<C-R>=GenIncludeGuard()<CR><Esc>

if filereadable(glob('~/.vim/bundle/molokai/colors/molokai.vim'))
    colorscheme molokai
    " molokai's paren matching is messed up for some terminals
    hi MatchParen ctermfg=yellow ctermbg=233 cterm=bold
else
    colorscheme slate
endif

" For wrapping text automatically
set textwidth=100

if exists('+colorcolumn')
    set colorcolumn=100
endif

" Windows WSL color refresh problem fix
if (&term =~ '^xterm' && &t_Co == 256)
    set t_ut= | set ttyscroll=1
endif
