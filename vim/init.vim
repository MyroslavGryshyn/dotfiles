" Autoinstall vim-plug {{{
if empty(glob("~/.config/nvim/autoload/plug.vim"))
    !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif
" }}}

" Plugins {{{
call plug#begin('~/.config/nvim/plugged')

" Syntax plugins {{{
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'avakhov/vim-yaml', {'for': 'yaml'}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}
Plug 'Glench/Vim-Jinja2-Syntax', {'for': 'jinja'}
" }}}

" Autocomplete engines {{{
function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'zchee/deoplete-jedi', {'for': 'python'}
" }}}

" Integration with git {{{
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'
" }}}

" Running tests from vim {{{
Plug 'janko-m/vim-test', {'for': 'python'}
" }}}

" Python plugins {{{
Plug 'Yggdroot/indentLine', {'for': 'python'}
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'fisadev/vim-isort', {'for': 'python'}
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
Plug 'michaeljsmith/vim-indent-object', {'for': 'python'}
Plug 'yevhen-m/python-syntax', {'for': 'python'}
" }}}

" Enhance vim searching {{{
Plug 'haya14busa/vim-asterisk'
Plug 'justinmk/vim-sneak'
Plug 'dyng/ctrlsf.vim'
" }}}

" Filesystem browsers {{{
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeFind'}
Plug 'justinmk/vim-dirvish'
" }}}

" Quickfix list enhancement {{{
Plug 'romainl/vim-qf'
Plug 'yssl/QFEnter'
" }}}

" Linting {{{
Plug 'scrooloose/syntastic', {'on': ['SyntasticCheck', 'SyntasticToggleMode']}
Plug 'neomake/neomake'
" }}}

" Formatters {{{
Plug 'Chiel92/vim-autoformat'
" }}}

" Snippets {{{
Plug 'SirVer/ultisnips' | Plug 'honza/vim-snippets'
" }}}

" Tags {{{
Plug 'ludovicchabant/vim-gutentags'
" }}}

" Tmux {{{
Plug 'christoomey/vim-tmux-navigator'
Plug 'tmux-plugins/vim-tmux-focus-events'
Plug 'edkolev/tmuxline.vim', {'on': 'Tmuxline'}
" }}}

" Helpful plugins {{{
Plug 'Shougo/junkfile.vim', {'on': 'JunkfileOpen'}
Plug 'Valloric/MatchTagAlways', {'for': ['xml', 'html', 'htmldjango', 'jinja']}
Plug 'junegunn/vim-easy-align'
Plug 'mbbill/undotree', {'on': 'UndotreeShow'}
Plug 'mhinz/vim-hugefile'
Plug 'myint/indent-finder'
Plug 'pbrisbin/vim-mkdir'
Plug 'szw/vim-maximizer', {'on': 'MaximizerToggle'}
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'yevhen-m/auto-pairs'
" }}}

" Dispatch plugins {{{
Plug 'aliev/vim-compiler-python', {'on': 'Dispatch'}
Plug 'radenling/vim-dispatch-neovim', {'on': 'Dispatch'}
Plug 'tpope/vim-dispatch', {'on': 'Dispatch'}
" }}}

" Session management {{{
Plug 'tpope/vim-obsession'
" }}}

" Colorscheme {{{
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'yevhen-m/base16-vim'
" }}}

" FZF {{{
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
" }}}

call plug#end()
" }}}

" Abbreviations {{{
if filereadable(expand('~/.config/nvim/abbreviations.vim'))
  source ~/.config/nvim/abbreviations.vim
endif
" }}}

" Main settings {{{
let mapleader=","

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-eighties

set clipboard^=unnamedplus
set synmaxcol=500
set hidden
set autoread  " for vim-tmux-focus-events plugin
" Enable complete filename after =
set isfname-==
set inccommand=nosplit
set wrap
let &showbreak = '+++ '
set background=dark
set backspace=2
set completeopt-=preview
set gdefault
set history=1000
set ignorecase
set list
set listchars=tab:▸▸,trail:·
set nofoldenable
set updatetime=4000
" This order matters!
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

set splitbelow
set splitright
set noshowmode
set noshowcmd
set expandtab  " <tab> inserts spaces
set infercase
set noacd
set nobackup
set showmatch
set matchtime=2
set noswapfile
set nrformats=  "treat all numbers as decimal, not octal"
set number
set omnifunc=syntaxcomplete#Complete
set path+=**
set scrolloff=5
set shell=/bin/zsh
set shiftwidth=4 " columns per <<
set softtabstop=4  " spaces per tab
set tabstop=4  " columns per tabstop
set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value
set undofile  " keep undo history for all file changes
set wildignore+=*.pyc,*/__pycache__/*
set pastetoggle=cop
" }}}

" Vim-plug settings {{{
let g:plug_window = 'enew'
" }}}

" Python {{{
if filereadable(glob('~/.pyenv/versions/neovim3/bin/python'))
    let g:python3_host_prog = glob('~/.pyenv/versions/neovim3/bin/python')
endif
if filereadable(glob('~/.pyenv/versions/neovim36/bin/python'))
    let g:python3_host_prog = glob('~/.pyenv/versions/neovim36/bin/python')
endif
if filereadable(glob('~/.pyenv/versions/neovim2/bin/python'))
    let g:python_host_prog = glob('~/.pyenv/versions/neovim2/bin/python')
endif
" }}}

" Autocommands {{{
" Open the file on the last exit place
autocmd! BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" Python autocommands {{{
autocmd! BufRead,BufNewFile *.py set filetype=python colorcolumn=73,80
" }}}

autocmd! FileType css setlocal shiftwidth=2 tabstop=2 colorcolumn=80
autocmd! FileType gitcommit setlocal colorcolumn=51 textwidth=72
autocmd! FileType html setlocal shiftwidth=4 tabstop=4
autocmd! FileType javascript setlocal shiftwidth=2 tabstop=2 colorcolumn=80
autocmd! FileType rst setlocal filetype=text
autocmd! FileType text setlocal shiftwidth=2 textwidth=80 colorcolumn=80
autocmd! FileType xml setlocal shiftwidth=4 tabstop=4
autocmd! FileType nerdtree setlocal colorcolumn&
" }}}

" Trim whitespace on save {{{
fun! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun
autocmd! BufWritePre * :call TrimWhitespace()
" }}}

" Mappings {{{
" Resize vim windows
nnoremap <left>   <c-w><
nnoremap <right>  <c-w>>
nnoremap <up>     <c-w>+
nnoremap <down>   <c-w>-
" Edit init.vim
nnoremap <leader>ev :e $MYVIMRC<cr>
" Edit abbreviations
nnoremap <leader>ea :e ~/.config/nvim/abbreviations.vim<CR>

" Close quickfix and location lists
nnoremap <leader>c :cclose<bar>lclose<cr>
nnoremap <silent> <space> :nohlsearch<cr>:diffupdate<cr>
" Quit
inoremap <C-Q>     <esc>:q<cr>
nnoremap <C-Q>     :q<cr>
nnoremap <leader>q :q<cr>
nnoremap <c-l> <c-^>
" Switch keymaps easily
inoremap <c-l> <c-^>
cnoremap <c-l> <c-^>
nnoremap Y y$

" Readline style keybindings for command line
cnoremap        <C-A> <Home>
cnoremap        <C-B> <Left>
cnoremap <expr> <C-D> getcmdpos()>strlen(getcmdline())?"\<Lt>C-D>":"\<Lt>Del>"
cnoremap <expr> <C-F> getcmdpos()>strlen(getcmdline())?&cedit:"\<Lt>Right>"

" Use backslash to jump to previous char match
nnoremap \ ,
nnoremap <C-]> g<C-]>
" Use Q instead of q to start recording a macro
nnoremap Q q
" Use q only to close plugin windows
nnoremap q <Nop>
nnoremap <silent> <leader><leader> :update<CR>
" Quit vim
nnoremap ZX :qall<CR>
" Change tabs
nnoremap <silent> tn :tabnext<CR>
nnoremap <silent> tp :tabprev<CR>
nnoremap <silent> th :tabfirst<CR>
nnoremap <silent> tl :tablast<CR>
nnoremap <silent> <c-w>t :tabnew<CR>
" %% for current file dir path
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Smart scrolling
nnoremap <C-j> 2<C-E>
vnoremap <C-j> 2j
nnoremap <C-k> 2<C-Y>
vnoremap <C-k> 2k
" Operate on display lines, not real lines {{{
nnoremap k gk
vnoremap k gk
nnoremap gk k
vnoremap gk k

nnoremap j gj
vnoremap j gj
nnoremap gj j
vnoremap gj j

nnoremap 0 g0
vnoremap 0 g0
nnoremap g0 0
vnoremap g0 0

nnoremap ^ g^
vnoremap ^ g^
nnoremap g^ ^
vnoremap g^ ^

nnoremap $ g$
vnoremap $ g$
nnoremap g$ $
vnoremap g$ $
" }}}

nnoremap <c-w>; <c-w>p
" Replace in all buffer
nnoremap <leader>rs :%s/
" }}}

" Ultisnips settings {{{
let g:UltiSnipsJumpForwardTrigger="<tab>"
let g:UltiSnipsJumpBackwardTrigger="<S-tab>"
" }}}

" FZF settings {{{
nnoremap <silent> <C-g><C-j> :GFiles?<CR>
nnoremap <silent> <C-_> :BLines<CR>
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>rr :History<CR>
nnoremap <silent> <leader>t :Tags<CR>
nnoremap <silent> <leader>T :BTags<CR>
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_tags_command = 'tags'
let g:fzf_commands_expect = 'ctrl-x'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
" Turn off preview window for GFiles? command
autocmd VimEnter * command! -bang -nargs=? GFiles call fzf#vim#gitfiles(<q-args>, {'options': '--no-preview'}, <bang>0)
" }}}

" Airline settings {{{
let g:airline#extensions#neomake#enabled = 1
let g:airline#extensions#whitespace#checks = []
let g:airline#extensions#hunks#enabled = 1
let g:airline#extensions#hunks#non_zero_only = 1
let g:airline#extensions#branch#displayed_head_limit = 13
let g:airline#extensions#branch#format = 2
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline#extensions#syntastic#enabled = 0
let g:airline_detect_iminsert=1
let g:airline#extensions#tmuxline#enabled = 0
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#show_tabs = 1
let g:airline#extensions#tabline#show_buffers = 0
let g:airline#extensions#tabline#show_tab_nr = 0
let g:airline#extensions#tabline#show_splits = 1
let g:airline#extensions#wordcount#enabled = 0
let g:airline_powerline_fonts = 1
let g:airline_theme='bubblegum'
" }}}

" Nerdtree settings {{{
nnoremap <silent> <Leader>nn :NERDTreeFind<CR><C-w>=
nnoremap <silent> <leader>nt :NERDTreeToggle<CR><C-w>=
let g:NERDTreeShowHidden=1
let g:NERDTreeHighlightCursorline = 0
let g:NERDTreeQuitOnOpen = 0
let NERDTreeIgnore=['\.pyc$', '__pycache__']
" automatically remove buffer after a file was deleted with context menu
let NERDTreeAutoDeleteBuffer = 1
" }}}

" Undotree settings {{{
let g:undotree_SetFocusWhenToggle = 1
" }}}

" Syntastic settings {{{
" ignore line length, whitespace around operators and bad indentation
let g:syntastic_python_flake8_post_args='--ignore=E501,E128,E225,E231,F403,F405,E126'
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_error_symbol='●'
let g:syntastic_warning_symbol='●'
let g:syntastic_style_error_symbol='●'
let g:syntastic_style_warning_symbol='●'
" close loclist when there are no errors
let g:syntastic_auto_loc_list = 1
let g:syntastic_auto_jump = 0
let g:syntastic_enable_highlighting = 0
let g:syntastic_loc_list_height = 5
" don't check on open, because it is lagging with big files
let g:syntastic_check_on_open=0
" don't use active mode, because it's laggin with big files
" you can always turn it on for the specified file
let g:syntastic_mode_map = {
            \ "mode": "passive",
            \ "active_filetypes": [],
            \ "passive_filetypes": [] }
highlight SyntasticErrorSign ctermbg=18 ctermfg=red
highlight SyntasticWarningSign ctermbg=18 ctermfg=yellow
let g:syntastic_python_checkers=['flake8']
let g:syntastic_aggregate_errors = 1
nnoremap cot :SyntasticToggleMode<CR>
" }}}

" Neomake settings {{{
let g:neomake_python_enabled_makers = ['flake8']
" E501 -- line too long
" E402 -- import not at top of file
" E128 -- continuation line underindented
" E225 -- missing whitespace around operator
" E231 -- missing whitespace after ','
" F403 -- import * used, unable to detect undefined names
" F405 -- name may be undefined, or defined from * imports
" E126 -- indentation error
let g:neomake_highlight_columns = 0
let g:neomake_highlight_lines = 0
let g:neomake_python_flake8_args = ['--ignore=E501,E402,E128,E225,E231,F403,F405,E126']
let g:neomake_verbose = 0
autocmd! BufWritePost *.py Neomake
let g:neomake_warning_sign = {'text': '●', 'texthl': 'NeomakeWarningSign'}
let g:neomake_message_sign = {'text': '●', 'texthl': 'NeomakeMessageSign'}
let g:neomake_error_sign = {'text': '●', 'texthl': 'NeomakeErrorSign'}
let g:neomake_info_sign = {'text': '●', 'texthl': 'NeomakeInfoSign'}
" }}}

" Jedi settings {{{
let g:jedi#completions_enabled = 0
let g:jedi#auto_initialization = 0
let g:jedi#show_call_signatures = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#auto_vim_configuration = 0
nnoremap <silent> <leader>gg :call jedi#goto()<CR>
nnoremap <silent> <leader>gu :call jedi#usages()<CR>
nnoremap <silent> <S-K> :call jedi#show_documentation()<CR>
" }}}

" Matchparen plugin settings {{{
hi MatchParen cterm=none ctermbg=19 ctermfg=none
" }}}

" Vim test runner settings {{{
let test#python#runner = 'djangotest'
let test#strategy = "dispatch"

nnoremap <leader>rt :TestNearest<CR>
nnoremap <leader>rf :TestFile<CR>
" }}}

" Deoplete settings {{{
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let deoplete#tag#cache_limit_size = 50000000
let g:neoinclude#ctags_commands = 'tags'
" Silence messages
set shortmess+=c
" trigger deoplete manually in insert mode
inoremap <silent><expr> <C-n>
            \ pumvisible() ? "\<C-n>" :
            \ deoplete#mappings#manual_complete()
inoremap <silent> <C-j> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
endfunction
" }}}

" Autoformat settings {{{
noremap <leader>ss :Autoformat<CR>
vnoremap <leader>ss :'<,'>Autoformat<CR>

let g:formatters_html = ['htmlbeautify']
let g:formatdef_autopep8 = "'autopep8 - --range '.a:firstline.' '.a:lastline"
let g:formatters_python = ['autopep8']
" }}}

" Swap movements {{{
function! ToggleMovement(firstOp, thenOp)
    let pos = getpos('.')
    execute "normal! " . a:firstOp
    if pos == getpos('.')
        execute "normal! " . a:thenOp
    endif
endfunction
nnoremap <silent> 0 :call ToggleMovement('^', '0')<CR>
" }}}

" Remove colorcolumns in quickfix and location list windows {{{
au FileType qf,GV setlocal colorcolumn=
" }}}

" Isort plugin settings {{{
let g:vim_isort_map = '<leader>is'
nnoremap <leader>is :Isort<CR>
" }}}

" Custom func to change iminsert option {{{
function! ToggleEscapeMapping()
    if b:escape_mapping
        let b:escape_mapping = 0
        inoremap <buffer> <silent> <esc> <esc>l
        echom 'ESC mapping does not touch iminsert'
    else
        let b:escape_mapping = 1
        inoremap <buffer> <silent> <esc> <esc>:set iminsert=0<CR>l
        echom 'ESC mapping resets iminsert'
    endif
endfunction
" reset imsert by default
inoremap <silent> <esc> <esc>:set iminsert=0<CR>l
autocmd BufEnter * let b:escape_mapping = 1
autocmd BufEnter * set iminsert=0
autocmd BufEnter * nnoremap col :call ToggleEscapeMapping()<CR>
" }}}

" Ctrlsf settings {{{
nmap <leader>fs <Plug>CtrlSFPrompt
nmap <leader>ff <Plug>CtrlSFQuickfixPrompt
nnoremap <leader>ft :CtrlSFOpen<CR>
let g:ctrlsf_confirm_save = 0
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_winsize = '40%'
let g:ctrlsf_populate_qflist = 1
let g:ctrlsf_context = '-B 3 -A 2'
let g:ctrlsf_selected_line_hl = 'p'
" }}}

" Maximizer plugin settings {{{
let g:maximizer_set_default_mapping = 0
nnoremap <leader>m :MaximizerToggle<CR>
" }}}

" Clear ipdb breakpoints {{{
command! ClearPdb g/pdb/d
" }}}

" Python Compiler {{{
let g:python_compiler_fixqflist = 1
let g:python_compiler_highlight_errors = 0
" }}}

" IndentLine settings {{{
let g:indentLine_color_term = 19
let g:indentLine_fileType = ['python']
let g:indentLine_faster = 1
if !exists("g:syntax_on")
    syntax on
endif
" }}}

" Gitgutter settings {{{
let g:gitgutter_sign_column_always = 1
let g:gitgutter_diff_args = '-w'
" Refine gitgutter signs
highlight GitGutterAdd ctermfg=2 ctermbg=18 cterm=bold
highlight GitGutterChange ctermfg=4 ctermbg=18 cterm=bold
highlight GitGutterDelete ctermfg=1 ctermbg=18 cterm=bold
highlight GitGutterChangeDelete ctermfg=5 ctermbg=18 cterm=bold
" }}}

" Autopairs settings {{{
let g:AutoPairsShortcutJump='<c-k>'
" }}}

" Show cursorline only in active window {{{
augroup CursorLineOnlyInActiveWindow
  autocmd!
  autocmd VimEnter,WinEnter,BufWinEnter * setlocal cursorline
  autocmd WinLeave * setlocal nocursorline
augroup END
" }}}

" vim-qf settings {{{
let g:qf_auto_open_quickfix = 0
let g:qf_auto_open_loclist = 0
" }}}

" Vim-asterisk settings {{{
map *   <Plug>(asterisk-*)
map #   <Plug>(asterisk-#)
map g*  <Plug>(asterisk-g*)
map g#  <Plug>(asterisk-g#)
map z*  <Plug>(asterisk-z*)
map gz* <Plug>(asterisk-gz*)
map z#  <Plug>(asterisk-z#)
map gz# <Plug>(asterisk-gz#)
let g:asterisk#keeppos = 1
" }}}

" Vim-easy-align plugin {{{
" Start interactive EasyAlign in visual mode (e.g. vipga)
xmap ga <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)
" }}}

" QFEnter plugin settings {{{
let g:qfenter_vopen_map = ['<C-v>']
let g:qfenter_hopen_map = ['<C-CR>', '<C-s>']
let g:qfenter_topen_map = ['<C-t>']
" }}}

" Neopairs settings {{{
let g:neopairs#enable = 1
" }}}

" Tmux navigator settings {{{
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <M-h> :TmuxNavigateLeft<cr>
nnoremap <silent> <M-j> :TmuxNavigateDown<cr>
nnoremap <silent> <M-k> :TmuxNavigateUp<cr>
nnoremap <silent> <M-l> :TmuxNavigateRight<cr>
nnoremap <silent> <M-p> :TmuxNavigatePrevious<cr>
" }}}
