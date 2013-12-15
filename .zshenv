case "${OSTYPE}" in
# Mac(Unix)
darwin*)
  [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
  ;;
# Linux
linux*)
  export RBENV_ROOT=$HOME/.rbenv
  ;;
esac
if [ -d $RBENV_ROOT ]; then
  export PATH=$PATH:$RBENV_ROOT/bin
  if [ ! -f $HOME/dotfiles/.rbenv_init ]; then
    echo "$(rbenv init - zsh)" > $HOME/dotfiles/.rbenv_init
    sed -i -e "s/rbenv rehash/# rbenv rehash/" $HOME/dotfiles/.rbenv_init
  fi
  source $HOME/dotfiles/.rbenv_init
fi
