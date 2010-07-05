
"-------------------------------------------------------------------------------
" 基本設定 Basics
"-------------------------------------------------------------------------------
set nocompatible                 " Vimっす。vi互換なしっす。
let mapleader = ","              " キーマップリーダー
set scrolloff=5                  " スクロール時の余白確保
set textwidth=0                  " 一行に長い文章を書いていても自動折り返しをしない
set nobackup                     " バックアップ取らない
set autoread                     " 他で書き換えられたら自動で読み直す
set noswapfile                   " スワップファイル作らない
set hidden                       " 編集中でも他のファイルを開けるようにする
set backspace=indent,eol,start   " バックスペースでなんでも消せるように
set formatoptions=lmoq           " テキスト整形オプション，マルチバイト系を追加
set vb t_vb=                     " ビープをならさない
set browsedir=buffer             " Exploreの初期ディレクトリ
set whichwrap=b,s,h,l,<,>,[,]    " カーソルを行頭、行末で止まらないようにする
set showcmd                      " コマンドをステータス行に表示
set showmode                     " 現在のモードを表示
set viminfo='50,<1000,s100,\"50  " viminfoファイルの設定
set helpfile=$VIMRUNTIME/doc/help.txt
set modelines=0                  " モードラインは無効

" OSのクリップボードを使用する
set clipboard+=unnamed
" ターミナルでマウスを使用できるようにする
set mouse=a
set guioptions+=a
set ttymouse=xterm2

" ファイルタイプ判定をon
filetype plugin on
" ハイライト on
syntax enable

"ヤンクした文字は、システムのクリップボードに入れる"
set clipboard=unnamed
" 挿入モードでCtrl+kを押すとクリップボードの内容を貼り付けられるようにする "
imap <C-K>  <ESC>"*pa

" Ev/Rvでvimrcの編集と反映
command! Ev edit $MYVIMRC
command! Rv source $MYVIMRC


"-------------------------------------------------------------------------------
" ステータスライン StatusLine
"-------------------------------------------------------------------------------
set laststatus=2 " 常にステータスラインを表示

"カーソルが何行目の何列目に置かれているかを表示する
set ruler

"ステータスラインに文字コードと改行文字を表示する
if winwidth(0) >= 120
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %F%=[%{GetB()}]\ %l,%c%V%8P
else
  set statusline=%<[%n]%m%r%h%w%{'['.(&fenc!=''?&fenc:&enc).':'.&ff.']'}%y\ %f%=[%{GetB()}]\ %l,%c%V%8P
endif

"入力モード時、ステータスラインのカラーを変更
augroup InsertHook
autocmd!
autocmd InsertEnter * highlight StatusLine guifg=#ccdc90 guibg=#2E4340
autocmd InsertLeave * highlight StatusLine guifg=#2E4340 guibg=#ccdc90
augroup END

function! GetB()
  let c = matchstr(getline('.'), '.', col('.') - 1)
  let c = iconv(c, &enc, &fenc)
  return String2Hex(c)
endfunction
" help eval-examples
" The function Nr2Hex() returns the Hex string of a number.
func! Nr2Hex(nr)
  let n = a:nr
  let r = ""
  while n
    let r = '0123456789ABCDEF'[n % 16] . r
    let n = n / 16
  endwhile
  return r
endfunc
" The function String2Hex() converts each character in a string to a two
" character Hex string.
func! String2Hex(str)
  let out = ''
  let ix = 0
  while ix < strlen(a:str)
    let out = out . Nr2Hex(char2nr(a:str[ix]))
    let ix = ix + 1
  endwhile
  return out
endfunc

"-------------------------------------------------------------------------------
" 表示 Apperance
"-------------------------------------------------------------------------------
set showmatch         " 括弧の対応をハイライト
set number            " 行番号表示
set list              " 不可視文字表示
set listchars=tab:>.,trail:_,extends:>,precedes:< " 不可視文字の表示形式
set display=uhex      " 印字不可能文字を16進数で表示

" 全角スペースの表示
highlight ZenkakuSpace cterm=underline ctermfg=lightblue guibg=darkgray
match ZenkakuSpace /　/

" カーソル行をハイライト
set cursorline
" カレントウィンドウにのみ罫線を引く
augroup cch
  autocmd! cch
  autocmd WinLeave * set nocursorline
  autocmd WinEnter,BufRead * set cursorline
augroup END

:hi clear CursorLine
:hi CursorLine gui=underline
highlight CursorLine ctermbg=black guibg=black

" コマンド実行中は再描画しない
:set lazyredraw
" 高速ターミナル接続を行う
:set ttyfast

"-------------------------------------------------------------------------------
" インデント Indent
"-------------------------------------------------------------------------------
set autoindent   " 自動でインデント
"set paste        " ペースト時にautoindentを無効に(onにするとautocomplpop.vimが動かない)
set smartindent  " 新しい行を開始したときに、新しい行のインデントを現在行と同じ量にする。
set cindent      " Cプログラムファイルの自動インデントを始める

" softtabstopはTabキー押し下げ時の挿入される空白の量，0の場合はtabstopと同じ，BSにも影響する
set tabstop=2 shiftwidth=2 softtabstop=0

if has("autocmd")
  "ファイルタイプの検索を有効にする
  filetype plugin on
  "そのファイルタイプにあわせたインデントを利用する
  filetype indent on
  " これらのftではインデントを無効に
  "autocmd FileType php filetype indent off

  autocmd FileType html :set indentexpr=
  autocmd FileType xhtml :set indentexpr=
endif


"-------------------------------------------------------------------------------
" 補完・履歴 Complete
"-------------------------------------------------------------------------------
set wildmenu               " コマンド補完を強化
set wildchar=<tab>         " コマンド補完を開始するキー
set wildmode=list:full     " リスト表示，最長マッチ
set history=1000           " コマンド・検索パターンの履歴数
set complete+=k            " 補完に辞書ファイル追加


" Enter で補完決定にする
"inoremap <expr> <cr> pumvisible() ? "<c-y>" : "<c-g><cr>"
" escape で補完をキャンセルして元のテキストに戻す
"inoremap <expr> <esc>      pumvisible() ? "<c-e>":"<esc>"
" c-n で補完を始めたとき、常にどれかの候補が選ばれているようにする。
" これによって、続けて文字を入力して候補をしぼりこみ、enter で決定できるようになる。
"¥inoremap <expr> <c-n> pumvisible() ? "¥<lt><c-n>" : "¥<c-n>¥<c-r>=pumvisible() ? ¥"¥¥<lt><down>¥" : ¥"¥"¥<lt><cr>"

"<c-space>でomni補完
imap <c-space> <c-x><c-o>

" -- tabでオムニ補完
function! InsertTabWrapper()
  if pumvisible()
    return "\<c-n>"
  endif
  let col = col('.') - 1
  if !col || getline('.')[col -1] !~ '\k\|<\|/'
    return "\<tab>"
  elseif exists('&omnifunc') && &omnifunc == ''
    return "\<c-n>"
  else
    return "\<c-x>\<c-o>"
  endif
endfunction
inoremap <tab> <c-r>=InsertTabWrapper()<cr>


" " <TAB> completion.
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" " C-jでオムニ補完
" inoremap <expr> <C-j>  &filetype == 'vim' ? "\<C-x>\<C-v>\<C-p>" : "\<C-x>\<C-o>\<C-p>"
" " C-kを押すと行末まで削除
" inoremap <C-k>  <C-o>D
" " C-hで補完を続行しない
" inoremap <expr><C-h> pumvisible() ? "\<C-y>\<C-h>" : "\<C-h>"
" " C-nでneocomplcache補完
" inoremap <expr><C-n>  pumvisible() ? "\<C-n>" : "\<C-x>\<C-u>\<C-p>"
" " C-pでkeyword補完
" inoremap <expr><C-p>  pumvisible() ? "\<C-p>" : "\<C-p>\<C-n>"
" " 途中でEnterしたとき、ポップアップを消して改行し、
" " 改行を連続して入力してもインデント部を保持する
" inoremap <expr><CR> pumvisible() ? "\<C-y>\<CR>X\<BS>" : "\<CR>X\<BS>"


"-------------------------------------------------------------------------------
" タグ関連 Tags
"-------------------------------------------------------------------------------
" set tags
if has("autochdir")
  " 編集しているファイルのディレクトリに自動で移動
  set autochdir
  set tags=tags;
else
  set tags=./tags,./../tags,./*/tags,./../../tags,./../../../tags,./../../../../tags,./../../../../../tags
endif

"tab pagesを使い易くする
nnoremap <C-t>  <Nop>
nnoremap <C-t>n  ;<C-u>tabnew<CR>
nnoremap <C-t>c  ;<C-u>tabclose<CR>
nnoremap <C-t>o  ;<C-u>tabonly<CR>
nnoremap <C-t>j  ;<C-u>execute 'tabnext' 1 + (tabpagenr() + v:count1 - 1) % tabpagenr('$')<CR>
nnoremap <C-t>k  gT

"tags-and-searchesを使い易くする
nnoremap t  <Nop>
"「飛ぶ」
nnoremap tt  <C-]>
"「進む」
nnoremap tj  ;<C-u>tag<CR>
"「戻る」
nnoremap tk  ;<C-u>pop<CR>
"履歴一覧
nnoremap tl  ;<C-u>tags<CR>

"-------------------------------------------------------------------------------
" 検索設定 Search
"-------------------------------------------------------------------------------
set wrapscan   " 最後まで検索したら先頭へ戻る
set ignorecase " 大文字小文字無視
set smartcase  " 検索文字列に大文字が含まれている場合は区別して検索する
set incsearch  " インクリメンタルサーチ
set hlsearch   " 検索文字をハイライト
"Escの2回押しでハイライト消去
nmap <ESC><ESC> ;nohlsearch<CR><ESC>

"選択した文字列を検索
vnoremap <silent> // y/<C-R>=escape(@", '\\/.*$^~[]')<CR><CR>
"選択した文字列を置換
vnoremap /r "xy;%s/<C-R>=escape(@x, '\\/.*$^~[]')<CR>//gc<Left><Left><Left>

"s*置換後文字列/g<Cr>でカーソル下のキーワードを置換
nnoremap <expr> s* ':%substitute/\<' . expand('<cword>') . '\>/'

" Ctrl-hでヘルプ
nnoremap <C-h>  :<C-u>help<Space>
" カーソル下のキーワードをヘルプでひく
nnoremap <C-h><C-h> :<C-u>help<Space><C-r><C-w><Enter>

" :Gb <args> でGrepBufferする
command! -nargs=1 Gb :GrepBuffer <args>

"-------------------------------------------------------------------------------
" 移動設定 Move
"-------------------------------------------------------------------------------

" カーソルを表示行で移動する。論理行移動は<C-n>,<C-p>
nnoremap h <Left>
nnoremap j gj
nnoremap k gk
nnoremap l <Right>
nnoremap <Down> gj
nnoremap <Up>   gk

" 0, 9で行頭、行末へ
nmap 1 0
nmap 0 ^
nmap 9 $

" insert mode での移動
imap  <C-e> <END>
imap  <C-a> <HOME>
" インサートモードでもhjklで移動（Ctrl押すけどね）
imap <C-j> <Down>
imap <C-k> <Up>
imap <C-h> <Left>
imap <C-l> <Right>

"<space>j, <space>kで画面送り
noremap <Space>j <C-f>
noremap <Space>k <C-b>

" spaceで次のbufferへ。back-spaceで前のbufferへ
nmap <Space> ;MBEbn<CR>
nmap <BS> ;MBEbp<CR>

"フレームサイズを怠惰に変更する
map <kPlus> <C-W>+
map <kMinus> <C-W>-

" 前回終了したカーソル行に移動
autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | exe "normal g`\"" | endif

" 最後に編集された位置に移動
nnoremap gb '[
nnoremap gp ']

" 対応する括弧に移動
nnoremap [ %
nnoremap ] %

" 最後に変更されたテキストを選択する
nnoremap gc  `[v`]
vnoremap gc ;<C-u>normal gc<Enter>
onoremap gc ;<C-u>normal gc<Enter>

" カーソル位置の単語をyankする
nnoremap vv vawy

" 矩形選択で自由に移動する
set virtualedit+=block

"ビジュアルモード時vで行末まで選択
vnoremap v $h

" CTRL-hjklでウィンドウ移動
nnoremap <C-j> ;<C-w>j
nnoremap <C-k> ;<C-k>j
nnoremap <C-l> ;<C-l>j
nnoremap <C-h> ;<C-h>j

"-------------------------------------------------------------------------------
" エンコーディング関連 Encoding
"-------------------------------------------------------------------------------
set ffs=unix,dos,mac  " 改行文字
set encoding=utf-8    " デフォルトエンコーディング

" 文字コード関連
" from ずんWiki http://www.kawaz.jp/pukiwiki/?vim#content_1_7
" 文字コードの自動認識
if &encoding !=# 'utf-8'
  set encoding=japan
  set fileencoding=japan
endif
if has('iconv')
  let s:enc_euc = 'euc-jp'
  let s:enc_jis = 'iso-2022-jp'
  " iconvがeucJP-msに対応しているかをチェック
  if iconv("\x87\x64\x87\x6a", 'cp932', 'eucjp-ms') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'eucjp-ms'
    let s:enc_jis = 'iso-2022-jp-3'
  " iconvがJISX0213に対応しているかをチェック
  elseif iconv("\x87\x64\x87\x6a", 'cp932', 'euc-jisx0213') ==# "\xad\xc5\xad\xcb"
    let s:enc_euc = 'euc-jisx0213'
    let s:enc_jis = 'iso-2022-jp-3'
  endif
  " fileencodingsを構築
  if &encoding ==# 'utf-8'
    let s:fileencodings_default = &fileencodings
    let &fileencodings = s:enc_jis .','. s:enc_euc .',cp932'
    let &fileencodings = &fileencodings .','. s:fileencodings_default
    unlet s:fileencodings_default
  else
    let &fileencodings = &fileencodings .','. s:enc_jis
    set fileencodings+=utf-8,ucs-2le,ucs-2
    if &encoding =~# '^\(euc-jp\|euc-jisx0213\|eucjp-ms\)$'
      set fileencodings+=cp932
      set fileencodings-=euc-jp
      set fileencodings-=euc-jisx0213
      set fileencodings-=eucjp-ms
      let &encoding = s:enc_euc
      let &fileencoding = s:enc_euc
    else
      let &fileencodings = &fileencodings .','. s:enc_euc
    endif
  endif
  " 定数を処分
  unlet s:enc_euc
  unlet s:enc_jis
endif
" 日本語を含まない場合は fileencoding に encoding を使うようにする
if has('autocmd')
  function! AU_ReCheck_FENC()
    if &fileencoding =~# 'iso-2022-jp' && search("[^\x01-\x7e]", 'n') == 0
      let &fileencoding=&encoding
    endif
  endfunction
  autocmd BufReadPost * call AU_ReCheck_FENC()
endif
" 改行コードの自動認識
set fileformats=unix,dos,mac
" □とか○の文字があってもカーソル位置がずれないようにする
if exists('&ambiwidth')
  set ambiwidth=double
endif

" cvsの時は文字コードをeuc-jpに設定
autocmd FileType cvs :set fileencoding=euc-jp
" 以下のファイルの時は文字コードをutf-8に設定
autocmd FileType svn :set fileencoding=utf-8
autocmd FileType js :set fileencoding=utf-8
autocmd FileType css :set fileencoding=utf-8
autocmd FileType html :set fileencoding=utf-8
autocmd FileType xml :set fileencoding=utf-8
autocmd FileType java :set fileencoding=utf-8
autocmd FileType scala :set fileencoding=utf-8
autocmd FileType putocmd FileType python let g:pydiction_location = '~/.vim/pydiction/complete-dict'y :set fileencoding=utf-8

" ワイルドカードで表示するときに優先度を低くする拡張子
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

" 指定文字コードで強制的にファイルを開く
command! Cp932 edit ++enc=cp932
command! Eucjp edit ++enc=euc-jp
command! Iso2022jp edit ++enc=iso-2022-jp
command! Utf8 edit ++enc=utf-8
command! Jis Iso2022jp
command! Sjis Cp932

"-------------------------------------------------------------------------------
" カラー関連 Colors
"-------------------------------------------------------------------------------

" ターミナルタイプによるカラー設定
if &term =~ "xterm-debian" || &term =~ "xterm-xfree86" || &term =~ "xterm-256color"
 set t_Co=16
 set t_Sf=[3%dm
 set t_Sb=[4%dm
endif

if &term =~ "xterm-256color"
  colorscheme inkpot
endif

"ポップアップメニューのカラーを設定
"hi Pmenu guibg=#666666
"hi PmenuSel guibg=#8cd0d3 guifg=#666666
"hi PmenuSbar guibg=#333333

" 補完候補の色づけ for vim7
hi Pmenu ctermbg=white ctermfg=darkgray
hi PmenuSel ctermbg=blue ctermfg=white
hi PmenuSbar ctermbg=0 ctermfg=9

"-------------------------------------------------------------------------------
" 編集関連 Edit
"-------------------------------------------------------------------------------

" insertモードを抜けるとIMEオフ
set noimdisable
set iminsert=0 imsearch=0
set noimcmdline
inoremap <silent> <ESC> <ESC>:set iminsert=0<CR>

" yeでそのカーソル位置にある単語をレジスタに追加
nmap ye ;let @"=expand("<cword>")<CR>
" Visualモードでのpで選択範囲をレジスタの内容に置き換える
vnoremap p <Esc>;let current_reg = @"<CR>gvdi<C-R>=current_reg<CR><Esc>

" Tabキーを空白に変換
set expandtab

" コンマの後に自動的にスペースを挿入
inoremap , ,<Space>
" XMLの閉タグを自動挿入
augroup MyXML
  autocmd!
  autocmd Filetype xml inoremap <buffer> </ </<C-x><C-o>
augroup END

"  Insert mode中で単語単位/行単位の削除をアンドゥ可能にする
inoremap <C-u>  <C-g>u<C-u>
inoremap <C-w>  <C-g>u<C-w>

" :Ptでインデントモード切替
command! Pt :set paste!

" y9で行末までヤンク
nmap y9 y$
" y0で行頭までヤンク
nmap y0 y^

"
" 括弧を自動補完
"inoremap { {}<LEFT>
"inoremap [ []<LEFT>
"inoremap ( ()<LEFT>
"inoremap " ""<LEFT>
"inoremap ' ''<LEFT>
"vnoremap { "zdi^V{<C-R>z}<ESC>
"vnoremap [ "zdi^V[<C-R>z]<ESC>
"vnoremap ( "zdi^V(<C-R>z)<ESC>
"vnoremap " "zdi^V"<C-R>z^V"<ESC>
"vnoremap ' "zdi'<C-R>z'<ESC>

" 保存時に行末の空白を除去する
autocmd BufWritePre * :%s/\s\+$//ge
" 保存時にtabをスペースに変換する
autocmd BufWritePre * :%s/\t/  /ge

" 日時の自動入力
inoremap <expr> ,df strftime('%Y/%m/%d %H:%M:%S')
inoremap <expr> ,dd strftime('%Y/%m/%d')
inoremap <expr> ,dt strftime('%H:%M:%S')

"-------------------------------------------------------------------------------
" その他 Misc
"-------------------------------------------------------------------------------

" ;でExコマンド入力( ;と:を入れ替)
noremap ; :
noremap : ;

"-------------------------------------------------------------------------------
" プラグインごとの設定 Plugins
"-------------------------------------------------------------------------------

" "------------------------------------
" " neocomplecache.vim
" "------------------------------------
" " Don't use autocomplpop.
" let g:AutoComplPop_NotEnableAtStartup = 1
" " Use neocomplcache.
" let g:NeoComplCache_EnableAtStartup = 1
" " Use smartcase.
" let g:NeoComplCache_SmartCase = 1
" " Use previous keyword completion.
" let g:NeoComplCache_PreviousKeywordCompletion = 1
" " Use tags auto update.
" let g:NeoComplCache_TagsAutoUpdate = 1
" " Use preview window.
" let g:NeoComplCache_EnableInfo = 1
" " Use camel case completion.
" let g:NeoComplCache_EnableCamelCaseCompletion = 1
" " Use underbar completion.
" let g:NeoComplCache_EnableUnderbarCompletion = 1
" " Set minimum syntax keyword length.
" let g:NeoComplCache_MinSyntaxLength = 3
" " Set skip input time.
" let g:NeoComplCache_SkipInputTime = '0.2'
" " Set manual completion length.
" let g:NeoComplCache_ManualCompletionStartLength = 0

" " Define dictionary.
" let g:NeoComplCache_DictionaryFileTypeLists = {
            " \ 'default' : '',
            " \ 'vimshell' : $HOME.'/.vimshell_hist',
            " \ 'scheme' : $HOME.'/.gosh_completions'
            " \ }

" " Define keyword.
" if !exists('g:NeoComplCache_KeywordPatterns')
    " let g:NeoComplCache_KeywordPatterns = {}
" endif
" let g:NeoComplCache_KeywordPatterns['default'] = '\v\h\w*'

" " Plugin key-mappings.
" imap <silent><C-l>     <Plug>(neocomplcache_snippets_expand)
" smap <silent><C-l>     <Plug>(neocomplcache_snippets_expand)
" nmap <silent><C-e>     <Plug>(neocomplcache_keyword_caching)
" imap <expr><silent><C-e>     pumvisible() ? "\<C-e>" : "\<Plug>(neocomplcache_keyword_caching)"

"------------------------------------
" YankRing.vim
"------------------------------------
" Yankの履歴参照
nmap ,y ;YRShow<CR>

"------------------------------------
" MiniBufExplorer
"------------------------------------
"set minibfexp
let g:miniBufExplMapWindowNavVim=1 "hjklで移動
let g:miniBufExplSplitBelow=0  " Put new window above
let g:miniBufExplMapWindowNavArrows=1
let g:miniBufExplMapCTabSwitchBufs=1
let g:miniBufExplModSelTarget=1
let g:miniBufExplSplitToEdge=1
let g:miniBufExplMaxSize = 10

":TmでMiniBufExplorerの表示トグル
command! Mt :TMiniBufExplorer

"------------------------------------
" Align
"------------------------------------
" Alignを日本語環境で使用するための設定
let g:Align_xstrlen = 3

"------------------------------------
" VTreeExplorer
"------------------------------------
" 縦に表示する
let g:treeExplVertical=1

"------------------------------------
" NERD_commenter.vim
"------------------------------------
" コメントの間にスペースを空ける
let NERDSpaceDelims = 1
"<Leader>xでコメントをトグル(NERD_commenter.vim)
map <Leader>x, c<space>
""未対応ファイルタイプのエラーメッセージを表示しない
let NERDShutUp=1

"------------------------------------
" grep.vim
"------------------------------------
" 検索外のディレクトリ、ファイルパターン
let Grep_Skip_Dirs = '.svn'
let Grep_Skip_Files = '*.bak *~'

"------------------------------------
" surround.vim
"------------------------------------
" s, ssで選択範囲を指定文字でくくる
nmap s <Plug>Ysurround
nmap ss <Plug>Yssurround

" "------------------------------------
" " smartchr.vim
" "------------------------------------
"
" " 演算子の間に空白を入れる
" inoremap <buffer><expr> + smartchr#one_of(' + ', ' ++ ', '+')
" inoremap <buffer><expr> +=  smartchr#one_of(' += ')
" " inoremap <buffer><expr> - smartchr#one_of(' - ', ' -- ', '-')
" inoremap <buffer><expr> -=  smartchr#one_of(' -= ')
" " inoremap <buffer><expr> / smartchr#one_of(' / ', ' // ', '/')
" inoremap <buffer><expr> /=  smartchr#one_of(' /= ')
" inoremap <buffer><expr> * smartchr#one_of(' * ', ' ** ', '*')
" inoremap <buffer><expr> *=  smartchr#one_of(' *= ')
" inoremap <buffer><expr> & smartchr#one_of(' & ', ' && ', '&')
" inoremap <buffer><expr> % smartchr#one_of(' % ', '%')
" inoremap <buffer><expr> =>  smartchr#one_of(' => ')
" inoremap <buffer><expr> <-   smartchr#one_of(' <-  ')
" inoremap <buffer><expr> <Bar> smartchr#one_of(' <Bar> ', ' <Bar><Bar> ', '<Bar>')
" inoremap <buffer><expr> , smartchr#one_of(', ', ',')
" " 3項演算子の場合は、後ろのみ空白を入れる
" inoremap <buffer><expr> ? smartchr#one_of('? ', '?')
" " inoremap <buffer><expr> : smartchr#one_of(': ', '::', ':')

" " =の場合、単純な代入や比較演算子として入力する場合は前後にスペースをいれる。
" " 複合演算代入としての入力の場合は、直前のスペースを削除して=を入力
" inoremap <buffer><expr> = search('¥(&¥<bar><bar>¥<bar>+¥<bar>-¥<bar>/¥<bar>>¥<bar><¥) ¥%#', 'bcn')? '<bs>= '  : search('¥(*¥<bar>!¥)¥%#', 'bcn') ? '= '  : smartchr#one_of(' = ', ' == ', '=')

" " 下記の文字は連続して現れることがまれなので、二回続けて入力したら改行する
" inoremap <buffer><expr> } smartchr#one_of('}', '}<cr>')
" inoremap <buffer><expr> ; smartchr#one_of(';', ';<cr>')
" "()は空白入れる
" inoremap <buffer><expr> ( smartchr#one_of('( ')
" inoremap <buffer><expr> ) smartchr#one_of(' )')

" " if文直後の(は自動で間に空白を入れる
" inoremap <buffer><expr> ( search('¥<¥if¥%#', 'bcn')? ' (': '('


"------------------------------------
" git.vim
"------------------------------------
let g:git_no_map_default = 1
let g:git_command_edit = 'rightbelow vnew'
nnoremap <Space>gd :<C-u>GitDiff --cached<Enter>
nnoremap <Space>gD :<C-u>GitDiff<Enter>
nnoremap <Space>gs :<C-u>GitStatus<Enter>
nnoremap <Space>gl :<C-u>GitLog<Enter>
nnoremap <Space>gL :<C-u>GitLog -u \| head -10000<Enter>
nnoremap <Space>ga :<C-u>GitAdd<Enter>
nnoremap <Space>gA :<C-u>GitAdd <cfile><Enter>
nnoremap <Space>gc :<C-u>GitCommit<Enter>
nnoremap <Space>gC :<C-u>GitCommit --amend<Enter>
nnoremap <Space>gp :<C-u>Git push


"------------------------------------
" pydiction.vim
"------------------------------------
autocmd FileType python let g:pydiction_location = '~/.vim/pydiction/complete-dict'

"------------------------------------
" BufExplorer
"------------------------------------
"<C-l>でBufferList
nnoremap <C-l> :BufExplorer<CR>

"------------------------------------
" VTreeExplorer
"------------------------------------
"<Leader>t<Space>でディレクトリツリー表示
noremap <Leader>t<Space> :VTreeExplore<CR>

"------------------------------------
" DumbBuf.vim
"------------------------------------
"<Leader>b<Space>でBufferList
let dumbbuf_hotkey = '<Leader>b<Space>'
let dumbbuf_mappings = {
    \ 'n': {
        \'<Esc>': { 'opt': '<silent>', 'mapto': ':<C-u>close<CR>' }
    \}
\}
let dumbbuf_single_key  = 1
let dumbbuf_updatetime  = 1    " &updatetimeの最小値
let dumbbuf_wrap_cursor = 0
let dumbbuf_remove_marked_when_close = 1


