#!/bin/bash
while :
do
  read -p "install dotfiles? y/n " yn
  if [ $yn = "n" -o $yn = "N" ]; then
    exit
  elif [ $yn = "y" -o $yn = "Y" ]; then
    break
  else
    continue
  fi
done

ORIGIN=$(pwd)
DOTFILES_PATH=$(cd $(dirname $0); pwd)
INSTALLER_PATH=$DOTFILES_PATH/bin/installer

PKGS=(
  ricty
  vvm-rb auto-fu
  powerline-shell
  tmux-powerline
  tmux-mem-cpu-load
  tmuxinator )
for pkg in ${PKGS[@]}
do
  $INSTALLER_PATH/$pkg-installer
done

# symbolic link
DOTFILES=(
  .zshrc .ctags .gdbinit .gemrc
  .gitconfig .gitignore .inputrc
  .irbrc .pryrc .rspec .agignore
  .vimrc .vrapperrc .rubocop.yml
  .tmux.conf .tmux-powerlinerc .splintrc
  .dir_colors .rdebugrc .vim/dict )
for file in ${DOTFILES[@]}
do
  ln -sf $DOTFILES_PATH/$file $HOME/$file
done

# NeoBundle
$INSTALLER_PATH/neobundle-installer

cd ${ORIGIN}

exec $SHELL
