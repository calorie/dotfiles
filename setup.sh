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

INSTALLERS=(
  ricty vvm
  rbenv auto-fu
  tmux-powerline
  tmux-mem-cpu-load
  tmuxinator )
for installer in ${INSTALLERS[@]}
do
  source $INSTALLER_PATH/$installer-installer
done

# symbolic link
DOTFILES=(
  .zshrc .zshrc.alias
  .zshrc.linux .zshrc.osx .ctags
  .emacs.el .gdbinit .gemrc .gitconfig
  .gitignore .inputrc .irbrc .sbtconfig
  .screenrc .vimrc .vrapperrc
  import.scala .tmux.conf .tmux-powerlinerc
  .dir_colors .rdebugrc .vim/dict )
mkdir -p $HOME/.vim
for file in ${DOTFILES[@]}
do
  if [ -e $HOME/$file ]; then
    echo $HOME/$file exist. backup $HOME/$file~ is created.
  fi
  ln -sb $DOTFILES_PATH/$file $HOME/$file
done

# NeoBundle
source $INSTALLER_PATH/neobundle-installer

cd ${ORIGIN}

exec $SHELL
