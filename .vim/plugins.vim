" Vundle {{{

set nocompatible
filetype off

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" Utils
Plugin 'jiangmiao/auto-pairs' " Better pair insertion
Plugin 'AndrewRadev/switch.vim' " Lazy <space>-
Plugin 'sickill/vim-pasta' " Better indentation when pasting
Plugin 'liuchengxu/vim-better-default'
Plugin 'tpope/vim-surround' " Use n:cs({ v:S) n:ds) n:ysiw]
Plugin 'junegunn/vim-easy-align' " <space>a*=
Plugin 'lfilho/cosco.vim' " <space>;
Plugin 'tpope/vim-repeat' " Fix . for plugins
" Plugin 'mileszs/ack.vim'
Plugin 'Valloric/ListToggle' " <space>tl / tq
" Auto Complete
Plugin 'Valloric/YouCompleteMe'
Plugin 'mattn/emmet-vim'
Plugin 'honza/vim-snippets'
Plugin 'SirVer/ultisnips'
" Move
Plugin 'Lokaltog/vim-easymotion'
Plugin 'terryma/vim-multiple-cursors'
Plugin 'tpope/vim-unimpaired'
" Syntax
Plugin 'cakebaker/scss-syntax.vim'
Plugin 'ap/vim-css-color'
Plugin 'peterhoeg/vim-qml'
Plugin 'pboettch/vim-cmake-syntax'
Plugin 'baskerville/vim-sxhkdrc'
Plugin 'godlygeek/tabular'
Plugin 'plasticboy/vim-markdown'
Plugin 'octol/vim-cpp-enhanced-highlight'
" Visual Candy
Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'edkolev/tmuxline.vim'
Plugin 'ryanoasis/vim-devicons'
" Plugin 'severin-lemaignan/vim-minimap'
Plugin 'junegunn/goyo.vim'
" Navigation
" Plugin 'tpope/vim-vinegar'
Plugin 'scrooloose/nerdtree'
Plugin 'vim-scripts/taglist.vim'
Plugin 'junegunn/fzf.vim'
Plugin 'vim-ctrlspace/vim-ctrlspace'
Plugin 'christoomey/vim-tmux-navigator'
" Comments
Plugin 'scrooloose/nerdcommenter'
Plugin 'vim-scripts/DoxygenToolkit.vim'
" Git
Plugin 'tpope/vim-fugitive'
Plugin 'airblade/vim-gitgutter'
Plugin 'wikitopian/hardmode'

call vundle#end()
filetype plugin indent on
syntax enable

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

" Better Default {{{

let g:vim_better_default_tabs_as_spaces = 0

" }}}

" Goyo {{{

map <leader>F :Goyo<CR>

" }}}

" EasyMotion {{{

nmap f <Plug>(easymotion-overwin-f)

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

" fzf {{{

nnoremap <C-P> :Files<CR>

" }}}

" ack {{{

if executable('ag')
  let g:ackprg = 'ag --vimgrep'
endif

" }}}
