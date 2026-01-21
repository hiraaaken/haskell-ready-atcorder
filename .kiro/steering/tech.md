# Technology Stack

## Architecture

シンプルなシングルファイル構成を基本とし、AtCoder への提出に適した形式を維持する。共通ライブラリは別モジュールとして管理し、必要に応じてコピー＆ペーストで利用可能。

## Core Technologies

- **Language**: Haskell (GHC 9.4+ 推奨、AtCoder の環境に合わせる)
- **Build Tool**: Stack または Cabal
- **Package Manager**: Stackage LTS または Hackage

## Key Libraries

- **bytestring**: 高速な入出力処理
- **vector**: 効率的な配列操作
- **containers**: Map, Set, Sequence などのデータ構造
- **array**: 可変配列（STArray, IOArray）
- **mtl**: モナド変換子（State, Reader など）

## Development Standards

### Type Safety
- 明示的な型注釈を推奨
- `-Wall` 警告を有効化
- 可能な限り total function を使用

### Code Quality
- HLint による静的解析
- Ormolu または fourmolu によるフォーマット
- 提出コードは単一ファイルに収める

### Testing
- サンプル入出力によるテスト
- QuickCheck によるプロパティベーステスト（ライブラリ用）

## Development Environment

### Required Tools
- GHC 9.4+（AtCoder 環境互換）
- Stack 2.x または Cabal 3.x
- haskell-language-server（推奨）

### Common Commands
```bash
# Build: stack build / cabal build
# Run: stack run / cabal run
# Test: stack test / cabal test
# REPL: stack ghci / cabal repl
# Submit: 単一ファイルをコピー
```

## Key Technical Decisions

- **入出力**: ByteString ベースの高速 I/O を標準とする
- **データ構造**: 問題に応じて Vector/Array/containers を使い分け
- **アルゴリズム**: 再帰 + メモ化、または配列DP で実装
- **提出形式**: 単一ファイル、必要なコードはインライン化

---
_Document standards and patterns, not every dependency_
