"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => General
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" load plugins from vundle
filetype off

set rtp+=~/.vim/bundle/vundle/
call vundle#begin()

" let vundle manage vundle
Plugin 'gmarik/vundle'

" utilities
Plugin 'kien/ctrlp.vim'       " fuzzy find files
Plugin 'benmills/vimux'
Plugin 'tpope/vim-fugitive'   " the ultimate git helper
Plugin 'tpope/vim-commentary' " comment/uncomment lines with gcc
                              " or gc in visual mode
Plugin 'bling/vim-airline'
Plugin 'airblade/vim-gitgutter'
Plugin 'davidhalter/jedi-vim'

Plugin 'tpope/vim-markdown'

Plugin 'vim-scripts/SyntaxRange'

" colorschemes
Plugin 'chriskempson/base16-vim'

" JavaScript plugins
Plugin 'pangloss/vim-javascript'
Plugin 'jelera/vim-javascript-syntax'

" Snippets
Plugin 'MarcWeber/vim-addon-mw-utils'
Plugin 'tomtom/tlib_vim'
Plugin 'garbas/vim-snipmate'

call vundle#end()

filetype plugin indent on

set nocompatible " not compatible with vi
set autoread " detect when a file is changed

" make backspace behave in a sane manner
set backspace=indent,eol,start

" set a map leader for more key combos
let mapleader = ','

" Tab control
set expandtab " tabs ftw
set smarttab " tab respects 'tabstop', 'shiftwidth', and 'softtabstop'
set tabstop=4 " the visible width of tabs
set softtabstop=4 " edit as if the tabs are 4 characters wide
set shiftwidth=4 " number of spaces to use for indent and unindent
set shiftround " round indent to a multiple of 'shiftwidth'
set ts=4

set clipboard=unnamed

" faster redrawing
set ttyfast

" code folding settings
set foldmethod=syntax " fold based on indent
set foldnestmax=10 " deepest fold is 10 levels
set nofoldenable " don't fold by default
set foldlevel=1

" Setup backup location and enable
set backup
set backupdir=$HOME/temp/vim_backups/       "where to put those backups
set directory=$HOME/temp/vim_swp/           "this is for swp files

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => User Interface
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" Searching
set ignorecase " case insensitive searching
set smartcase " case-sensitive if expresson contains a capital letter
set hlsearch
set incsearch " set incremental search, like modern browsers
set nolazyredraw " don't redraw while executing macros

set magic " Set magic on, for regex

set showmatch " show matching braces
set mat=2 " how many tenths of a second to blink

" switch syntax highlighting on
syntax on

au BufNewFile,BufRead *.module-template set filetype=html

set encoding=utf8
let base16colorspace=256  " Access colors present in 256 colorspace"
set t_Co=256 " Explicitly tell vim that the terminal supports 256 colors"
set background=dark
colorscheme base16-monokai

set number
set relativenumber
set colorcolumn=80

set autoindent " automatically set indent of new line
set smartindent

" Change line number color
" (by default gitgutter uses same color as LineNr)
highlight LineNr ctermbg=235

set laststatus=2 " show the satus line all the time

set spelllang=en,pt_br

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Mappings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <leader>ev :e! ~/.vimrc<cr> " edit ~/.vimrc

map <leader>wc :wincmd q<cr>

" moving up and down work as you would expect
nnoremap <silent> j gj
nnoremap <silent> k gk

" + and - to resize splited windows
map - <C-W>-
map = <C-W>+

" Make tab in v mode work like I think it should (keep highlighting):
vmap <tab> >gv
vmap <s-tab> <gv

" move between the buffers
nnoremap <Leader>b :bp<CR>
nnoremap <Leader>f :bn<CR>

" helpers for dealing with other people's code
nmap \t :set ts=4 sts=4 sw=4 noet<cr>
nmap \s :set ts=4 sts=4 sw=4 et<cr>

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Functions
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

map <C-h> :call WinMove('h')<cr>
map <C-j> :call WinMove('j')<cr>
map <C-k> :call WinMove('k')<cr>
map <C-l> :call WinMove('l')<cr>

" Window movement shortcuts
" move to the window in the direction shown, or create a new window
function! WinMove(key)
    let t:curwin = winnr()
    exec "wincmd ".a:key
    if (t:curwin == winnr())
        if (match(a:key,'[jk]'))
            wincmd v
        else
            wincmd s
        endif
        exec "wincmd ".a:key
    endif
endfunction

cab trim %s/\s\+$//

"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Plugin settings
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

autocmd FileType python set ft=python.django " For SnipMate
autocmd FileType html set ft=htmldjango.html " For SnipMate

" remove trailing spaces for certain file types
autocmd FileType python,javascript,ruby,c,cpp,java,php autocmd BufWritePre <buffer> :%s/\s\+$//e

" map fuzzyfinder (CtrlP) plugin
nmap <silent> <C-p> :CtrlP<cr>
nmap <silent> <C-r> :CtrlPBuffer<cr>
let g:ctrlp_map='<c-p>'
let g:ctrlp_working_path_mode = 0
let g:ctrlp_dotfiles=1
let g:ctrlp_cmd = 'CtrlP'

set wildignore+=*/tmp/*,*.so,*.swp,*.zip,*.pyc,.DS_Store     " Linux/MacOSX
set wildignore+=*\\tmp\\*,*.swp,*.zip,*.exe                  " Windows

" CtrlP ignore patterns
let g:ctrlp_custom_ignore = {
            \ 'dir': '\.git$\|node_modules$\|\.hg$\|\.svn$',
            \ 'file': '\.exe$\|\.so$|\.pyc$'
            \ }

" search the nearest ancestor that contains .git, .hg, .svn
let g:ctrlp_working_path_mode = 2

let g:airline#extensions#tabline#enabled = 1
"let g:airline#extensions#tabline#buffer_nr_show = 1

set list          " Display unprintable characters f12 - switches
set listchars=tab:•\ ,trail:•,extends:»,precedes:« " Unprintable chars mapping

let g:airline#extensions#whitespace#enabled = 1
let g:airline#extensions#branch#enabled = 1
" put a buffer list at the top
let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts=1

" Netrw
let g:netrw_list_hide= '.*\.swp$,.*\.pyc$,\.DS_Store$'

" Jedi
