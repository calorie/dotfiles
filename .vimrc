let s:rcs = [
      \ 'basic',
      \ 'indent',
      \ 'apperance',
      \ 'completion',
      \ 'search',
      \ 'moving',
      \ 'editing',
      \ 'encoding']
for s:rc in s:rcs
  execute 'source ~/dotfiles/.vim/.vimrc.' . s:rc
endfor

filetype plugin indent on
syntax on

set t_Co=256
set t_Sf=[3%dm
set t_Sb=[4%dm

colorscheme habamax

highlight EndOfBuffer ctermfg=bg
