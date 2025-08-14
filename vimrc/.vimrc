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
Plug 'tpope/vim-commentary'          " Easy commenting
Plug 'tpope/vim-surround'            " Surround text with quotes, brackets, etc.
Plug 'jiangmiao/auto-pairs'          " Auto-complete brackets and quotes
Plug 'dense-analysis/ale'            " Async linting and fixing
Plug 'airblade/vim-gitgutter'        " Show git changes in gutter
Plug 'mattn/emmet-vim'               " HTML/CSS expansion
Plug 'preservim/tagbar'              " Code structure viewer
Plug 'vim-scripts/ReplaceWithRegister' " Replace with register content
Plug 'christoomey/vim-tmux-navigator' " Tmux integration
Plug 'mg979/vim-visual-multi'        " Multiple cursors
Plug 'wellle/targets.vim'            " Additional text objects
Plug 'machakann/vim-highlightedyank' " Highlight yanked text
Plug 'easymotion/vim-easymotion'     " Enhanced motion
Plug 'goolord/alpha-nvim'               " Beautiful startup screen (Neovim)
Plug 'mhinz/vim-startify'              " Beautiful startup screen (Vim fallback)

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
set sidescrolloff=5
set hidden                           " Allow switching buffers without saving
set backspace=indent,eol,start       " Better backspace behavior
set wildmenu                         " Enhanced command completion
set wildmode=longest:full,full
set ignorecase                       " Case insensitive search
set hlsearch                         " Highlight search results
set cursorline                       " Highlight current line
set mouse=a                          " Enable mouse support
set clipboard=unnamed,unnamedplus    " Use system clipboard for both + and * registers
set undofile                         " Persistent undo
set undodir=~/.vim/undodir
set backup
set backupdir=~/.vim/backup
set directory=~/.vim/swap
set updatetime=250                   " Faster completion
set signcolumn=yes                   " Always show sign column
set completeopt=menuone,noselect     " Better completion experience
set splitbelow splitright            " Better split behavior

" Key mappings
let mapleader = " "
inoremap kj <Esc>
nnoremap <C-p> :Files %:p:h<CR>
nnoremap <leader>ff :Files<CR>
nnoremap <leader>fg :Rg<CR>
nnoremap <leader>fb :Buffers<CR>
nnoremap <leader>fh :History<CR>
nnoremap <leader>t :TagbarToggle<CR>
nnoremap <leader>n :NERDTreeToggle<CR>
nnoremap <leader>g :GitGutterToggle<CR>
nnoremap <C-h> <C-w>h
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-l> <C-w>l
nnoremap <leader>w :w<CR>
nnoremap <leader>q :q<CR>
nnoremap <leader>wq :wq<CR>
nnoremap <leader>x :x<CR>
" Clear search highlighting
nnoremap <leader>/ :nohlsearch<CR>
" Better indenting
vnoremap < <gv
vnoremap > >gv
" Move lines up/down
nnoremap <A-j> :m .+1<CR>==
nnoremap <A-k> :m .-2<CR>==
inoremap <A-j> <Esc>:m .+1<CR>==gi
inoremap <A-k> <Esc>:m .-2<CR>==gi
vnoremap <A-j> :m '>+1<CR>gv=gv
vnoremap <A-k> :m '<-2<CR>gv=gv

filetype plugin indent on

" Show trailing whitespaces
autocmd ColorScheme * highlight WhiteSpaces ctermbg=red guibg=#fab387
autocmd InsertEnter,InsertLeave,BufWinEnter * match WhiteSpaces /\s\+$/

" Create necessary directories
if !isdirectory($HOME.'/.vim/undodir')
    call mkdir($HOME.'/.vim/undodir', 'p')
endif
if !isdirectory($HOME.'/.vim/backup')
    call mkdir($HOME.'/.vim/backup', 'p')
endif
if !isdirectory($HOME.'/.vim/swap')
    call mkdir($HOME.'/.vim/swap', 'p')
endif

" Auto commands
autocmd BufWritePre * :%s/\s\+$//e     " Remove trailing whitespace on save
autocmd BufRead,BufNewFile *.md setlocal wrap linebreak nolist  " Better markdown editing

" macOS clipboard integration
if has('macunix')
    " Enhanced clipboard integration for macOS
    function! OSCYank(text)
        let encoded = system('base64', a:text)
        let encoded = substitute(encoded, '\n', '', 'g')
        call writefile(["\e]52;c;" . encoded . "\e\\"], '/dev/tty', 'b')
    endfunction

    " Copy to macOS clipboard and clipboard history
    function! CopyToMacClipboard()
        let @+ = @"
        let @* = @"
        " Use pbcopy to ensure it goes to macOS clipboard history
        call system('pbcopy', @")
        echo "Copied to clipboard and clipboard history!"
    endfunction

    " Auto-copy yanked text to macOS clipboard
    autocmd TextYankPost * call CopyToMacClipboard()
endif

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

" ALE (Async Lint Engine) settings
let g:ale_linters = {
\   'javascript': ['eslint'],
\   'python': ['flake8', 'pylint'],
\   'go': ['gofmt', 'golint'],
\   'rust': ['rustfmt', 'rls'],
\   'cpp': ['clang'],
\   'c': ['clang'],
\}
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'python': ['autopep8'],
\   'go': ['gofmt'],
\   'rust': ['rustfmt'],
\   'cpp': ['clang-format'],
\   'c': ['clang-format'],
\}
let g:ale_fix_on_save = 1
let g:ale_sign_error = '❌'
let g:ale_sign_warning = '⚠️'

" GitGutter settings
let g:gitgutter_enabled = 1
let g:gitgutter_map_keys = 0
let g:gitgutter_highlight_lines = 0
let g:gitgutter_sign_added = '+'
let g:gitgutter_sign_modified = '~'
let g:gitgutter_sign_removed = '-'

" Emmet settings
let g:user_emmet_leader_key = '<C-e>'
let g:user_emmet_install_global = 0
autocmd FileType html,css,javascript,typescript EmmetInstall

" Tagbar settings
let g:tagbar_autofocus = 1
let g:tagbar_compact = 1
let g:tagbar_sort = 0

" HighlightedYank settings
let g:highlightedyank_highlight_duration = 300

" EasyMotion settings
let g:EasyMotion_do_mapping = 0
let g:EasyMotion_smartcase = 1
map <Leader>s <Plug>(easymotion-overwin-f2)
map <Leader>j <Plug>(easymotion-j)
map <Leader>k <Plug>(easymotion-k)

" Auto-pairs settings
let g:AutoPairs = {'(':')', '[':']', '{':'}','"':'"', "'":"'"}

" Visual Multi (multiple cursors) settings
let g:VM_maps = {}
let g:VM_maps['Find Under'] = '<C-d>'
let g:VM_maps['Find Subword Under'] = '<C-d>'
let g:VM_maps['Select All'] = '<C-S-d>'
let g:VM_maps['Skip Region'] = '<C-x>'
let g:VM_maps['Remove Region'] = '<C-p>'

" Startify (Beautiful Startup Screen) settings
let g:startify_session_dir = '~/.vim/session'
let g:startify_lists = [
          \ { 'type': 'bookmarks', 'header': ['   Quick Access'] },
          \ { 'type': 'commands',  'header': ['   Commands'] },
          \ ]

let g:startify_bookmarks = [
            \ { 'i': '~/.vimrc' },
            \ { 'z': '~/.zshrc' },
            \ { 'd': '~/Developer' },
            \ ]

let g:startify_commands = [
            \ { 'up': [ 'Update Plugins', ':PlugUpdate' ] },
            \ { 'ug': [ 'Upgrade Plugin Manager', ':PlugUpgrade' ] },
            \ ]

let g:startify_custom_header = [
        \ '                         ██╗   ██╗██╗███╗   ███╗',
        \ '                         ██║   ██║██║████╗ ████║',
        \ '                         ██║   ██║██║██╔████╔██║',
        \ '                         ╚██╗ ██╔╝██║██║╚██╔╝██║',
        \ '                          ╚████╔╝ ██║██║ ╚═╝ ██║',
        \ '                           ╚═══╝  ╚═╝╚═╝     ╚═╝',
        \ '',
        \ '                              Key Mappings',
        \ '        ┌─────────────────────────────────────────────────────────────┐',
        \ '        │  kj              → <Esc> (Exit insert mode)                │',
        \ '        │  <leader>ff      → Find files                              │',
        \ '        │  <leader>fg      → Find grep (search in files)            │',
        \ '        │  <leader>fb      → Find buffers                            │',
        \ '        │  <leader>fh      → Find history                            │',
        \ '        │  <leader>n       → Toggle NERDTree                        │',
        \ '        │  <leader>t       → Toggle Tagbar                          │',
        \ '        │  <leader>g       → Toggle GitGutter                       │',
        \ '        │  <leader>w       → Save file                              │',
        \ '        │  <leader>q       → Quit                                   │',
        \ '        │  <leader>/       → Clear search highlighting              │',
        \ '        │  <C-h/j/k/l>     → Navigate windows                       │',
        \ '        │  f/F             → Sneak motion                           │',
        \ '        │  <leader>s       → EasyMotion search                      │',
        \ '        └─────────────────────────────────────────────────────────────┘',
        \ '',
        \]

let g:startify_custom_footer = [
        \ '',
        \ '              🚀 Ready to code? Let''s build something amazing! 🚀',
        \ '',
        \]

let g:startify_session_autoload = 1
let g:startify_session_delete_buffers = 1
let g:startify_change_to_vcs_root = 1
let g:startify_fortune_use_unicode = 1
let g:startify_session_persistence = 1
let g:startify_enable_special = 0

" Appearance -----------------------------------------------

syntax on
set noshowmode
let g:lightline = {'colorscheme': 'catppuccin_mocha'}
colorscheme catppuccin_mocha
set termguicolors

" Font weight improvements (more subtle approach)
if has('gui_running') || has('termguicolors')
    " Only make key elements slightly bolder without breaking colorscheme
    autocmd ColorScheme catppuccin_mocha highlight Function gui=bold
    autocmd ColorScheme catppuccin_mocha highlight Keyword gui=bold
    autocmd ColorScheme catppuccin_mocha highlight Type gui=bold
    autocmd ColorScheme catppuccin_mocha highlight CursorLineNr gui=bold

    " Improve readability without overdoing it
    autocmd ColorScheme catppuccin_mocha highlight Normal gui=NONE
    autocmd ColorScheme catppuccin_mocha highlight Comment gui=italic
endif
