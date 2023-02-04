# Fig pre block. Keep at the top of this file.
[[ -f "$HOME/.fig/shell/zshrc.pre.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.pre.zsh"
# load zshrc
rcs=( basic term alias utility osx )
for rc in $rcs; do
  source $HOME/dotfiles/.zsh/conf.d/.zshrc.$rc
done

# local
if [ -f ~/.zshrc.local ]; then
  source ~/.zshrc.local
fi

# Fig post block. Keep at the bottom of this file.
[[ -f "$HOME/.fig/shell/zshrc.post.zsh" ]] && builtin source "$HOME/.fig/shell/zshrc.post.zsh"
