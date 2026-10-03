# zsh 軽量化 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** 現行の zsh 機能を維持しながら、プロンプト描画コストと Homebrew prefix の固定値を除去する。

**Architecture:** zsh 標準の prompt expansion で現在ディレクトリ表示を構成し、外部プロセスを prompt hook から外す。Homebrew prefix は zsh の command hash から実行ファイル位置を取得し、shell 起動時に brew を実行しない。

**Tech Stack:** zsh 5.9、Homebrew、ShellCheck 相当の構文確認、macOS 13 以降

**Spec:** `docs/superpowers/specs/2026-10-04-terminal-stack-lightweight-design.md`

## Global Constraints

- 現行の alias、option、PATH、環境変数、補完、履歴、キーバインドを維持する。
- direnv、rbenv、nodenv の遅延初期化を維持する。
- enhancd、peco、mkcd、local rc、tmux 自動起動を維持する。
- Intel Mac の標準 Homebrew prefix `/usr/local` と Apple Silicon の `/opt/homebrew` を扱う。
- shell 起動時に `brew --prefix` を実行しない。
- フォールバックを追加しない。Homebrew がない場合は英語の明確なエラーで失敗させる。
- 変更前後を同じコマンド、同じ回数で計測する。
- 各コミットは事前にユーザー承認を得る。

## Review Focus

- `brew` がない場合に英語のエラーを stderr に出し、非 0 で終了するか。
- `/usr/local`、`/opt/homebrew`、カスタム prefix を同じロジックで扱えるか。
- symlink 解決によって `Homebrew/Homebrew` を prefix と誤認しないか。
- 空白や `%` を含むパスでも prompt 表示が壊れないか。
- tmux 自動起動、local rc、補完、履歴、遅延初期化に回帰がないか。

---

### Task 0: 独立した実装 branch を作る

**Files:**

- Inspect: Git branch と working tree

- [ ] **Step 1: docs PR が merge 済みであることを確認する**

      git status --short
      git branch --show-current
      git log --oneline --decorate -5 main

  Expected: working tree が clean で、端末スタック設計と本計画が `main` に含まれる。

- [ ] **Step 2: branch 操作の承認を得る**

  `main` の更新と `perf/zsh-lightweight` の作成は書き込みを伴うため、実行前に承認を得る。

- [ ] **Step 3: 更新済み main から branch を作る**

      git switch main
      git pull --ff-only origin main
      git switch -c perf/zsh-lightweight

  Expected: current branch が `perf/zsh-lightweight` で、独自 commit は 0 件。

### Task 1: Homebrew prefix を動的に解決する

**Files:**

- Modify: `.zsh/.zshrc.osx`
- Test: zsh の一時プロセス

- [ ] **Step 1: 現在の固定値を確認する**

      rg -n 'uname -m|/opt/brew|homebrew' .zsh/.zshrc.osx

  Expected: Intel 判定と `/opt/brew` の固定値が表示される。

- [ ] **Step 2: Intel Homebrew の失敗を再現する**

      /bin/zsh -fc 'commands[brew]=/usr/local/bin/brew; source ./.zsh/.zshrc.osx; print -r -- $PREFIX'

  Expected before implementation: `/usr/local` にならない、または固定値由来の誤った結果になる。

- [ ] **Step 3: 最小実装を追加する**

  `.zsh/.zshrc.osx` で次を実装する。

  - `$commands[brew]` が空なら `Homebrew is required.` を stderr に出して `return 1` する。
  - brew 実行ファイルの親ディレクトリを 2 階層たどって prefix を得る。
  - `:A` は使わない。Homebrew の symlink 実体まで解決すると prefix を誤るためである。
  - `uname -m` と prefix の固定値を削除する。

- [ ] **Step 4: 3 種類の prefix を確認する**

      /bin/zsh -fc 'commands[brew]=/opt/homebrew/bin/brew; source ./.zsh/.zshrc.osx; print -r -- $PREFIX'
      /bin/zsh -fc 'commands[brew]=/usr/local/bin/brew; source ./.zsh/.zshrc.osx; print -r -- $PREFIX'
      /bin/zsh -fc 'commands[brew]=/opt/brew/bin/brew; source ./.zsh/.zshrc.osx; print -r -- $PREFIX'

  Expected: 順に `/opt/homebrew`、`/usr/local`、`/opt/brew`。

- [ ] **Step 5: Homebrew 不在時の失敗を確認する**

      env PATH=/usr/bin:/bin /bin/zsh -fc 'source ./.zsh/.zshrc.osx'

  Expected: stderr に `Homebrew is required.` を出し、終了コードが非 0。

- [ ] **Step 6: 差分を確認し、コミット承認を得る**

      git diff --check
      git diff -- .zsh/.zshrc.osx

  Proposed commit message: `zsh で Homebrew prefix を動的に解決する`

- [ ] **Step 7: 承認後にコミットする**

      git add .zsh/.zshrc.osx
      git commit -m 'zsh で Homebrew prefix を動的に解決する'

### Task 2: powerline-go を zsh 標準 prompt に置き換える（不採用）

この案は directory ごとの segment 表示を維持できなかったため、merge 後に取り消した。以下は不採用案と検証経緯の記録として残す。

**Files:**

- Modify: `.zsh/.zshrc.utility`
- Modify: `Brewfile`
- Test: zsh の一時プロセス

- [ ] **Step 1: 変更前の prompt コストを再計測する**

      /usr/bin/time -p /bin/zsh -fc 'repeat 100 { powerline-go -error 0 -shell zsh -eval -modules cwd >/dev/null }'

  Expected baseline: 100 回の実行時間を記録する。

- [ ] **Step 2: 変更前の shell 起動時間を再計測する**

      /usr/bin/time -p env TMUX=1 /bin/zsh -fc 'repeat 30 { /bin/zsh -i -c exit }'

  Expected baseline: 30 回の合計時間と平均値を記録する。

- [ ] **Step 3: powerline hook が存在することを示す検査を実行する**

      TMUX=1 /bin/zsh -ic '! (typeset -p precmd_functions | grep -q powerline_precmd)'

  Expected before implementation: powerline hook が存在するため非 0。

- [ ] **Step 4: zsh 標準 prompt に置き換える**

  `.zsh/.zshrc.utility` の powerline-go 関数と hook を削除し、次の prompt を設定する。

      PROMPT='%F{15}%K{31} %~ %k%F{31}%f '

  `Brewfile` から powerline-go を削除する。`%~` により home 短縮と現在ディレクトリの動的表示を維持する。

- [ ] **Step 5: 外部 prompt hook が消えたことを確認する**

      ! rg -n 'powerline-go|powerline_precmd' .zsh/.zshrc.utility Brewfile
      TMUX=1 /bin/zsh -ic 'typeset -p precmd_functions; print -r -- $PROMPT'

  Expected: powerline 参照なし。prompt に `%~` が含まれる。

- [ ] **Step 6: 特殊な作業ディレクトリを確認する**

      /bin/zsh -fc 'cd /tmp; PROMPT="%F{15}%K{31} %~ %k%F{31}%f "; print -P -- "$PROMPT"'

  Expected: ANSI 装飾を含め、`/tmp` が表示される。書き込み承認後に空白と `%` を含む一時ディレクトリを作り、同じ検査を行う。

- [ ] **Step 7: 起動と prompt コストを再計測する**

      /usr/bin/time -p env TMUX=1 /bin/zsh -fc 'repeat 30 { /bin/zsh -i -c exit }'
      /usr/bin/time -p /bin/zsh -fc 'PROMPT="%F{15}%K{31} %~ %k%F{31}%f "; repeat 100 { print -P -- "$PROMPT" >/dev/null }'

  Expected: shell 起動時間に有意な悪化がなく、外部 prompt process 100 回分が消える。

- [ ] **Step 8: 機能契約を確認する**

  一時 shell で alias、peco、enhancd、mkcd、PATH、補完、履歴設定、Ctrl-P、Ctrl-N、Ctrl-R、direnv、rbenv、nodenv、local rc、tmux 自動起動を確認する。

- [ ] **Step 9: 差分を確認し、コミット承認を得る**

      git diff --check
      git diff -- .zsh/.zshrc.utility Brewfile

  Proposed commit message: `zsh のプロンプトを標準機能で軽量化する`

- [ ] **Step 10: 承認後にコミットする**

      git add .zsh/.zshrc.utility Brewfile
      git commit -m 'zsh のプロンプトを標準機能で軽量化する'

### Task 3: zsh PR を準備する

**Files:**

- Inspect: `.zsh/.zshrc.osx`
- Inspect: `.zsh/.zshrc.utility`
- Inspect: `Brewfile`

- [ ] **Step 1: 最終差分と構文を確認する**

      git diff main...HEAD --check
      /bin/zsh -n .zsh/.zshrc.osx
      /bin/zsh -n .zsh/.zshrc.utility
      brew bundle list --file Brewfile >/dev/null
      brew bundle list --file Brewfile --brews | rg '^powerline-go$'

  Expected: 差分エラーと構文エラーがなく、Brewfile を解析でき、powerline-go が含まれる。

- [ ] **Step 2: 計測結果を PR 本文にまとめる**

  startup、prompt 100 回、維持する dependency 容量、Intel / Apple Silicon の検査結果を表にする。未計測値は記載しない。

- [ ] **Step 3: GitHub 認証状態を確認する**

      gh auth status

  Expected: `github.com` に有効な認証がある。無効なら PR 操作を止め、再認証を依頼する。

- [ ] **Step 4: push の承認を得る**

      git status --short
      git log --oneline main..HEAD

  承認後のみ branch を push する。

- [ ] **Step 5: PR 作成の承認を得る**

  Base は `main`、head は `perf/zsh-lightweight` とする。機能維持、計測値、Intel Mac 対応、残るリスクを本文に明記する。
