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
  eval "$(rbenv init - --no-rehash)"
fi
