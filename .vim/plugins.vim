" Vundle {{{

" set nocompatible
" filetype off

" Specify a directory for plugins
" - For Neovim: stdpath('data') . '/plugged'
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

Plug 'VundleVim/Vundle.vim'
" Utils
Plug 'jiangmiao/auto-pairs' " Better pair insertion
Plug 'AndrewRadev/switch.vim' " Lazy <space>-
Plug 'haya14busa/incsearch.vim'
Plug 'haya14busa/incsearch-easymotion.vim'
Plug 'haya14busa/incsearch-fuzzy.vim'
Plug 'tpope/vim-surround' " Use n:cs({ v:S) n:ds) n:ysiw]
Plug 'junegunn/vim-easy-align' " <space>a*=
Plug 'lfilho/cosco.vim' " <space>;
Plug 'tpope/vim-sensible'
Plug 'tpope/vim-repeat' " Fix . for plugins
" Plugin 'mileszs/ack.vim'
Plug 'Valloric/ListToggle' " <space>tl / tq
" Auto Complete
Plug 'Valloric/YouCompleteMe'
Plug 'mattn/emmet-vim'
Plug 'honza/vim-snippets'
Plug 'SirVer/ultisnips'
Plug 'xolox/vim-easytags'
Plug 'xolox/vim-misc'
" Move
Plug 'Lokaltog/vim-easymotion'
Plug 'terryma/vim-multiple-cursors'
Plug 'tpope/vim-unimpaired'
Plug 'tmux-plugins/vim-tmux-focus-events'
" Syntax
Plug 'cakebaker/scss-syntax.vim'
Plug 'ap/vim-css-color'
Plug 'peterhoeg/vim-qml'
Plug 'pboettch/vim-cmake-syntax'
Plug 'baskerville/vim-sxhkdrc'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'octol/vim-cpp-enhanced-highlight'
" Visual Candy
Plug 'luochen1990/rainbow'
let g:rainbow_active = 1
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'ryanoasis/vim-devicons'
" Plugin 'severin-lemaignan/vim-minimap'
Plug 'junegunn/goyo.vim'
" Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
" Plug 'Xuyuanp/nerdtree-git-plugin'
" Navigation
" Plugin 'tpope/vim-vinegar'
Plug 'scrooloose/nerdtree'
Plug 'vim-scripts/taglist.vim'
Plug 'junegunn/fzf.vim'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'christoomey/vim-tmux-navigator'
" Comments
Plug 'scrooloose/nerdcommenter'
Plug 'vim-scripts/DoxygenToolkit.vim'
" Git
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
Plug 'wikitopian/hardmode'

" Initialize plugin system
call plug#end()
" filetype plugin indent on
" syntax enable

" }}}

" Markdown {{{

nnoremap <space>tm :Toc<cr>

" }}}

" auto-pair {{{


" }}}

" Airline {{{

let g:airline#extensions#tabline#enabled = 1
let g:airline_powerline_fonts = 1
let g:airline_theme='minimalist'
" let g:airline_theme='dark'

" }}}

" Cosco {{{

autocmd FileType javascript,css,cpp nmap <silent> <Leader>; <Plug>(cosco-commaOrSemiColon)
autocmd FileType javascript,css,cpp imap <silent> <Leader>; <c-o><Plug>(cosco-commaOrSemiColon)

" }}}

" Switch {{{

let g:switch_mapping = "<leader>-"

" }}}

" Goyo {{{

map <leader>F :Goyo<CR>

" }}}

" EasyMotion {{{

nmap <C-f> <Plug>(easymotion-overwin-f)
nmap <C-t> <Plug>(easymotion-overwin-f)

function! s:config_easyfuzzymotion(...) abort
  return extend(copy({
  \   'converters': [incsearch#config#fuzzyword#converter()],
  \   'modules': [incsearch#config#easymotion#module({'overwin': 1})],
  \   'keymap': {"\<CR>": '<Over>(easymotion)'},
  \   'is_expr': 0,
  \   'is_stay': 1
  \ }), get(a:, 1, {}))
endfunction

noremap <silent><expr> <Space><Space>/ incsearch#go(<SID>config_easyfuzzymotion())

" map /  <Plug>(incsearch-forward)
" map ?  <Plug>(incsearch-backward)
" map g/ <Plug>(incsearch-stay)

map ?  <Plug>(incsearch-backward)
map / <Plug>(incsearch-stay)

set hlsearch
let g:incsearch#auto_nohlsearch = 1
map n  <Plug>(incsearch-nohl-n)
map N  <Plug>(incsearch-nohl-N)
map *  <Plug>(incsearch-nohl-*)
map #  <Plug>(incsearch-nohl-#)
map g* <Plug>(incsearch-nohl-g*)
map g# <Plug>(incsearch-nohl-g#)

" }}}

" Nerd Commenter {{{

" Add spaces after comment delimiters by default
let g:NERDSpaceDelims = 1
" Use compact syntax for prettified multi-line comments
let g:NERDCompactSexyComs = 1
" Align line-wise comment delimiters flush left instead of following code indentation
let g:NERDDefaultAlign = 'left'
" Allow commenting and inverting empty lines (useful when commenting a region)
let g:NERDCommentEmptyLines = 1
" Enable trimming of trailing whitespace when uncommenting
let g:NERDTrimTrailingWhitespace = 1
let g:NERDCommenterToggle = '<leader>/'
" nnoremap <leader>/ <Plug>NERDCommenterToggle'n', 'Toggle')<Cr>
nmap <C-_>   <Plug>NERDCommenterToggle
vmap <C-_>   <Plug>NERDCommenterToggle gv
" Doxygen
nnoremap <leader>cd :Dox<CR>

" }}}

" Nerd Tree {{{

let g:NERDTreeMapActivateNode='l'
let g:NERDTreeMapJumpNextSibling='J'
let g:NERDTreeMapJumpPrevSibling='K'
let g:NERDTreeMapOpenVSplit='v'

map <F4> :NERDTreeFind<CR>
map <leader>tf :NERDTreeToggle<CR>

" Open NerdTree when no file is selected
" autocmd StdinReadPre * let s:std_in=1
" autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

" Open NerdTree when opening a dir
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif

" }}}

" You Complete Me (ycm) {{{

let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'
let g:ycm_seed_identifiers_with_syntax = 1
" Place errors in location list
let g:ycm_always_populate_location_list = 1
let g:ycm_add_preview_to_completeopt = 1
let g:ycm_autoclose_preview_window_after_insertion = 1
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_complete_in_comments = 1
let g:ycm_confirm_extra_conf = 0
let g:ycm_max_diagnostics_to_display = 0

nnoremap <leader>yf :YcmCompleter FixIt<CR>
nnoremap <leader>yt :YcmCompleter GetType<CR>
nnoremap gd <C-]>
nnoremap gh :YcmCompleter GoToDeclaration<CR>

" }}}

" UltiSnips {{{

let g:UltiSnipsExpandTrigger = '<C-j>'
let g:UltiSnipsJumpForwardTrigger = '<C-j>'
let g:UltiSnipsJumpBackwardTrigger = '<C-k>'
let g:UltiSnipsListSnippets = '<C-l>'
let g:user_emmet_expandabbr_key = '<leader><tab>'

" }}}

" Easy Align {{{

map <leader>a <Plug>(EasyAlign)

" }}}

" Fugitive {{{

nnoremap <leader>gp V:'<,'>diffput<CR>
vnoremap <leader>gp :'<,'>diffput<CR>

nnoremap <leader>gs :Gstatus<CR>

" }}}

" Surround {{{

nnoremap <leader>si ys
nnoremap <leader>sc cs
nnoremap <leader>sd ds
vnoremap <leader>s S

" }}}

" Taglist {{{

" Toggle taglist
let Tlist_Use_Right_Window   = 1
let Tlist_WinWidth = 50
nnoremap <leader>tt :TlistToggle<CR>

let g:lt_location_list_toggle_map = '<leader>tl'
let g:lt_quickfix_list_toggle_map = '<leader>tq'
let g:lt_height = 10

" }}}

" Easy Tags {{{

let g:easytags_async = 1
let g:easytags_opts = ['--fields=+l']

set tags=tags;
let g:easytags_dynamic_files = 1

" }}}

" fzf {{{

nnoremap <C-P> :Files<CR>

" }}}

" ack {{{

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" }}}
