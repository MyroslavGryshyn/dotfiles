function! s:SafePlugUpdate()
    " Create a snapshot and save it
    let l:path = expand('~/.config/nvim/plug-snapshots/'.strftime("%d-%m-%y"))
    execute "silent PlugSnapshot!".l:path
    " Delete buffer after saving a snapshot
    execute "silent bd plug-snapshot"
    " Update plugins as usual
    execute "PlugUpdate"
endfunction
command! SafePlugUpdate call s:SafePlugUpdate()
