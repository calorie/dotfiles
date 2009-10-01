" Execute python script C-P
function! s:ExecPy( )
    exe "!" .  & ft . "  % "
:endfunction
command! Exec call <SID>ExecPy( )
autocmd FileType python map <silent> <C-P> :call <SID>ExecPy( )<CR>
autocmd FileType python let g:pydiction_location  =  '~/.vim/pydiction/complete-dict'
