# tmux 軽量化 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** tmux の表示機能を維持しながら、status 更新に伴う CPU 使用率と外部 process 起動頻度を下げ、Homebrew prefix の固定値を除去する。

**Architecture:** 既存の tmux-powerline と tmux-mem-cpu-load を維持し、両者の更新周期を 5 秒に揃える。terminfo installer は実行時に Homebrew から ncurses prefix を一度だけ取得する。

**Tech Stack:** tmux 3.7、tmux-powerline、tmux-mem-cpu-load、bash、Homebrew、macOS 13 以降

**Spec:** `docs/superpowers/specs/2026-10-04-terminal-stack-lightweight-design.md`

## Global Constraints

- session 永続化、main session 自動作成、vi copy mode、mouse、clipboard、既存 key binding を維持する。
- status の Git branch、ahead、behind、staged、modified、untracked を維持する。
- CPU、memory、load、battery、weather、date、day、time を維持する。
- tmux-thumbs、detach、attach、current working directory の挙動を維持する。
- Intel Mac の `/usr/local` と Apple Silicon の `/opt/homebrew` を扱う。
- status の最大更新遅延は 5 秒とする。
- 常駐 daemon や独自 status script を追加しない。
- フォールバックを追加しない。必要な command がなければ英語のエラーで失敗させる。
- 各コミットは事前にユーザー承認を得る。

## Review Focus

- tmux-powerline と tmux-mem-cpu-load の更新周期が同じ 5 秒か。
- Git と system 情報が欠落していないか。
- Git repository 外でも status が壊れないか。
- ncurses prefix を Intel / Apple Silicon の双方で解決できるか。
- 既存 session に干渉せず、隔離した tmux server で検証しているか。

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

  `main` の更新と `perf/tmux-lightweight` の作成は書き込みを伴うため、実行前に承認を得る。

- [ ] **Step 3: 更新済み main から branch を作る**

      git switch main
      git pull --ff-only origin main
      git switch -c perf/tmux-lightweight

  Expected: current branch が `perf/tmux-lightweight` で、独自 commit は 0 件。

### Task 1: tmux-256color installer の Homebrew prefix を動的に解決する

**Files:**

- Modify: `bin/installer/tmux-256color-installer`
- Test: bash 構文と一時 HOME

- [ ] **Step 1: 固定 path を確認する**

      rg -n '/opt/brew|/opt/homebrew|/usr/local|ncurses' bin/installer/tmux-256color-installer

  Expected: ncurses の固定 path が表示される。

- [ ] **Step 2: Intel prefix で失敗する現状を確認する**

  `brew --prefix ncurses` が `/usr/local/opt/ncurses` を返す前提の一時 command を PATH 先頭に置き、installer が固定 path を参照することを確認する。書き込み先は承認済みの一時 HOME に限定する。

- [ ] **Step 3: 最小実装を追加する**

  installer の冒頭で `brew` の存在を確認し、なければ `Homebrew is required.` を stderr に出して非 0 で終了させる。`NCURSES_PREFIX=$(brew --prefix ncurses)` を 1 回だけ実行し、その値から terminfo source と `tic` を参照する。既存の一時 directory と trap は維持する。

- [ ] **Step 4: 構文と固定値除去を確認する**

      bash -n bin/installer/tmux-256color-installer
      ! rg -n '/opt/brew|/opt/homebrew|/usr/local' bin/installer/tmux-256color-installer
      brew --prefix ncurses

  Expected: 構文エラーと固定 path がなく、ncurses prefix が取得できる。

- [ ] **Step 5: 隔離環境で installer を実行する**

  書き込み承認後、一時 HOME を作り installer を実行する。生成物を `infocmp -x tmux-256color` で検査し、一時 HOME 以外に書き込まれていないことを確認する。

- [ ] **Step 6: 差分を確認し、コミット承認を得る**

      git diff --check
      git diff -- bin/installer/tmux-256color-installer

  Proposed commit message: `tmux-256color の Homebrew prefix を動的に解決する`

- [ ] **Step 7: 承認後にコミットする**

      git add bin/installer/tmux-256color-installer
      git commit -m 'tmux-256color の Homebrew prefix を動的に解決する'

### Task 2: status 更新周期を 5 秒に揃える

**Files:**

- Modify: `.config/tmux-powerline/config.sh`
- Modify: `.tmux.conf`
- Test: 隔離した tmux server

- [ ] **Step 1: 有効な変更前設定を記録する**

      tmux show-options -g status-interval
      tmux show-options -g status-left
      tmux show-options -g status-right
      ps -axo pid,ppid,%cpu,rss,command

  Expected baseline: `status-interval 1`、tmux-powerline、tmux-mem-cpu-load の設定と process 状態を記録する。

- [ ] **Step 2: 変更前の 30 秒計測を行う**

  GUI と process 監視の承認後、既存 server とは別名の tmux server を現行設定で起動する。30 秒間の tmux server CPU、RSS、tmux-powerline と tmux-mem-cpu-load の起動回数を記録する。

- [ ] **Step 3: 更新周期を変更する**

  次の 2 箇所だけを変更する。

  - `.config/tmux-powerline/config.sh` の `TMUX_POWERLINE_STATUS_INTERVAL="5"`
  - `.tmux.conf` の `status-right` にある tmux-mem-cpu-load に `-i 5` を追加する。

  status の内容、配置、色、key binding は変更しない。

- [ ] **Step 4: 隔離 server で設定を読み込む**

      tmux -L dotfiles-tmux-candidate -f .tmux.conf new-session -d -s main
      tmux -L dotfiles-tmux-candidate show-options -g status-interval
      tmux -L dotfiles-tmux-candidate show-options -g status-left
      tmux -L dotfiles-tmux-candidate show-options -g status-right

  Expected: server が起動し、両 status command が 5 秒周期になる。書き込みを伴う tmux server 起動は事前承認後に実行する。

- [ ] **Step 5: status の機能契約を確認する**

  Git repository 内外の pane で、branch、ahead、behind、staged、modified、untracked、CPU、memory、load、battery、weather、date、day、time を確認する。tmux-thumbs、copy mode、clipboard、mouse、cwd、detach、attach、main session 自動作成も確認する。

- [ ] **Step 6: 変更後の 30 秒計測を行う**

  Task 2 Step 2 と同じ server 条件、同じ 30 秒、同じ command で CPU、RSS、process 起動回数を記録する。

  Expected acceptance:

  - CPU 使用率または status process 起動頻度が 50% 以上低下する。
  - RSS が悪化しない。
  - status の更新遅延が 5 秒以内である。

- [ ] **Step 7: 隔離 server を停止する**

  停止対象を `dotfiles-tmux-candidate` と確認し、事前承認後にその server だけを停止する。

- [ ] **Step 8: 差分を確認し、コミット承認を得る**

      git diff --check
      git diff -- .config/tmux-powerline/config.sh .tmux.conf

  Proposed commit message: `tmux のステータス更新を軽量化する`

- [ ] **Step 9: 承認後にコミットする**

      git add .config/tmux-powerline/config.sh .tmux.conf
      git commit -m 'tmux のステータス更新を軽量化する'

### Task 3: tmux PR を準備する

**Files:**

- Inspect: `.tmux.conf`
- Inspect: `.config/tmux-powerline/config.sh`
- Inspect: `bin/installer/tmux-256color-installer`

- [ ] **Step 1: 最終差分と構文を確認する**

      git diff main...HEAD --check
      bash -n bin/installer/tmux-256color-installer
      bash -n .config/tmux-powerline/config.sh
      rg -n 'STATUS_INTERVAL|tmux-mem-cpu-load' .config/tmux-powerline/config.sh .tmux.conf

  Expected: 差分エラーと構文エラーがなく、両 interval が 5 秒。

- [ ] **Step 2: 計測結果を PR 本文にまとめる**

  30 秒あたりの CPU、RSS、process 起動回数と機能契約の確認結果を表にする。未計測値は記載しない。

- [ ] **Step 3: GitHub 認証状態を確認する**

      gh auth status

  Expected: `github.com` に有効な認証がある。無効なら PR 操作を止め、再認証を依頼する。

- [ ] **Step 4: push の承認を得る**

      git status --short
      git log --oneline main..HEAD

  承認後のみ branch を push する。

- [ ] **Step 5: PR 作成の承認を得る**

  Base は `main`、head は `perf/tmux-lightweight` とする。機能維持、計測値、Intel Mac 対応、残るリスクを本文に明記する。
