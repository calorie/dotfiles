"------------------------------------
" mysettings
"------------------------------------
" set columns=100
" set lines=52
set guioptions=-c
gui
set t_Co=256
set shortmess+=I
set guifont=Ricty\ for\ Powerline:h15
set showtabline=1
set vb t_vb=

if executable("vimtweak.dll")
  " transparency
  au guienter * call libcallnr("vimtweak","SetAlpha",220)
  " fullscreen
  au guienter * call libcallnr("vimtweak.dll", "EnableMaximize", 1)
  au guienter * call libcallnr("vimtweak.dll", "EnableCaption", 0)
endif

if g:is_mac
  set transparency=10
elseif g:is_windows
  nnoremap <silent> <F11> :<C-u>call <SID>toggle_full_screen()<CR>
  function! s:toggle_full_screen()
    if &guioptions =~# 'C'
      set guioptions-=C
      if exists('s:go_temp')
        if s:go_temp =~# 'm'
          set guioptions+=m
        endif
        if s:go_temp =~# 'T'
          set guioptions+=T
        endif
      endif
      simalt ~r
    else
      let s:go_temp = &guioptions
      set guioptions+=C
      set guioptions-=m
      set guioptions-=T
      simalt ~x
    endif
  endfunction
endif
