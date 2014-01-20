" display startup time
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
    \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

" plugin
source ~/dotfiles/.vim/conf.d/.vimrc.bundle
" basic
source ~/dotfiles/.vim/conf.d/.vimrc.basic
" statusline
source ~/dotfiles/.vim/conf.d/.vimrc.statusline
" indent
source ~/dotfiles/.vim/conf.d/.vimrc.indent
" apperance
source ~/dotfiles/.vim/conf.d/.vimrc.apperance
" completion
source ~/dotfiles/.vim/conf.d/.vimrc.completion
" tags
source ~/dotfiles/.vim/conf.d/.vimrc.tags
" search
source ~/dotfiles/.vim/conf.d/.vimrc.search
" moving
source ~/dotfiles/.vim/conf.d/.vimrc.moving
" color
source ~/dotfiles/.vim/conf.d/.vimrc.colors
" editing
source ~/dotfiles/.vim/conf.d/.vimrc.editing
" encoding
source ~/dotfiles/.vim/conf.d/.vimrc.encoding
" program
source ~/dotfiles/.vim/conf.d/.vimrc.program
" plugins setting
source ~/dotfiles/.vim/conf.d/.vimrc.plugins_setting
