# feat_1: プロジェクト基盤セットアップ

## 概要

AtCoder Problem Fetcher の Haskell プロジェクト基盤を構築した。
このブランチでは、タスク 1.1（プロジェクト初期化）と 1.2（共通型定義）を実装。

## 実装タスク

- [x] **1.1 Haskell プロジェクト初期化**
  - Stack プロジェクトを作成
  - 必要な依存パッケージを追加
  - ビルド設定を構成

- [x] **1.2 共通型と基本エラー型を定義**
  - コマンド型（Fetch、Setup）を定義
  - エラー型（NetworkError、ParseError、FileError、UrlError）を定義
  - 設定型・ドメイン型を定義

## ファイル構成

```
.
├── app/
│   └── Main.hs           # CLI エントリーポイント
├── src/
│   ├── Lib.hs            # ライブラリモジュール
│   └── Types.hs          # コア型定義
├── test/
│   ├── Spec.hs           # hspec-discover 設定
│   └── LibSpec.hs        # Lib モジュールのテスト
├── templates/
│   └── main.hs           # AtCoder ソリューションテンプレート
├── Dockerfile            # 開発環境コンテナ
├── docker-compose.yml    # サービス定義
├── package.yaml          # Stack パッケージ設定
├── stack.yaml            # Stack リゾルバ設定
├── README.md             # プロジェクト説明
└── .gitignore            # Git 除外設定
```

## 技術的決定事項

### 1. GHC バージョン: 9.4.8 (LTS 21.25)

AtCoder の Haskell 環境と互換性を持たせるため、GHC 9.4 系を採用。
LTS 21.25 は安定したパッケージセットを提供する。

```yaml
# stack.yaml
resolver: lts-21.25
```

### 2. 依存パッケージ

| パッケージ | 用途 |
|-----------|------|
| `optparse-applicative` | CLI 引数パーサー |
| `http-conduit` | HTTP クライアント |
| `tagsoup` | HTML パーサー |
| `yaml` | 設定ファイル読み書き |
| `text` / `bytestring` | 文字列処理 |
| `aeson` | JSON シリアライズ |
| `mtl` / `transformers` | モナドトランスフォーマー |

### 3. 型設計

#### Command 型（Sum Type）

CLI コマンドを Sum Type で表現し、パターンマッチで網羅的に処理可能にした。

```haskell
data Command
    = Fetch FetchOptions
    | Setup SetupOptions
    deriving (Show, Eq)
```

#### FetchError 型（エラーハンドリング）

エラーを種類別に分類し、適切なエラーメッセージを生成できるようにした。

```haskell
data FetchError
    = NetworkError Text   -- ネットワーク関連
    | ParseError Text     -- HTML パース失敗
    | FileError Text      -- ファイル操作失敗
    | UrlError Text       -- URL 検証失敗
    deriving (Show, Eq)
```

#### UrlType 型（URL 種別）

AtCoder URL をコンテスト一覧と単一問題で区別。

```haskell
data UrlType
    = ContestUrl ContestId        -- /contests/abc300/tasks
    | ProblemUrl ContestId ProblemId  -- /contests/abc300/tasks/abc300_a
    deriving (Show, Eq)
```

### 4. Docker 環境

開発環境を Docker で統一し、環境差異を排除。

```yaml
# docker-compose.yml
services:
  dev:   # 開発シェル
  cli:   # CLI 実行
  test:  # テスト実行
```

ボリュームマウントで `.stack-work` をキャッシュし、リビルド時間を短縮。

### 5. テンプレート設計

AtCoder 競技プログラミング用のテンプレートを用意。
`ByteString` ベースの高速 IO ヘルパーを含む。

```haskell
-- 高速な整数読み込み
readInt :: BS.ByteString -> Int
readInt = fst . fromJust . BS.readInt

getInt :: IO Int
getInt = readInt <$> BS.getLine

getInts :: IO [Int]
getInts = map readInt . BS.words <$> BS.getLine
```

## GHC オプション

厳格な警告設定で型安全性を向上。

```yaml
ghc-options:
  - -Wall
  - -Wcompat
  - -Wincomplete-record-updates
  - -Wincomplete-uni-patterns
  - -Wmissing-export-lists
  - -Wpartial-fields
  - -Wredundant-constraints
```

## 次のタスク

- [ ] 2. URL パーサーモジュール実装
- [ ] 3. HTML パーサーモジュール実装
- [ ] 4. ファイル生成モジュール実装
- [ ] 5. CLI インターフェース実装
- [ ] 6. 設定管理モジュール実装

## 参考リンク

- [AtCoder Haskell 環境](https://img.atcoder.jp/file/language-update/language-list.html)
- [Stack ドキュメント](https://docs.haskellstack.org/)
- [optparse-applicative](https://hackage.haskell.org/package/optparse-applicative)
