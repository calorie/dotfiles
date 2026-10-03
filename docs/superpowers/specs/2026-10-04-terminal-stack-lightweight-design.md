# 端末スタック軽量化設計

- 作成日：2026-10-04
- 対象：Alacritty、tmux、zsh と直接関係する依存
- 対応環境：macOS 13 以降、Apple Silicon および Intel
- 状態：ユーザーレビュー待ち

## 1. 背景

現在の端末環境は Alacritty から zsh を起動し、zsh が main セッションの tmux へ自動接続する。機能を維持しながら、起動時間、常駐 CPU、メモリ、依存容量、設定量を削減する。

保守性を下げる独自デーモン、大規模なステータススクリプト、実行時フォールバックは導入しない。変更はコンポーネント単位の独立した PR とし、各 PR で変更前後を計測する。

## 2. 現状の計測値

計測日は 2026-10-04。プロセス値は Apple Silicon Mac 上の観測値である。

| 対象 | 計測値 |
| --- | ---: |
| zsh 起動 20 回 | 合計 0.91 秒、平均約 45.5 ms |
| compinit | 34.87 ms、zprof 内の 97.89% |
| powerline-go 100 回 | 合計 0.76 秒、平均約 7.6 ms |
| Alacritty RSS | 122,592 KB |
| tmux server RSS | 5,664 KB |
| zsh RSS | 約 5–6 MB |
| tmux server CPU | 1 回の観測で 1.9% |
| tmux-powerline 子プロセス RSS | 1 プロセス約 7.5 MB |
| tmux-powerline | 2.7 MB |
| tmux-thumbs | 38 MB |
| zsh-defer | 252 KB |
| enhancd | 2.1 MB |
| Alacritty 実行ファイル | 13 MB |
| tmux 実行ファイル | 980 KB |
| zsh 実行ファイル | 640 KB |
| powerline-go 実行ファイル | 3.1 MB |
| tmux-mem-cpu-load 実行ファイル | 80 KB |

tmux の実効 status-interval は 1 秒である。設定上、status-left、status-right、通常ウィンドウ、選択中ウィンドウ、tmux-mem-cpu-load の外部処理が定期実行される。正確な平均 CPU と子プロセス頻度は、隔離した tmux server で再計測する。

## 3. 目的

- zsh の操作可能になるまでの時間と、各プロンプト表示の待ち時間を短縮する。
- tmux の定期的な外部処理と平均 CPU 使用量を削減する。
- Alacritty と Ghostty を同条件で比較し、明確な利点がある場合のみ置き換える。
- 不要になった依存と設定を削除する。
- Apple Silicon と Intel の固定パス差分を安全に扱う。
- 現在利用している機能、キー操作、表示情報を維持する。

## 4. 対象外

- tmux の永続セッションを端末エミュレータのタブや分割へ移行しない。
- zsh を fish または Nushell へ移行しない。
- tmux を Zellij または WezTerm multiplexer へ移行しない。
- Neovim など、端末スタックと無関係な設定を変更しない。
- 計測で効果を確認できない最適化を行わない。
- 将来用途だけを目的とした抽象化や設定項目を追加しない。

## 5. 機能契約

### 5.1 端末

- HackGen Regular、18 pt
- 既存の配色
- 起動時の全画面表示
- ウィンドウ装飾なし
- 左右の Option キーを Alt として使用
- Command + 0、Command + Plus、Command + Minus によるフォントサイズ操作
- Shift + Enter で Escape と Carriage Return を送信
- 入力時にマウスカーソルを非表示
- スクロール履歴 0
- 現在のカーソル表示
- tmux と Neovim の True Color 表示

### 5.2 tmux

- main セッションへの自動接続
- vi copy mode、マウス、クリップボード連携
- 現在の prefix と全キーバインド
- 100,000 行の履歴
- 上部ステータスバー
- カレントディレクトリ
- Git の branch、ahead、behind、staged、modified、untracked
- CPU、メモリ、load average
- バッテリー、天気、曜日、日付、時刻
- tmux-thumbs
- セッションの detach／attach

### 5.3 zsh

- 現在ディレクトリを表示するプロンプト
- 現在の alias、shell option、PATH、環境変数
- 補完と履歴
- Ctrl + P、Ctrl + N、Ctrl + R
- direnv、rbenv、nodenv
- enhancd と peco
- mkcd
- .zshrc.local
- tmux の自動起動

## 6. 設計原則

1. 実装前後を同条件で計測する。
2. 既存の標準機能を外部依存より優先する。
3. 独自コードより、保守中の既存ツールを優先する。
4. 変更は小さく分割し、原因と効果を混在させない。
5. 失敗を隠すフォールバックを実装しない。
6. 採用基準を満たさない変更は製品差分へ残さない。

## 7. 変更構成

### 7.1 zsh

powerline-go の precmd hook を削除し、zsh 標準の prompt 展開で現在ディレクトリを表示する。外観の Powerline 区切りは、約 7.6 ms／prompt と 3.1 MB の依存削減に値するため簡素化を許容する。

Homebrew prefix は uname による固定値選択を廃止し、zsh が保持する brew の実体パスから subprocess なしで導出する。brew が見つからない場合は、英語のエラー Homebrew is required. を表示して失敗させる。

この PR では compinit、zsh-defer、direnv、rbenv、nodenv、enhancd、peco を変更しない。これらを同時に変更すると、起動時間の変化と互換性問題の原因を分離できないためである。

変更候補：

- .zsh/.zshrc.utility
- .zsh/.zshrc.osx
- Brewfile

### 7.2 tmux

tmux-powerline と現在のセグメントを維持する。独自の代替ステータス実装は追加しない。

TMUX_POWERLINE_STATUS_INTERVAL を 1 秒から 4 秒へ変更し、tmux-mem-cpu-load の CPU 採取時間は既定の 1 秒を維持する。tmux-mem-cpu-load の `-i` は再描画周期ではなく CPU 採取時間を変更するため、指定しない。表示している時刻は分単位、天気は 600 秒キャッシュであるため、4 秒更新でも情報は維持される。隔離計測では外部 process 起動頻度が 0.500058 Hz から 0.250017 Hz へ 50.00% 低下し、最大起動間隔は 4.037 秒だった。

tmux-256color のセットアップでは、アーキテクチャ別の固定 prefix ではなく、セットアップ時に brew --prefix ncurses を 1 回だけ実行する。対話シェル起動時には brew subprocess を追加しない。

変更候補：

- .config/tmux-powerline/config.sh
- .tmux.conf
- bin/installer/tmux-256color-installer

### 7.3 Ghostty 評価

Ghostty は macOS 13 以降の Apple Silicon／Intel Universal Binary を評価対象とする。Alacritty と同じ zsh、tmux、フォント、画面サイズで比較する。

候補設定では、機能契約に記載したフォント、色、全画面、装飾、Option／Alt、Shift + Enter、フォントサイズ操作、スクロール履歴、カーソルを再現する。tmux の terminal-features は Ghostty の TERM に合わせる。

採用基準を満たした場合のみ、Alacritty の Brew cask と設定を Ghostty へ置き換える。採用時は Alacritty を恒久的に併存させず、実行時フォールバックも設けない。基準未達の場合は Ghostty の製品差分を作成せず、PR も作成しない。

採用時の変更候補：

- Brewfile
- .config/ghostty/config.ghostty
- .config/alacritty
- .tmux.conf
- script/setup
- script/uninstall

## 8. ツール置換の判断

| 候補 | 判断 | 理由 |
| --- | --- | --- |
| Alacritty から Ghostty | 実測対象 | Universal Binary で機能再現が可能。性能は未計測 |
| Alacritty と tmux から WezTerm | 不採用 | multiplexer が発展途上で、永続セッションの移行負担が大きい |
| tmux から Zellij | 不採用 | 操作体系とプラグインが変わり、完全な機能維持にならない |
| zsh から fish／Nushell | 不採用 | 現在の zsh は十分軽く、全面移植の保守負担が大きい |
| powerline-go から zsh 標準 prompt | 採用 | subprocess と依存を同時に削減できる |
| rbenv と nodenv から mise | 後続評価 | Ruby／Node.js を統合できるが、プロジェクト互換性の調査が必要 |
| enhancd と peco から zoxide と fzf | 後続評価 | 保守性向上の可能性があるが、操作差と依存容量の実測が必要 |

mise と zoxide は、3 つのコア PR 完了後に別の設計と PR で扱う。

## 9. エラー処理

- Homebrew が必要な箇所では、存在確認後に英語のエラーを表示して失敗する。
- tmux plugin が欠落した場合に代替表示へ切り替えない。セットアップまたは設定読み込みの失敗として扱う。
- Ghostty の機能再現に失敗した場合は採用しない。
- ネットワークを使う天気表示が失敗する問題は、既存のキャッシュ動作を維持し、別の情報源へ自動切り替えない。
- テスト用 tmux server と端末候補は現行セッションから分離する。

## 10. 検証

### 10.1 zsh

- zsh -n による構文確認
- 対話シェルを 30 回以上起動し、中央値と平均を比較
- zprof による初期化処理の比較
- prompt 表示を 100 回以上実行し、平均時間を比較
- alias、option、補完、履歴検索、direnv、Ruby、Node.js、enhancd、peco、mkcd、.zshrc.local を確認
- prompt 表示時の powerline-go subprocess がなくなったことを確認

### 10.2 tmux

- 一時 socket を使った隔離 tmux server で構文確認
- show-options と list-keys による設定・キーバインド比較
- Git、CPU／メモリ、バッテリー、天気、日時、ウィンドウ表示の確認
- 現行と候補を各 30 秒以上測定し、tmux server と子プロセスの平均 CPU／RSS を比較
- status 更新間隔と tmux-mem-cpu-load の測定間隔を確認

### 10.3 Ghostty

- Alacritty と Ghostty を各 5 回以上起動
- 起動時間、アイドル CPU、RSS、アプリ容量を比較
- フォント、色、全画面、Option／Alt、Shift + Enter、フォントサイズ、Neovim、True Color を目視確認
- Apple Silicon で性能を測定
- Intel は Universal Binary、Homebrew cask、設定構文を確認し、性能未計測であることを PR に明記

## 11. 採用基準

### zsh

- powerline-go 依存 3.1 MB を削除できる。
- prompt 表示の約 7.6 ms の外部処理を削除できる。
- シェル起動時間を有意に悪化させない。
- 機能契約を満たす。

### tmux

- 平均 CPU または外部プロセス起動頻度を 50% 以上削減する。
- 平均 RSS を有意に悪化させない。
- 最大 5 秒以内にステータスを更新する。
- 機能契約を満たす。

### Ghostty

- アイドル RSS または CPU を 20% 以上改善する。
- 起動時間を 10% 以上悪化させない。
- 機能契約を満たす。
- 設定量または依存関係の保守性を悪化させない。

## 12. ブランチと PR

変更は独立しているため、stacked PR にはしない。各実装ブランチは main から分岐する。

| ブランチ | 内容 | コミットメッセージ案 |
| --- | --- | --- |
| docs/terminal-stack-lightweight | 本設計と基準値 | 端末スタック軽量化の設計を追加する |
| perf/zsh-lightweight | zsh 標準 prompt、Homebrew prefix、powerline-go 削除 | zsh の起動処理を軽量化する |
| perf/tmux-lightweight | 更新間隔、tmux-mem-cpu-load、tmux-256color installer | tmux のステータス更新を軽量化する |
| perf/ghostty-evaluation | 採用基準を満たした場合の Ghostty 置換 | Alacritty を Ghostty に置き換える |

各 PR 本文へ変更前後の計測値、機能確認結果、未計測項目を記載する。コミット、push、PR 作成、merge は、それぞれ必要な承認を得てから行う。

現在の GitHub CLI 認証トークンは無効である。PR 作成前に gh auth login -h github.com で再認証する。

## 13. リスク

- prompt の装飾は簡素になる。機能維持と約 7.6 ms／prompt の削減を優先する。
- tmux の CPU／メモリ表示は約 2 秒周期から 4 秒周期になる。表示情報と 1 秒間の CPU 採取は維持する。
- Ghostty の性能は導入前には確定できない。A/B 計測を採用条件とする。
- Intel Mac の性能は実機なしでは測定できない。公式 Universal Binary と構文確認を互換性の根拠とし、未計測を明記する。
- 複数 PR が Brewfile に触れる場合は、先行 PR merge 後の main から後続ブランチを作成し、不要な stack を作らない。

## 14. 参考資料

- Homebrew Installation：https://docs.brew.sh/Installation
- Ghostty Features：https://ghostty.org/docs/features
- Ghostty Download：https://ghostty.org/download
- WezTerm Multiplexing：https://wezterm.org/multiplexing.html
- Zellij Session Resurrection：https://zellij.dev/documentation/session-resurrection
- mise Dev Tools：https://mise.jdx.dev/dev-tools/
- zoxide：https://github.com/ajeetdsouza/zoxide
