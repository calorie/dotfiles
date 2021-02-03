" display startup time
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
          \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

source ~/dotfiles/.vim/conf.d/.vimrc.basic
source ~/dotfiles/.vim/conf.d/.nvimrc.dein

" load vimrc
let s:rcs = [
      \ 'indent',
      \ 'apperance',
      \ 'completion',
      \ 'search',
      \ 'moving',
      \ 'colors',
      \ 'editing',
      \ 'encoding',
      \ 'langs',
      \ ]
for s:rc in s:rcs
  execute 'source ~/dotfiles/.vim/conf.d/.vimrc.' . s:rc
endfor
