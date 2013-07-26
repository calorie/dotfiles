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

mkdir -p $HOME/.zsh
cd $HOME/.zsh
git clone git@github.com:hchbaw/auto-fu.zsh.git
cd $HOME/.zsh/auto-fu.zsh
git checkout pu

mkdir $HOME/.tmux
cd $HOME/.tmux
git clone git@github.com:erikw/tmux-powerline.git
type cmake >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
  git clone git@github.com:thewtex/tmux-mem-cpu-load.git
  ln -sb $DOTFILES_PATH/.tmux/tmux-mem-cpu-load/tmux-mem-cpu-load.cpp $HOME/.tmux/tmux-mem-cpu-load/tmux-mem-cpu-load.cpp
  cd $HOME/.tmux/tmux-mem-cpu-load
  cmake .
  make
  sudo make install
else
  echo "plz install cmake to display used-mem on tmux"
fi

gem i tmuxinator
mv $HOME/.tmuxinator/* $DOTFILES_PATH/.tmux/tmuxinator/
rm -rf $HOME/.tmuxinator
ln -s $DOTFILES_PATH/.tmux/tmuxinator $HOME/.tmuxinator

mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
git clone git@github.com:Shougo/neobundle.vim.git

DOTFILES=(
  .zshrc .zshrc.alias
  .zshrc.linux .zshrc.osx .ctags
  .emacs.el .gdbinit .gemrc .gitconfig
  .gitignore .inputrc .irbrc .sbtconfig
  .screenrc .vimrc .vrapperrc
  import.scala .tmux.conf .tmux-powerlinerc
  .dir_colors .rdebugrc .vim/dict
  .tmux/tmux-powerline/themes/mytheme.sh )

for file in ${DOTFILES[@]}
do
  if [ -e $HOME/$file ]; then
    echo $HOME/$file exist. backup $HOME/$file~ is created.
  fi
  ln -sb $DOTFILES_PATH/$file $HOME/$file
done

cd ${ORIGIN}
vim +NeoBundleInstall +qa

exec $SHELL
