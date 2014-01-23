case "${OSTYPE}" in
# Mac(Unix)
darwin*)
  [ -f /opt/boxen/env.sh ] && source /opt/boxen/env.sh
  ;;
# Linux
linux*)
  export RBENV_ROOT=$HOME/.rbenv
  export PATH="$RBENV_ROOT/bin:${PATH}"
  ;;
esac
if [ -d $RBENV_ROOT ]; then
  export PATH="$RBENV_ROOT/shims:${PATH}"
  eval "$(rbenv init - --no-rehash zsh)"
fi
