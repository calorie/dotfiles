# Ghostty 評価 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:executing-plans to implement this plan task-by-task.

**Goal:** Alacritty と Ghostty を同条件で比較し、機能を完全に維持したうえで十分な軽量化効果がある場合に限り Ghostty へ置き換える。

**Architecture:** Ghostty を候補として隔離設定で導入し、起動時間、idle CPU、RSS、入力、tmux、描画を A/B 評価する。採用基準を満たした場合だけ dotfiles の正式設定と Homebrew 管理対象を切り替える。

**Tech Stack:** Alacritty 0.17、Ghostty stable Universal binary、tmux 3.7、Homebrew Cask、macOS 13 以降

**Spec:** `docs/superpowers/specs/2026-10-04-terminal-stack-lightweight-design.md`

## Global Constraints

- Ghostty stable の Universal binary を使い、Intel Mac と Apple Silicon を同一設定で扱う。
- macOS 13 以降を対象とする。
- 起動、CPU、RSS、依存関係、設定量を計測し、推測で採用しない。
- Alacritty の font、size、color、fullscreen、装飾、Option-as-Alt、opacity、scrollback、cursor、mouse、key binding を維持する。
- Ghostty の採用条件は、RSS または idle CPU が 20% 以上改善し、起動時間が 10% を超えて悪化せず、全機能契約を満たすことである。
- 採用条件を満たさない場合は置換 PR を作らない。
- 実行時 fallback、二重設定、恒久的な併用を追加しない。
- install、uninstall、GUI 起動、設定削除、コミット、push、PR 作成はそれぞれ事前承認を得る。

## Review Focus

- `window-decoration = none` と `fullscreen = non-native` の組み合わせが成立するか。
- Shift+Enter が `1b 0d` の 2 byte を送るか。
- 左右 Option が Alt として動作するか。
- scrollback 0 と mouse hide を維持できるか。
- tmux の `tmux-256color`、RGB、copy mode、key input、Neovim 表示が壊れないか。
- 比較条件と測定回数が Alacritty と Ghostty で同一か。

---

### Task 0: 独立した評価 branch を作る

**Files:**

- Inspect: Git branch と working tree

- [ ] **Step 1: 先行 PR が merge 済みであることを確認する**

      git status --short
      git branch --show-current
      git log --oneline --decorate -10 main

  Expected: working tree が clean で、docs、zsh、tmux の各 PR が `main` に含まれる。Ghostty 置換は `Brewfile` と `.tmux.conf` に重なるため、先行 PR より前には開始しない。

- [ ] **Step 2: branch 操作の承認を得る**

  `main` の更新と `perf/ghostty-evaluation` の作成は書き込みを伴うため、実行前に承認を得る。

- [ ] **Step 3: 更新済み main から branch を作る**

      git switch main
      git pull --ff-only origin main
      git switch -c perf/ghostty-evaluation

  Expected: current branch が `perf/ghostty-evaluation` で、独自 commit は 0 件。

### Task 1: Alacritty の比較基準を固定する

**Files:**

- Inspect: `.config/alacritty/alacritty.toml`
- Inspect: `.config/alacritty/themes/calorie.toml`
- Inspect: `.tmux.conf`
- Output: PR 本文用の測定記録

- [ ] **Step 1: version と application size を記録する**

      alacritty --version
      du -sk /Applications/Alacritty.app

  Expected: version と KiB を記録する。

- [ ] **Step 2: 機能契約表を作る**

  font `HackGen Regular`、size `18`、calorie palette、SimpleFullscreen、装飾なし、左右 Option-as-Alt、opacity 1、scrollback 0、cursor thickness、入力中 mouse hide、Command 系 font size/fullscreen、Shift+Enter の各項目を記録する。

- [ ] **Step 3: 起動時間を 5 回計測する**

  GUI 起動の事前承認後、同じ `/usr/bin/true` command、同じ測定方法で短時間起動を 5 回行う。初回 warm-up は比較値から除外する。

- [ ] **Step 4: idle CPU と RSS を 30 秒計測する**

  空の shell を 1 window で表示し、30 秒間の CPU と RSS を同じ間隔で記録する。ほかの Alacritty process と識別できる PID を使う。

### Task 2: Ghostty の隔離候補設定を作る

**Files:**

- Create: `.config/ghostty/config.ghostty`
- Test: Ghostty の設定検査と隔離起動

- [ ] **Step 1: install の承認を得る**

      brew install --cask ghostty

  Homebrew と `/Applications` に書き込むため、明示承認後のみ実行する。

- [ ] **Step 2: install 結果と対応機能を確認する**

      ghostty --version
      ghostty +show-config --default --docs
      ghostty +list-fonts

  Expected: stable version、対象 key、`HackGen` font が確認できる。不足があれば設定作成を止め、原因を報告する。

- [ ] **Step 3: 設定がまだないことを示す**

      test -f .config/ghostty/config.ghostty

  Expected before implementation: 終了コードが非 0。

- [ ] **Step 4: 最小の候補設定を追加する**

  `.config/ghostty/config.ghostty` に次を設定する。

      font-family = HackGen
      font-style = Regular
      font-size = 18
      fullscreen = non-native
      window-decoration = none
      macos-option-as-alt = true
      mouse-hide-while-typing = true
      scrollback-limit = 0
      background-opacity = 1
      shell-integration = none
      cursor-style = block
      cursor-style-blink = false
      keybind = cmd+0=reset_font_size
      keybind = cmd+equal=increase_font_size:1
      keybind = cmd+plus=increase_font_size:1
      keybind = cmd+minus=decrease_font_size:1
      keybind = cmd+enter=toggle_fullscreen
      keybind = shift+enter=text:\x1b\r

  色は Alacritty calorie theme から次の値を移植する。

      background = #191724
      foreground = #c9c8db
      cursor-color = #31748f
      cursor-text = #c9c8db
      selection-background = #403d52
      selection-foreground = #c9c8db
      palette = 0=#26233a
      palette = 1=#d66b7f
      palette = 2=#31748f
      palette = 3=#f3cc95
      palette = 4=#9ccfd8
      palette = 5=#c4a7e7
      palette = 6=#ebbcba
      palette = 7=#c9c8db
      palette = 8=#6e6a86
      palette = 9=#d66b7f
      palette = 10=#31748f
      palette = 11=#f3cc95
      palette = 12=#9ccfd8
      palette = 13=#c4a7e7
      palette = 14=#ebbcba
      palette = 15=#c9c8db

  Alacritty の hint、vi mode cursor、line indicator は Ghostty に同名設定がないため、対応する UI を実機で比較する。視認性または操作が変わる場合は機能契約未達として採用しない。

- [ ] **Step 5: default 設定を排除して検査する**

      ghostty --config-default-files=false --config-file=/Users/yu/dotfiles/.config/ghostty/config.ghostty -e /usr/bin/true

  Expected: 設定 error なしで終了する。GUI 起動は事前承認後に実行する。

### Task 3: Ghostty を同条件で計測し、採否を決める

**Files:**

- Inspect: `.config/ghostty/config.ghostty`
- Output: PR 本文用の A/B 比較表

- [ ] **Step 1: 起動時間を 5 回計測する**

  Task 1 Step 3 と同じ command、同じ測定方法、同じ回数で Ghostty を計測する。初回 warm-up は除外する。

- [ ] **Step 2: idle CPU と RSS を 30 秒計測する**

  Task 1 Step 4 と同じ shell、window 数、時間、sampling interval で計測する。

- [ ] **Step 3: 入力 byte を確認する**

  `od -An -tx1` で Shift+Enter が `1b 0d` を送り、左右 Option 組み合わせが Alt sequence を送ることを確認する。

- [ ] **Step 4: 表示と tmux 契約を確認する**

  font、size、全 palette、fullscreen、装飾、opacity、scrollback、cursor、mouse hide、font size key、tmux attach/copy mode/key input、RGB、Neovim 表示を確認する。

- [ ] **Step 5: 採用 gate を判定する**

  次をすべて満たす場合だけ Task 4 へ進む。

  - RSS または idle CPU が Alacritty より 20% 以上改善する。
  - 起動時間の悪化が 10% 以下である。
  - 機能契約に未達がない。
  - Intel Mac で使用可能な stable Universal binary である。

  満たさない場合は理由と計測値を記録し、候補設定削除と Ghostty uninstall の承認を得る。置換 PR は作らない。

### Task 4: 採用時だけ Alacritty を Ghostty に置き換える

**Files:**

- Modify: `Brewfile`
- Modify: `.tmux.conf`
- Modify: `script/setup`
- Modify: `script/uninstall`
- Keep: `.config/ghostty/config.ghostty`
- Delete: `.config/alacritty/alacritty.toml`
- Delete: `.config/alacritty/themes/calorie.toml`
- Do not modify: `.wezterm.lua`

- [ ] **Step 1: package と symlink 管理を切り替える**

  `Brewfile` の Alacritty cask を Ghostty に置き換え、setup と uninstall の対象 directory を Ghostty に切り替える。install/uninstall の対称性を保つ。

- [ ] **Step 2: tmux の terminal capability を Ghostty に合わせる**

  tmux の default terminal は `tmux-256color` のまま維持し、`xterm-ghostty:RGB` を terminal overrides に設定する。extended keys は実機検証で必要性を確認できた場合だけ追加する。

- [ ] **Step 3: Alacritty 設定削除の承認を得る**

  削除対象を 2 ファイルに限定して提示し、明示承認後のみ削除する。`.wezterm.lua` は変更しない。

- [ ] **Step 4: 構成の整合性を確認する**

      ! rg -n 'Alacritty|alacritty' Brewfile script/setup script/uninstall .tmux.conf .config/ghostty
      rg -n 'Ghostty|ghostty' Brewfile script/setup script/uninstall .tmux.conf .config/ghostty
      ghostty --config-default-files=false --config-file=/Users/yu/dotfiles/.config/ghostty/config.ghostty -e /usr/bin/true

  Expected: 対象範囲に Alacritty 参照がなく、Ghostty の install、設定、uninstall が揃い、隔離起動が成功する。

- [ ] **Step 5: clean install と uninstall の対称性を確認する**

  書き込み承認後、一時 HOME で setup と uninstall の該当処理を検査する。既存 HOME の terminal 設定には触れない。

- [ ] **Step 6: 差分を確認し、コミット承認を得る**

      git diff --check
      git diff -- Brewfile .tmux.conf script/setup script/uninstall .config/ghostty .config/alacritty

  Proposed commit message: `Alacritty を Ghostty に置き換える`

- [ ] **Step 7: 承認後にコミットする**

      git add Brewfile .tmux.conf script/setup script/uninstall .config/ghostty .config/alacritty
      git commit -m 'Alacritty を Ghostty に置き換える'

### Task 5: 採用時だけ Ghostty PR を準備する

**Files:**

- Inspect: Task 4 の全対象

- [ ] **Step 1: 最終検証を実行する**

      git diff main...HEAD --check
      brew bundle check --file Brewfile
      bash -n script/setup
      bash -n script/uninstall

  Expected: 差分、Brewfile、shell 構文に error がない。

- [ ] **Step 2: A/B 比較表を PR 本文にまとめる**

  起動時間、idle CPU、RSS、application size、設定行数、機能契約、Intel Mac 対応を記載する。採用 gate の計算式と結果を明記する。

- [ ] **Step 3: GitHub 認証状態を確認する**

      gh auth status

  Expected: `github.com` に有効な認証がある。無効なら PR 操作を止め、再認証を依頼する。

- [ ] **Step 4: push の承認を得る**

      git status --short
      git log --oneline main..HEAD

  承認後のみ branch を push する。

- [ ] **Step 5: PR 作成の承認を得る**

  Base は `main`、head は `perf/ghostty-evaluation` とする。計測値、採用 gate、完全な機能契約、Intel Mac 対応、残るリスクを本文に明記する。
