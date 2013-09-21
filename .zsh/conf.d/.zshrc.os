case "${OSTYPE}" in
# Mac(Unix)
darwin*)
  source ~/dotfiles/.zsh/conf.d/.zshrc.osx
  ;;
# Linux
linux*)
  source ~/dotfiles/.zsh/conf.d/.zshrc.linux
  ;;
# freeBSD
freebsd*)
  source ~/dotfiles/.zsh/conf.d/.zshrc.freebsd
  ;;
esac
