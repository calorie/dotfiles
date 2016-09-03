" display startup time
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
          \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

" load vimrc
let s:rcs = [
      \ 'bundle',
      \ 'basic',
      \ 'indent',
      \ 'apperance',
      \ 'completion',
      \ 'search',
      \ 'moving',
      \ 'colors',
      \ 'editing',
      \ 'encoding',
      \ 'plugins_setting']
for s:rc in s:rcs
  execute 'source ~/dotfiles/.vim/conf.d/.vimrc.' . s:rc
endfor
