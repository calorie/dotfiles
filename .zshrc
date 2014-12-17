# load zshrc
rcs=( basic term alias utility os )
for rc in $rcs; do
  source $HOME/dotfiles/.zsh/conf.d/.zshrc.$rc
done
# local
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
