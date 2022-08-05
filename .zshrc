# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && . "$HOME/.fig/shell/zshrc.pre.zsh"

# load zshrc
rcs=( basic term alias utility os )
for rc in $rcs; do
  source $HOME/dotfiles/.zsh/conf.d/.zshrc.$rc
done

# local
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && . "$HOME/.fig/shell/zshrc.post.zsh"
