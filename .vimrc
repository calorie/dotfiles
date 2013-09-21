" 起動時間表示
if has('vim_starting') && has('reltime')
  let g:startuptime = reltime()
  augroup vimrc-startuptime
    autocmd! VimEnter * let g:startuptime = reltime(g:startuptime) | redraw
    \ | echomsg 'startuptime: ' . reltimestr(g:startuptime)
  augroup END
endif

" pluginを読み込む
source ~/dotfiles/.vim/conf.d/.vimrc.bundle
" 基本設定
source ~/dotfiles/.vim/conf.d/.vimrc.basic
" StatusLine設定
source ~/dotfiles/.vim/conf.d/.vimrc.statusline
" インデント設定
source ~/dotfiles/.vim/conf.d/.vimrc.indent
" 表示関連
source ~/dotfiles/.vim/conf.d/.vimrc.apperance
" 補完関連
source ~/dotfiles/.vim/conf.d/.vimrc.completion
" Tags関連
source ~/dotfiles/.vim/conf.d/.vimrc.tags
" 検索関連
source ~/dotfiles/.vim/conf.d/.vimrc.search
" 移動関連
source ~/dotfiles/.vim/conf.d/.vimrc.moving
" Color関連
source ~/dotfiles/.vim/conf.d/.vimrc.colors
" 編集関連
source ~/dotfiles/.vim/conf.d/.vimrc.editing
" エンコーディング関連
source ~/dotfiles/.vim/conf.d/.vimrc.encoding
" プラグインに依存する設定
source ~/dotfiles/.vim/conf.d/.vimrc.plugins_setting
