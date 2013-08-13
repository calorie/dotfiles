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

exec $SHELL

# ricty
if [ -x `which fontforge` ];then
  git clone https://github.com/yascentur/Ricty.git ~/Ricty
  cd $HOME/Ricty
  wget http://levien.com/type/myfonts/Inconsolata.otf
  wget -O mig1m.zip 'http://sourceforge.jp/frs/redir.php?m=jaist&f=%2Fmix-mplus-ipa%2F57240%2Fmigu-1m-20121030.zip'
  unzip mig1m.zip
  sh ricty_generator.sh auto
  wget https://raw.github.com/Lokaltog/vim-powerline/develop/fontpatcher/PowerlineSymbols.sfd
  wget https://raw.github.com/Lokaltog/vim-powerline/develop/fontpatcher/fontpatcher
  fontforge -lang=py -script fontpatcher Ricty-Regular.ttf
  mkdir $HOME/.fonts
  cp -f Ricty* ~/.fonts
  fc-cache -vf
  rm -rf $HOME/Ricty
fi

# vvm
curl https://raw.github.com/kana/vim-version-manager/master/bin/vvm | python - setup
$DOTFILES_PATH/bin/vvm_install vimorg--v7-4

# rbenv
git clone https://github.com/sstephenson/rbenv.git ~/.rbenv
mkdir -p ~/.rbenv/plugins
cd ~/.rbenv/plugins
git clone https://github.com/sstephenson/ruby-build.git
git clone https://github.com/tpope/rbenv-ctags.git
git clone https://github.com/jamis/rbenv-gemset.git
export PATH=$PATH:$HOME/.rbenv/bin/:$HOME/.rbenv
rbenv init - zsh
# 1.9.3
rbenv install 1.9.3-p448
# 2.0.0
rbenv install 2.0.0-p247
rbenv global 1.9.3-p448
rbenv rehash
# init
echo "$(rbenv init - zsh)" > $HOME/dotfiles/.rbenv_init
sed -i -e "s/rbenv rehash/# rbenv rehash/" $HOME/dotfiles/.rbenv_init

# auto-fu
mkdir -p $HOME/.zsh
cd $HOME/.zsh
git clone https://github.com/hchbaw/auto-fu.zsh.git
cd $HOME/.zsh/auto-fu.zsh
git checkout pu

# tmux-powerline
mkdir $HOME/.tmux
cd $HOME/.tmux
git clone https://github.com/erikw/tmux-powerline.git
ln -sb $DOTFILES_PATH/.tmux/tmux-powerline/themes/mytheme.sh \
  $HOME/.tmux/tmux-powerline/themes/mytheme.sh
type cmake >/dev/null 2>&1
if [ "$?" -eq 0 ]; then
  git clone https://github.com/thewtex/tmux-mem-cpu-load.git
  ln -sb $DOTFILES_PATH/.tmux/tmux-mem-cpu-load/tmux-mem-cpu-load.cpp \
    $HOME/.tmux/tmux-mem-cpu-load/tmux-mem-cpu-load.cpp
  cd $HOME/.tmux/tmux-mem-cpu-load
  cmake .
  make
  sudo make install
else
  echo "plz install cmake to display used-mem on tmux"
fi

# tmuxinator
gem i tmuxinator
mv $HOME/.tmuxinator/* $DOTFILES_PATH/.tmux/tmuxinator/
rm -rf $HOME/.tmuxinator
ln -s $DOTFILES_PATH/.tmux/tmuxinator $HOME/.tmuxinator

# NeoBundle
mkdir -p $HOME/.vim/bundle
cd $HOME/.vim/bundle
git clone https://github.com/Shougo/neobundle.vim.git

cd ${ORIGIN}
vim +NeoBundleInstall +qa

exec $SHELL
