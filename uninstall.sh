#!/bin/bash
while :
do
  read -p "uninstall dotfiles? y/n " yn
  if [ $yn = "n" -o $yn = "N" ]; then
    exit
  elif [ $yn = "y" -o $yn = "Y" ]; then
    break
  else
    continue
  fi
done

DOT_FILES=(
  .zshrc .zshrc.alias
  .zshrc.linux .zshrc.osx .ctags
  .emacs.el .gdbinit .gemrc .gitconfig
  .gitignore .inputrc .irbrc .sbtconfig
  .screenrc .vimrc .vrapperrc
  import.scala .tmux.conf .tmux-powerlinerc
  .dir_colors .rdebugrc .tmux .tmuxinator
  .vim/bundle .vim/dict dotfiles )

for file in ${DOT_FILES[@]}
do
  rm -rf $HOME/$file
done
