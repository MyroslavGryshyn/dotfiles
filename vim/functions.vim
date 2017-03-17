function! s:CurrentDate()
    return strftime("%d-%m-%y")
endfunction

function! s:EchoFailure(message)
    echohl ErrorMsg
    echo a:message
    echohl None
endfunction

let s:plug_snapshot_dir = expand('~/.config/nvim/plug-snapshots/')
if !isdirectory(s:plug_snapshot_dir)
    call mkdir(s:plug_snapshot_dir, 'p')
endif
" Path to the current snapshot
let s:plug_snapshot_path = s:plug_snapshot_dir.s:CurrentDate()

function! s:SafePlugUpdate() abort
    " Create directory for snapshots if not exist
    execute 'silent !mkdir '.s:plug_snapshot_dir.' &> /dev/null'

    echom "Save plug snapshot to ".s:plug_snapshot_path
    execute "silent PlugSnapshot!".s:plug_snapshot_path
    " Delete buffer after saving a snapshot
    execute "silent bd plug-snapshot"

    echom "Update plugins..." | execute "PlugUpdate"
endfunction

function! s:PlugRevert() abort
    if filereadable(s:plug_snapshot_path)
        echom "Restore plug state from ".s:plug_snapshot_path
        execute "source ".s:plug_snapshot_path
    else
        call s:EchoFailure("Snapshot for today (".s:CurrentDate().") not found!")
    endif
endfunction

command! SafePlugUpdate call s:SafePlugUpdate()
command! PlugRevert call s:PlugRevert()

" Fzfag operator (I suppose this func should be global)
function! g:_Fzf_ag(type) abort
    " Save register contents
    let l:orig = @@
    if a:type ==# 'char'
        execute "normal! `[v`]y"
        let l:query = @@
        " Restore register contents
        let @@ = l:orig
        execute "Ag ".l:query
    elseif a:type ==# 'line'
        call s:EchoFailure('fzfag operator does not support linewise modes!')
    endif
endfunction

call operator#user#define('fzfag', 'g:_Fzf_ag')
map gh <Plug>(operator-fzfag)

" Custom func to toggle iminsert option {{{
function! ToggleEscapeMapping()
    if b:escape_mapping
        let b:escape_mapping = 0
        inoremap <buffer> <silent> <esc> <esc>l
        echom 'ESC mapping preserves iminsert value.'
    else
        let b:escape_mapping = 1
        inoremap <buffer> <silent> <esc> <esc>:set iminsert=0<CR>l
        echom 'ESC mapping resets iminsert value.'
    endif
endfunction
" reset imsert by default
inoremap <silent> <esc> <esc>:set iminsert=0<CR>l
augroup toggle_escape
    autocmd!
    autocmd BufEnter * let b:escape_mapping = 1
    autocmd BufEnter * set iminsert=0
    autocmd BufEnter * nnoremap col :call ToggleEscapeMapping()<CR>
augroup END
" }}}

function! s:entries(path)
  let path = substitute(a:path,'[\\/]$','','')
  let files = split(glob(path."/.*"),"\n")
  let files += split(glob(path."/*"),"\n")
  call map(files,'substitute(v:val,"[\\/]$","","")')
  call filter(files,'v:val !~# "[\\\\/]\\.\\.\\=$"')

  let filter_suffixes = substitute(escape(&suffixes, '~.*$^'), ',', '$\\|', 'g') .'$'
  call filter(files, 'v:val !~# filter_suffixes')

  return files
endfunction

function! s:FileByOffset(num)
  let file = expand('%:p')
  let num = a:num
  while num
    let files = s:entries(fnamemodify(file,':h'))
    if a:num < 0
      call reverse(sort(filter(files,'v:val <# file')))
    else
      call sort(filter(files,'v:val ># file'))
    endif
    let temp = get(files,0,'')
    if temp == ''
      let file = fnamemodify(file,':h')
    else
      let file = temp
      while isdirectory(file)
        let files = s:entries(file)
        if files == []
          " TODO: walk back up the tree and continue
          break
        endif
        let file = files[num > 0 ? 0 : -1]
      endwhile
      let num += num > 0 ? -1 : 1
    endif
  endwhile
  return file
endfunction

function! s:fnameescape(file) abort
  if exists('*fnameescape')
    return fnameescape(a:file)
  else
    return escape(a:file," \t\n*?[{`$\\%#'\"|!<")
  endif
endfunction

nnoremap <silent> ]f :<C-U>edit <C-R>=fnamemodify(<SID>fnameescape(<SID>FileByOffset(v:count1)), ':.')<CR><CR>
nnoremap <silent> [f :<C-U>edit <C-R>=fnamemodify(<SID>fnameescape(<SID>FileByOffset(-v:count1)), ':.')<CR><CR>

nnoremap coa :call AleToggle()<cr>
" ALE is disabled by default
let s:ale_enabled = 0
function! AleToggle() abort
    let s:ale_enabled = !get(s:, 'ale_enabled')
    echo "ALE " . (s:ale_enabled ? "enabled." : "disabled.")
    execute "ALEToggle"
endfunction
