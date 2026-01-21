# Requirements Document

## Introduction
このドキュメントは、AtCoder の問題 URL から問題文と Haskell ソースファイルを自動生成する CLI ツール「atcoder-problem-fetcher」の要件を定義する。本ツールは AtCoder 競技プログラミング向け Haskell 開発環境の一部として、問題取得から解答開始までのワークフローを効率化する。

## Requirements

### Requirement 1: サブコマンド構造
**Objective:** As a 競技プログラマー, I want 機能ごとにサブコマンドを使い分けたい, so that 直感的に操作できる

#### Acceptance Criteria
1. The CLI shall `fetch` サブコマンドで問題取得を実行する
2. The CLI shall `setup` サブコマンドで設定を管理する
3. If サブコマンドが指定されていない場合, the CLI shall 使用方法（usage）とサブコマンド一覧を表示する
4. If 不明なサブコマンドが指定された場合, the CLI shall エラーメッセージと有効なサブコマンド一覧を表示する

### Requirement 2: 設定管理（setup）
**Objective:** As a 競技プログラマー, I want デフォルトの保存先などを事前に設定したい, so that 毎回オプションを指定する手間を省ける

#### Acceptance Criteria
1. When `setup` サブコマンドを実行した場合, the CLI shall 対話的に設定を行う
2. The CLI shall デフォルトの出力ディレクトリを設定できる
3. The CLI shall テンプレートファイルのパスを設定できる
4. The CLI shall 設定を `~/.config/atcoder-fetcher/config.yaml` に保存する
5. When `setup --show` を実行した場合, the CLI shall 現在の設定を表示する
6. When `setup --reset` を実行した場合, the CLI shall 設定を初期状態に戻す

### Requirement 3: URL 入力と検証（fetch）
**Objective:** As a 競技プログラマー, I want CLI 引数として AtCoder の URL を指定できる, so that 問題の取得対象を明確に指定できる

#### Acceptance Criteria
1. When `fetch <URL>` を実行した場合, the CLI shall URL を受け取り処理を開始する
2. When URL が AtCoder の問題ページ形式（例: `https://atcoder.jp/contests/{contest}/tasks/{task}`）に一致する場合, the CLI shall 単一問題取得モードで動作する
3. When URL が AtCoder の問題一覧ページ形式（例: `https://atcoder.jp/contests/{contest}/tasks`）に一致する場合, the CLI shall コンテスト一括取得モードで動作する
4. If URL が AtCoder の形式に一致しない場合, the CLI shall エラーメッセージを表示して終了する
5. If URL 引数が指定されていない場合, the CLI shall fetch コマンドの使用方法を表示して終了する

### Requirement 4: コンテスト一括取得
**Objective:** As a 競技プログラマー, I want コンテストの全問題を一括で取得したい, so that コンテスト開始時に素早く環境を準備できる

#### Acceptance Criteria
1. When 問題一覧ページの URL が指定された場合, the CLI shall コンテスト名のディレクトリ（例: `abc441/`）を作成する
2. The CLI shall コンテストディレクトリ内に `problems/` と `answers/` サブディレクトリを作成する
3. The CLI shall 問題一覧ページから全問題のリンクを抽出する
4. The CLI shall 各問題に対して問題文ファイル（`.md`）と Haskell ファイル（`.hs`）を生成する
5. The CLI shall 問題文ファイルを `problems/` に配置する（例: `abc441/problems/a.md`）
6. The CLI shall Haskell ファイルを `answers/` に配置する（例: `abc441/answers/a.hs`）
7. The CLI shall 取得の進捗を問題ごとに表示する（例: `[1/6] abc441_a を取得中...`）
8. If 一部の問題取得に失敗した場合, the CLI shall 失敗した問題を報告し、成功した問題は保持する

### Requirement 5: 単一問題取得
**Objective:** As a 競技プログラマー, I want 特定の問題だけを取得したい, so that 過去問の練習時に必要な問題だけを準備できる

#### Acceptance Criteria
1. When 問題ページの URL が指定された場合, the CLI shall その問題のみを取得する
2. The CLI shall 出力ディレクトリ内に `problems/` と `answers/` サブディレクトリを作成する
3. The CLI shall 問題文ファイル（`.md`）を `problems/` に配置する
4. The CLI shall Haskell ファイル（`.hs`）を `answers/` に配置する

### Requirement 6: 問題ページの取得とパース
**Objective:** As a 競技プログラマー, I want AtCoder の問題ページから問題文を自動取得したい, so that 手動でコピーする手間を省ける

#### Acceptance Criteria
1. When 有効な AtCoder URL が指定された場合, the CLI shall 問題ページの HTML を取得する
2. When HTML の取得に成功した場合, the CLI shall 問題文（問題概要、制約、入出力形式、サンプル）を抽出する
3. If ネットワークエラーが発生した場合, the CLI shall エラーメッセージを表示して終了する
4. If 問題ページの構造が想定と異なる場合, the CLI shall パースエラーを報告して終了する

### Requirement 7: 出力ディレクトリの指定
**Objective:** As a 競技プログラマー, I want 出力先ディレクトリを指定できる, so that プロジェクト構造に合わせてファイルを配置できる

#### Acceptance Criteria
1. When `-o` または `--output` オプションでディレクトリが指定された場合, the CLI shall 指定されたディレクトリにファイルを出力する
2. When 出力ディレクトリが指定されていない場合, the CLI shall 設定ファイルのデフォルト値を使用する
3. When 設定ファイルにもデフォルト値がない場合, the CLI shall カレントディレクトリに出力する
4. If 指定されたディレクトリが存在しない場合, the CLI shall ディレクトリを作成する
5. If ディレクトリの作成に失敗した場合, the CLI shall エラーメッセージを表示して終了する

### Requirement 8: 問題文ファイルの生成
**Objective:** As a 競技プログラマー, I want 問題文をマークダウンファイルとして保存したい, so that ローカルで問題を参照できる

#### Acceptance Criteria
1. When 問題のパースに成功した場合, the CLI shall 問題文を Markdown 形式でファイルに保存する
2. The CLI shall ファイル名を `{問題ID}.md`（例: `a.md`）とする
3. The CLI shall 問題文に問題タイトル、制約、入出力形式、サンプル入出力を含める
4. If 同名のファイルが既に存在する場合, the CLI shall 上書き確認を求める（`-f` フラグで強制上書き可）

### Requirement 9: Haskell ソースファイルの生成
**Objective:** As a 競技プログラマー, I want 空の Haskell ファイルを自動生成したい, so that すぐにコーディングを開始できる

#### Acceptance Criteria
1. When 問題のパースに成功した場合, the CLI shall 空の Haskell ソースファイルを生成する
2. The CLI shall ファイル名を `{問題ID}.hs`（例: `a.hs`）とする
3. The CLI shall テンプレートとして基本的な main 関数と入出力のボイラープレートを含める
4. Where 設定ファイルにテンプレートパスが指定されている場合, the CLI shall そのテンプレートを使用する
5. Where テンプレートファイルが `/templates/main.hs` に存在する場合, the CLI shall そのテンプレートをフォールバックとして使用する
6. If 同名のファイルが既に存在する場合, the CLI shall 上書き確認を求める（`-f` フラグで強制上書き可）

### Requirement 10: 実行結果の表示
**Objective:** As a 競技プログラマー, I want 処理結果を確認したい, so that 正常に完了したことを把握できる

#### Acceptance Criteria
1. When すべての処理が正常に完了した場合, the CLI shall 生成されたファイルのパスを表示する
2. The CLI shall 処理の進捗状況（取得中、パース中、生成中）を表示する
3. If エラーが発生した場合, the CLI shall エラーの詳細と可能な対処法を表示する
4. When コンテスト一括取得の場合, the CLI shall 取得結果のサマリーを表示する（成功数/総数）
