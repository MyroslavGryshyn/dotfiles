filetype off

if empty(glob("~/.config/nvim/autoload/plug.vim"))
    !curl -fLo ~/.config/nvim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

function! DoRemote(arg)
    UpdateRemotePlugins
endfunction

call plug#begin('~/.config/nvim/plugged')

" Syntax plugins
Plug 'tpope/vim-markdown', {'for': 'md'}
Plug 'cespare/vim-toml', {'for': 'toml'}
Plug 'avakhov/vim-yaml', {'for': 'yaml'}
Plug 'Glench/Vim-Jinja2-Syntax', {'for': 'jinja'}
Plug 'jelera/vim-javascript-syntax', {'for': 'javascript'}

" Autocomplete engines
Plug 'Shougo/deoplete.nvim', { 'do': function('DoRemote') }
Plug 'zchee/deoplete-jedi', {'for': 'python'}
Plug 'Shougo/neopairs.vim'
Plug 'Shougo/neosnippet.vim'

" Integration with git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'junegunn/gv.vim'

" Running tests from vim
Plug 'janko-m/vim-test', {'for': 'python'}

" Python plugins
Plug 'davidhalter/jedi-vim', { 'for': 'python' }
Plug 'hynek/vim-python-pep8-indent', { 'for': 'python' }
Plug 'tell-k/vim-autoflake', {'for': 'python'}
Plug 'bps/vim-textobj-python', {'for': 'python'}
Plug 'michaeljsmith/vim-indent-object', {'for': 'python'}
Plug 'yevhen-m/python-syntax', {'for': 'python'}
Plug 'fisadev/vim-isort', {'for': 'python'}

" Enhance vim searching
Plug 'thinca/vim-visualstar'
Plug 'henrik/vim-indexed-search'
Plug 'dyng/ctrlsf.vim'

" Text objects
Plug 'kana/vim-textobj-user'
" very helpful plugin when writing code
Plug 'sgur/vim-textobj-parameter'
Plug 'junegunn/vim-after-object'

" Helpful plugins
Plug 'scrooloose/nerdtree', {'on': 'NERDTreeFind'}
Plug 'scrooloose/syntastic', {'on': ['SyntasticCheck', 'SyntasticToggleMode']}
" Set proper indentation settings for the file
Plug 'myint/indent-finder'
Plug 'bogado/file-line'
Plug 'mbbill/undotree', {'on': 'UndotreeShow'}
Plug 'szw/vim-maximizer'

Plug 'honza/vim-snippets'

" Toggle quick and location lists
Plug 'Valloric/ListToggle'

" Highlight enclosing tags
Plug 'Valloric/MatchTagAlways', {'for': ['xml', 'html', 'jinja']}

Plug 'Shougo/junkfile.vim'
Plug 'pbrisbin/vim-mkdir'

" Autoclose parens, quotes, etc.
Plug 'Raimondi/delimitMate'

" Fix focus events in tmux
Plug 'tmux-plugins/vim-tmux-focus-events'

" Some usefull keypairs
Plug 'tpope/vim-unimpaired'

Plug 'Chiel92/vim-autoformat'

Plug 'ludovicchabant/vim-gutentags'

Plug 'tpope/vim-commentary'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'

" Sugar for unix shell commands
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-dispatch'

" Vim sessions enhancement
Plug 'xolox/vim-misc'
Plug 'xolox/vim-session'

" Pretty looking vim
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'chriskempson/base16-vim'
Plug 'edkolev/tmuxline.vim', {'on': 'Tmuxline'}

" FZF
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'

call plug#end()

let mapleader=","

let base16colorspace=256  " Access colors present in 256 colorspace
colorscheme base16-eighties

filetype plugin indent on
syntax on
set synmaxcol=250

set autoread  " for vim-tmux-focus-events plugin
" Enable complete filename after =
set isfname-==
set wrap
let &showbreak = '+++ '
set background=dark
set backspace=2
set complete-=t  "dont't include words from tag file
set completeopt-=preview
set cursorline
set gdefault
set hidden
set history=1000
set ignorecase
set list
set listchars=tab:▸▸,trail:·
set nofoldenable
set splitbelow
set splitright
set updatetime=400  " try to change this value for gitgutter
" This order matters!
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

set noshowmode
set showcmd
set expandtab  " <tab> inserts spaces
set infercase
set noacd
set nobackup
set showmatch
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
set timeoutlen=1000 ttimeoutlen=0
set undofile  " keep undo history for all file changes
set wildignore+=*.pyc,*/.git/*,*/__pycache__/*
set pastetoggle=cop

if filereadable(glob('~/.pyenv/versions/neovim3/bin/python'))
    let g:python3_host_prog = glob('~/.pyenv/versions/neovim3/bin/python')
endif
if filereadable(glob('~/.pyenv/versions/neovim36/bin/python'))
    let g:python3_host_prog = glob('~/.pyenv/versions/neovim36/bin/python')
endif
if filereadable(glob('~/.pyenv/versions/neovim2/bin/python'))
    let g:python_host_prog = glob('~/.pyenv/versions/neovim2/bin/python')
endif

" Open the file on the last exit place
autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif

" autodetect python filetype
autocmd BufRead,BufNewFile *.py set filetype=python colorcolumn=73,80

" Enable omni completion and set filetype indent settings.
autocmd FileType css setlocal shiftwidth=2 tabstop=2 colorcolumn=80
autocmd FileType gitcommit setlocal colorcolumn=51 textwidth=72
autocmd FileType html,markdown,jinja setlocal shiftwidth=4 tabstop=4
autocmd FileType javascript setlocal shiftwidth=2 tabstop=2 colorcolumn=80
autocmd FileType rst setlocal filetype=text
autocmd FileType text setlocal shiftwidth=2 textwidth=80 colorcolumn=80
autocmd FileType xml setlocal shiftwidth=4 tabstop=4
autocmd FileType nerdtree setlocal colorcolumn&

" trim whitespace on save
fun! TrimWhitespace()
    let l:save_cursor = getpos('.')
    %s/\s\+$//e
    call setpos('.', l:save_cursor)
endfun
autocmd BufWritePre * :call TrimWhitespace()

" open help in a new tab
cabbrev h tab help

" MAPPINGS
nnoremap <silent> <space> :nohl<CR>
" Switch keymaps easily
nnoremap <c-l> <c-^>
inoremap <c-l> <c-^>
cnoremap <c-l> <c-^>
nnoremap Y y$
" Yank to system clipboard
nnoremap gy "+y
vnoremap gy "+y
vnoremap gY "+Y
nnoremap gY "+y$
" Paste from system clipboard
nnoremap gp "+p
vnoremap gp "+p
nnoremap gP "+P

nnoremap \ ,
nnoremap <leader>sr :SyntasticReset<CR>
nnoremap <leader>sc :SyntasticCheck<CR>
nnoremap <C-]> g<C-]>
" Use Q instead of q to start recording a macro
nnoremap Q q
" Use q only to close plugin windows
nnoremap q <Nop>
nnoremap <silent> <leader><leader> :update<CR>
nnoremap ZX :qall<CR>
nnoremap ZV :qall!<CR>
nnoremap <silent> tn :tabnext<CR>
nnoremap <silent> tp :tabprev<CR>
nnoremap <silent> th :tabfirst<CR>
nnoremap <silent> tl :tablast<CR>
nnoremap <silent> <c-w>t :tabnew<CR>
" %% for current file dir path
cnoremap <expr> %% getcmdtype() == ':' ? expand('%:h').'/' : '%%'
" Smart scrolling
nnoremap <C-j> 3<C-E>3j
vnoremap <C-j> 3<C-E>3j
nnoremap <C-k> 3<C-Y>3k
vnoremap <C-k> 3<C-Y>3k
" Operate on display lines, not real lines
nnoremap <silent> k gk:nohl<CR>
nnoremap <silent> j gj:nohl<CR>
nnoremap 0 g0
nnoremap ^ g^
nnoremap $ g$

nnoremap <c-w>; <c-w>p
nnoremap <c-w><c-q> <c-w>c
nnoremap <c-w>q <c-w>c
" END MAPPINGS

" DELIMITMATE SETTINGS
let delimitMate_excluded_regions = "Comment"
let delimitMate_expand_cr = 1
au FileType python let delimitMate_nesting_quotes = ["'", '"']
au FileType markdown let delimitMate_nesting_quotes = ["`"]
" Put triple quotes on the separate line after cr
au FileType python,markdown let b:delimitMate_expand_inside_quotes = 1
let delimitMate_quotes = "\" ' `"
au FileType markdown let delimitMate_quotes = "\" ' `"
au FileType vim,html let b:delimitMate_matchpairs = "(:),[:],{:},<:>"
" END DELIMITMATE SETTINGS

" FZF PLUGIN SETTINGS
nnoremap <silent> <C-p> :Files<CR>
nnoremap <silent> <C-_> :BLines<CR>
nnoremap <silent> <C-g><C-j> :GFiles?<CR>
nnoremap <silent> <C-g><C-l> :Commits<CR>
nnoremap <silent> <C-g><C-o> :BCommits<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>cc :Commands<CR>
nnoremap <silent> <leader>rr :History<CR>
nnoremap <silent> <leader>T :Tags<CR>
nnoremap <silent> <leader>tt :BTags<CR>
nnoremap <leader>aa :Ag<space>
let g:fzf_layout = { 'window': 'enew' }
let g:fzf_history_dir = '~/.fzf-history'
let g:fzf_tags_command = 'tags'
let g:fzf_action = {
            \ 'ctrl-t': 'tab split',
            \ 'ctrl-s': 'split',
            \ 'ctrl-v': 'vsplit' }
" Customize fzf colors to match your color scheme
let g:fzf_colors =
            \ { 'fg':      ['fg', 'Normal'],
            \ 'bg':      ['bg', 'Normal'],
            \ 'hl':      ['fg', 'String'],
            \ 'fg+':     ['fg', 'CursorLine', 'CursorColumn', 'Normal'],
            \ 'bg+':     ['bg', 'CursorLine', 'CursorColumn'],
            \ 'hl+':     ['fg', 'String'],
            \ 'info':    ['fg', 'PreProc'],
            \ 'prompt':  ['fg', 'Conditional'],
            \ 'pointer': ['fg', 'Exception'],
            \ 'marker':  ['fg', 'Keyword'],
            \ 'spinner': ['fg', 'Label'],
            \ 'header':  ['fg', 'Comment'] }
" FZF END

" AIRLINE SETTINGS
let g:airline#extensions#whitespace#checks = []
let g:airline#extensions#branch#displayed_head_limit = 13
let g:airline_section_warning = ''
let g:airline_section_error = ''
let g:airline#extensions#branch#format = 2
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#tabline#show_close_button = 0
let g:airline#extensions#tabline#buffer_nr_show = 0
let g:airline_skip_empty_sections = 1
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
" END AIRLINE SETTINGS

" NERDTREE SETTINGS
nnoremap <silent> <Leader>nn :NERDTreeFind<CR>
nnoremap <silent> <leader>nt :NERDTreeToggle<CR>
let g:NERDTreeShowHidden=1
let g:NERDTreeHijackNetrw = 1
let g:NERDTreeQuitOnOpen = 0
let NERDTreeIgnore=['\.pyc$', '__pycache__']
" automatically remove buffer after a file was deleted with context menu
let NERDTreeAutoDeleteBuffer = 1
" END NERDTREE SETTINGS

" UNDOTREE SETTINGS
let g:undotree_SetFocusWhenToggle = 1
" END UNDOTREE SETTINGS

" SYNTASTIC SETTINGS
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
" END SYNTASTIC SETTINGS

" GITGUTTER SETTINGS
let g:gitgutter_sign_column_always = 1
let g:gitgutter_diff_args = '-w'
let g:gitgutter_map_keys = 0
nmap [c <Plug>GitGutterPrevHunk
nmap ]c <Plug>GitGutterNextHunk
" You should work with changes
nmap <Leader>cs <Plug>GitGutterStageHunk
nmap <Leader>cu <Plug>GitGutterUndoHunk
nmap <leader>cp <Plug>GitGutterPreviewHunk
omap ic <Plug>GitGutterTextObjectInnerPending
omap ac <Plug>GitGutterTextObjectOuterPending
xmap ic <Plug>GitGutterTextObjectInnerVisual
xmap ac <Plug>GitGutterTextObjectOuterVisual
" END GITGUTTER SETTINGS

" JEDI SETTINGS
let g:jedi#completions_enabled = 0
let g:jedi#auto_initialization = 0
let g:jedi#smart_auto_mappings = 0
let g:jedi#auto_vim_configuration = 0
nnoremap <silent> <leader>gg :call jedi#goto()<CR>
nnoremap <silent> <S-K> :call jedi#show_documentation()<CR>
" END JEDI SETTINGS

" PYTHON SYNTAX SETTINGS
let python_highlight_all = 1
" END PYTHON SYNTAX SETTINGS

" MATCHPAREN PLUGIN SETTINGS
hi MatchParen cterm=none ctermbg=19 ctermfg=none
" END MATCHPAREN

" VIM TEST RUNNER SETTINGS
let test#python#runner = 'nose'
let test#strategy = "dispatch"

nnoremap <leader>tn :TestNearest<CR>
nnoremap <leader>tf :TestFile<CR>
nnoremap <leader>ts :TestSuite<CR>
nnoremap <leader>tl :TestLast<CR>
nnoremap <leader>tv :TestVisit<CR>
" END VIM TEST RUNNER

" DEOPLETE SETTINGS
let g:deoplete#enable_at_startup = 1
let g:deoplete#enable_ignore_case = 1
let g:deoplete#sources#jedi#enable_cache = 1
let deoplete#tag#cache_limit_size = 50000000
let g:neoinclude#ctags_commands = 'tags'
" Silence messages
set shortmess+=c
" Sort candidates
call deoplete#custom#set('_', 'matchers', ['matcher_head'])
" trigger deoplete manually in insert mode
inoremap <silent><expr> <C-n>
            \ pumvisible() ? "\<C-n>" :
            \ deoplete#mappings#manual_complete()
inoremap <silent> <C-j> <C-r>=<SID>my_cr_function()<CR>
function! s:my_cr_function() abort
    return deoplete#close_popup() . "\<CR>"
endfunction
" END DEOPLETE SETTINGS

" AUTOFORMAT SETTINGS
noremap <leader>af :Autoformat<CR>
let g:formatters_html = ['htmlbeautify']
let g:formatters_python = ['autopep8']
let g:formatdef_autopep8 = "'autopep8 - --range '.a:firstline.' '.a:lastline"
" END AUTOFORMAT

" THE ORIGINAL CARET 0 SWAP
function! ToggleMovement(firstOp, thenOp)
    let pos = getpos('.')
    execute "normal! " . a:firstOp
    if pos == getpos('.')
        execute "normal! " . a:thenOp
    endif
endfunction
nnoremap <silent> 0 :call ToggleMovement('^', '0')<CR>

" FUGITIVE SETTINGS
nnoremap ,ss :Gstatus<CR>
nnoremap ,ge :Gedit<space>
nnoremap ,gt :Gtabedit<space>
nnoremap ,gv :Gvsplit<space>
nnoremap ,gs :Gsplit<space>
" END FUGITIVE

" VIM-SESSION SETTINGS
let g:session_autoload='no'
let g:session_default_name='default'
let g:session_autosave='yes'
let g:session_autosave_periodic=5
let g:session_command_aliases = 1
" END VIM SESSION

" MARKDOWN PLUGIN SETTINGS
let g:markdown_fenced_languages = ['html', 'python', 'bash=sh']
" END MARKDOWN

" INDEXED SEARCH SETTGINS
let g:indexed_search_colors=0
nnoremap <silent> g/ :ShowSearchIndex<cr>
" END INDEXED SEARCH

" Abbreviations
cabbr git Gtabedit!

" AUTOFLAKE SETTINGS
let g:autoflake_remove_all_unused_imports=1
let g:autoflake_disable_show_diff=1
let g:autoflake_remove_unused_variables=1
" END AUTOFLAKE SETTINGS

" VIM-COMMENTARY SETTINGS
autocmd FileType nginx setlocal commentstring=#\ %s
autocmd FileType jinja setlocal commentstring=<!--\ %s\ -->
" END VIM-COMMENTARY

highlight! link Error ErrorMsg

" ISORT PLUGIN SETTINGS
let g:vim_isort_map = '<leader>is'
nnoremap <leader>is :Isort<CR>
" END ISORT SETTINGS

" NEOSNIPPET PLUGIN SETTINGS
let g:neosnippet#disable_runtime_snippets = {
            \   '_' : 1,
            \ }
let g:neosnippet#snippets_directory=glob('~/.config/nvim/plugged/vim-snippets/snippets')
imap <C-e>     <Plug>(neosnippet_expand_or_jump)
smap <C-e>     <Plug>(neosnippet_expand_or_jump)
xmap <C-e>     <Plug>(neosnippet_expand_target)
if has('conceal')
    set conceallevel=2 concealcursor=niv
endif
" END NEOSNIPPET

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
autocmd BufEnter * nnoremap <silent> cos :syntax sync fromstart<CR>

" CTRLSF SETTINGS
nmap <leader>ff <Plug>CtrlSFPrompt
vmap <leader>fw <Plug>CtrlSFVwordPath
nmap <leader>fw <Plug>CtrlSFCwordPath
nnoremap <leader>ft :CtrlSFOpen<CR>
let g:ctrlsf_confirm_save = 0
let g:ctrlsf_position = 'bottom'
let g:ctrlsf_winsize = '40%'
let g:ctrlsf_populate_qflist = 1
let g:ctrlsf_context = '-C 1'
let g:ctrlsf_selected_line_hl = ''
" END CTRLSF SETTINGS

" VIM-AFTER-OBJECT PLUGIN SETTINGS
autocmd VimEnter * call after_object#enable('=', ':', '-', '#', ' ', '.')
" END VIM-AFTER-OBJECT SETTINGS

" MAXIMIZER PLUGIN SETTINGS
let g:maximizer_set_default_mapping = 0
nnoremap <silent> com :MaximizerToggle<CR>
" END MAXIMIZER PLUGIN
