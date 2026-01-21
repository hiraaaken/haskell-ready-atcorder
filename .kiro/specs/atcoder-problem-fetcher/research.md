# Research & Design Decisions

## Summary
- **Feature**: atcoder-problem-fetcher
- **Discovery Scope**: New Feature（Greenfield CLI ツール）
- **Key Findings**:
  - AtCoder の問題ページは静的 HTML で構造化されており、TagSoup でパース可能
  - optparse-applicative がサブコマンド対応の標準的な CLI パーサー
  - http-conduit + tagsoup の組み合わせが軽量で実績あり

## Research Log

### AtCoder HTML 構造分析
- **Context**: 問題ページと問題一覧ページの HTML 構造を理解し、パース戦略を決定
- **Sources Consulted**:
  - https://atcoder.jp/contests/abc300/tasks（問題一覧）
  - https://atcoder.jp/contests/abc300/tasks/abc300_a（個別問題）
- **Findings**:
  - 問題一覧ページ: テーブル構造、`/contests/{contest}/tasks/{task}` 形式のリンク
  - コンテスト名: JavaScript 変数 `contestScreenName` または URL から抽出可能
  - 問題タイトル: `<span class="h2">` 内、または `<title>` タグから
  - 問題文: `<div id="task-statement">` 内、言語切り替え用に `span.lang-ja` / `span.lang-en`
  - 制約・入出力・サンプル: `<section>` タグで構造化、見出しで区切り
- **Implications**:
  - TagSoup で静的 HTML パース可能
  - 日本語版問題文を優先的に抽出
  - セクション見出しベースでコンテンツ分割

### Haskell CLI パーサーライブラリ
- **Context**: サブコマンド（fetch, setup）をサポートする CLI パーサーの選定
- **Sources Consulted**:
  - https://hackage.haskell.org/package/optparse-applicative
  - https://github.com/pcapriotti/optparse-applicative
- **Findings**:
  - optparse-applicative が事実上の標準（120k+ downloads）
  - サブコマンド、フラグ、オプション、位置引数をサポート
  - 自動ヘルプ生成、bash/zsh/fish 補完対応
  - Applicative スタイルで宣言的に定義可能
- **Implications**:
  - optparse-applicative を採用
  - Parser 型を Command データ型にマッピング

### HTTP クライアントライブラリ
- **Context**: AtCoder ページの取得に使用するライブラリの選定
- **Sources Consulted**:
  - https://hackage.haskell.org/package/http-conduit
  - https://hackage.haskell.org/package/wreq
  - https://hackage.haskell.org/package/req
- **Findings**:
  - http-conduit: 軽量、ストリーミング対応、Network.HTTP.Simple API 推奨
  - wreq: lens ベース API、高機能だが依存大
  - req: 型安全、使いやすい API
- **Implications**:
  - http-conduit（Network.HTTP.Simple）を採用
  - シンプルな GET リクエストで十分

### HTML パーサーライブラリ
- **Context**: AtCoder ページの HTML パース戦略の決定
- **Sources Consulted**:
  - https://hackage.haskell.org/package/tagsoup
  - https://hackage.haskell.org/package/html-conduit
- **Findings**:
  - TagSoup: 軽量、不正な HTML 対応、ストリーム処理
  - html-conduit: xml-conduit ベース、ツリー構造
  - html-parse: attoparsec ベース、高性能
- **Implications**:
  - TagSoup を採用（軽量、十分な機能）
  - セクション抽出にはタグベースのパターンマッチ

### YAML 設定ファイルライブラリ
- **Context**: ユーザー設定（デフォルト出力先、テンプレートパス）の永続化
- **Sources Consulted**:
  - https://hackage.haskell.org/package/yaml
  - https://hackage.haskell.org/package/HsYAML
- **Findings**:
  - yaml: aeson ベース、環境変数対応、広く使用
  - HsYAML: 純粋 Haskell、依存少
- **Implications**:
  - yaml を採用（aeson との統合が容易）
  - Config 型を定義し FromJSON/ToJSON インスタンス導出

## Architecture Pattern Evaluation

| Option | Description | Strengths | Risks / Limitations | Notes |
|--------|-------------|-----------|---------------------|-------|
| レイヤードアーキテクチャ | CLI → Application → Domain → Infrastructure | 明確な責務分離、テスト容易 | シンプルなツールには過剰 | 今回のスコープには適切 |
| シンプルモジュール分離 | 機能ごとにモジュール分割 | 軽量、理解しやすい | スケールしにくい | CLI ツールとして十分 |
| MTL スタイル | モナド変換子でエフェクト分離 | 型安全、合成可能 | 学習コスト | 将来の拡張性を考慮し採用 |

**選択**: シンプルモジュール分離 + IO モナド

## Design Decisions

### Decision: CLI パーサー選定
- **Context**: サブコマンド（fetch, setup）をサポートする必要
- **Alternatives Considered**:
  1. optparse-applicative — 標準的、サブコマンド対応
  2. cmdargs — アノテーションベース
  3. getopt — 低レベル
- **Selected Approach**: optparse-applicative
- **Rationale**: サブコマンド対応、自動ヘルプ、広く使用されている
- **Trade-offs**: 多少の学習コストがあるが、宣言的で保守しやすい
- **Follow-up**: サブコマンドごとに Parser を定義

### Decision: HTTP クライアント選定
- **Context**: AtCoder ページの取得
- **Alternatives Considered**:
  1. http-conduit — 軽量、Simple API
  2. wreq — 高機能、lens ベース
  3. req — 型安全
- **Selected Approach**: http-conduit (Network.HTTP.Simple)
- **Rationale**: シンプルな GET のみ、依存を最小化
- **Trade-offs**: wreq ほど高機能ではないが十分
- **Follow-up**: User-Agent ヘッダー設定

### Decision: HTML パーサー選定
- **Context**: AtCoder ページの問題文抽出
- **Alternatives Considered**:
  1. TagSoup — 軽量、ストリーム
  2. html-conduit — ツリー構造
  3. html-parse — 高性能
- **Selected Approach**: TagSoup
- **Rationale**: 軽量で十分な機能、不正 HTML 対応
- **Trade-offs**: CSS セレクタなし（手動パターンマッチ）
- **Follow-up**: セクション抽出ロジックのテスト作成

### Decision: 設定ファイル形式
- **Context**: ユーザー設定の永続化
- **Alternatives Considered**:
  1. YAML — 人間に読みやすい
  2. JSON — aeson で直接
  3. TOML — Rust 系で人気
- **Selected Approach**: YAML (yaml パッケージ)
- **Rationale**: 人間に読みやすく、aeson 統合が容易
- **Trade-offs**: JSON より依存が増える
- **Follow-up**: ~/.config/atcoder-fetcher/config.yaml に保存

## Risks & Mitigations

- **AtCoder HTML 構造の変更** — パース失敗の可能性
  - Mitigation: エラー時に明確なメッセージ、パーサーのモジュール化で更新容易に
- **ネットワークエラー** — 接続失敗、タイムアウト
  - Mitigation: 適切なエラーハンドリング、リトライは将来検討
- **文字エンコーディング** — UTF-8 以外の可能性
  - Mitigation: AtCoder は UTF-8 を使用、ByteString → Text 変換で対応

## References
- [optparse-applicative (Hackage)](https://hackage.haskell.org/package/optparse-applicative) — CLI パーサー
- [http-conduit (Hackage)](https://hackage.haskell.org/package/http-conduit) — HTTP クライアント
- [TagSoup (Hackage)](https://hackage.haskell.org/package/tagsoup) — HTML パーサー
- [yaml (Hackage)](https://hackage.haskell.org/package/yaml) — YAML パーサー
- [AtCoder](https://atcoder.jp/) — 対象サイト
