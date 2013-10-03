#!/bin/bash
while :
do
  read -p "update? y/n " yn
  if [ $yn = "n" -o $yn = "N" ]; then
    exit
  elif [ $yn = "y" -o $yn = "Y" ]; then
    break
  else
    continue
  fi
done

ORIGIN=$(pwd)

# tmuxinator
gem install tmuxinator

# tmux-mem-cpu-load
cd $HOME/.tmux/tmux-mem-cpu-load/
git reset --hard HEAD
git pull --rebase origin master
sed -i -e "s/ << ' ' << load_string( use_colors )//" $HOME/.tmux/tmux-mem-cpu-load/tmux-mem-cpu-load.cpp
cmake .
make
sudo make install

# tmux-powerline
cd $HOME/.tmux/tmux-powerline/
git pull --rebase origin master

# vvm
vvm update_itself

# auto-fu
cd $HOME/.zsh/auto-fu.zsh
git pull --rebase origin pu

# rbenv
cd $HOME/.rbenv
git pull --rebase origin master

# rbenv-ctags
cd $HOME/.rbenv/plugins/rbenv-ctags
git pull --rebase origin master

# rbenv-default-gems
cd $HOME/.rbenv/plugins/rbenv-default-gems
git pull --rebase origin master

# ruby-build
cd $HOME/.rbenv/plugins/ruby-build
git pull --rebase origin master

# vim plugins
vim +NeoBundleUpdate +qa

cd ${ORIGIN}
exec $SHELL
