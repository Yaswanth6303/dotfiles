"  __   __ __   __    __    ____    ______
" /\ \ / //\ \ /\ "-./  \ /\  == \ /\  ___\
" \ \ \'/ \ \ \\ \ \-./\ \\ \  __< \ \ \____
"  \ \__|  \ \_\\ \_\ \ \_\\ \_\ \_\\ \_____\
"   \/_/    \/_/ \/_/  \/_/ \/_/ /_/ \/_____/


" Plugins --------------------------------------------------

" Download vim-plug
let data_dir = has('nvim') ? stdpath('data') . '/site' : '~/.vim'
if empty(glob(data_dir . '/autoload/plug.vim'))
    silent execute '!curl -fLo '.data_dir.'/autoload/plug.vim --create-dirs  https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'
    autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')

Plug 'catppuccin/vim', { 'as': 'catppuccin' }
Plug 'preservim/nerdtree'
Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
Plug 'cohama/lexima.vim'
Plug 'ryanoasis/vim-devicons'
Plug 'justinmk/vim-sneak'
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'tpope/vim-fugitive'
Plug 'Yggdroot/indentLine'
Plug 'alvan/vim-closetag'
Plug 'itchyny/lightline.vim'
Plug 'ap/vim-css-color'
Plug 'jayli/vim-easycomplete'
Plug 'SirVer/ultisnips'

call plug#end()

" General Settings -----------------------------------------

let &t_SI = "\e[6 q"
let &t_EI = "\e[2 q"
set noerrorbells
set tabstop=4 softtabstop=4
set shiftwidth=4
set expandtab
set smartindent
set number relativenumber
set nu rnu
set smartcase
set incsearch
set nowrap
set laststatus=2
set lazyredraw
set scrolloff=3
inoremap kj <Esc>
nnoremap <C-p> :Files %:p:h<CR>
filetype plugin indent on

" Show trailing whitespaces
autocmd ColorScheme * highlight WhiteSpaces ctermbg=red guibg=#fab387
autocmd InsertEnter,InsertLeave,BufWinEnter * match WhiteSpaces /\s\+$/

" Plugins Settings ------------------------------------------

" Start NERDTree when Vim starts with a directory argument.
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists('s:std_in') |
    \ execute 'NERDTree' argv()[0] | wincmd p | enew | execute 'cd '.argv()[0] | endif

" Open the existing NERDTree on each new tab.
autocmd BufWinEnter * if getcmdwintype() == '' | silent NERDTreeMirror | endif

" Remap f/F to sneak and enable label-mode
map f <Plug>Sneak_s
map F <Plug>Sneak_S
let g:sneak#label = 1

" Remap f/F to sneak and enable label-mode
map f <Plug>Sneak_s
map F <Plug>Sneak_S
let g:sneak#label = 1

" Close html tags in these file extensions
let g:closetag_filenames = '*.html, *.xml, *.ts, *.tsx'

" Appearance -----------------------------------------------

syntax on
set noshowmode
let g:lightline = {'colorscheme': 'catppuccin_mocha'}
colorscheme catppuccin_mocha
set termguicolors
