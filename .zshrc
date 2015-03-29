# load zshrc
rcs=( basic term alias utility os )
for rc in $rcs; do
  source $HOME/dotfiles/.zsh/conf.d/.zshrc.$rc
done

# local
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi
