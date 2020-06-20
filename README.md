dotfiles
========
## Requirements

- zsh
- tmux >= 1.7
- git
- ruby
- fontforge

### Optional

- boxen (for mac)
- cmake (tmux-mem-cpu-load)
- lua (neocomplete)

## Setup

```
$ git clone git://github.com/calorie/dotfiles.git ~/dotfiles
$ cd ~/dotfiles
$ ./script/setup
```

### GoogleJapaneseInput

#### キー設定

環境設定 > 一般 > キー設定の選択 編集 > 編集 > インポート

```
~/dotfiles/.config/GoogleJapaneseInput/keymap.txt
```

#### 辞書登録

辞書ツール > 管理 > 選択した辞書にインポート

```
~/dotfiles/.config/GoogleJapaneseInput/dictionary.txt
```

### Installed packages

- [RictyDiminished](https://github.com/edihbrandon/RictyDiminished)
- [auto-fu](https://github.com/hchbaw/auto-fu.zsh)
- [powerline-shell](https://github.com/milkbikis/powerline-shell)
- [tmux-powerline](https://github.com/erikw/tmux-powerline)
- [tmux-mem-cpu-load](https://github.com/thewtex/tmux-mem-cpu-load)
- [tmuxinator](https://github.com/tmuxinator/tmuxinator)
- [some vim plugins](https://github.com/calorie/dotfiles/blob/master/.vim/conf.d/.vimrc.bundle)

## Uninstall

```
$ cd ~/dotfiles
$ ./script/uninstall
```
