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
  ricty rbenv
  vvm auto-fu
  tmux-powerline
  tmux-mem-cpu-load
  tmuxinator )
for pkg in ${PKGS[@]}
do
  $INSTALLER_PATH/$pkg-installer
done

# symbolic link
DOTFILES=(
  .zshrc .zshrc.alias
  .zshrc.linux .zshrc.osx .ctags
  .gdbinit .gemrc .gitconfig
  .gitignore .inputrc .irbrc .sbtconfig
  .screenrc .vimrc .vrapperrc
  import.scala .tmux.conf .tmux-powerlinerc
  .dir_colors .rdebugrc .vim/dict )
for file in ${DOTFILES[@]}
do
  ln -sb $DOTFILES_PATH/$file $HOME/$file
done

# NeoBundle
$INSTALLER_PATH/neobundle-installer

cd ${ORIGIN}

exec $SHELL
