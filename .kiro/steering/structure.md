# Project Structure

## Organization Philosophy

**問題ベース + ライブラリ分離**: 各コンテスト・問題ごとにディレクトリを分け、共通ライブラリは独立して管理。提出時は単一ファイルにまとめる。

## Directory Patterns

### Contest Solutions
**Location**: `/contests/{contest-name}/`
**Purpose**: コンテストごとの解答コードを格納
**Example**: `/contests/abc300/a.hs`, `/contests/abc300/b.hs`

### Library Modules
**Location**: `/lib/`
**Purpose**: 再利用可能なアルゴリズムとデータ構造
**Example**: `/lib/Graph.hs`, `/lib/NumberTheory.hs`

### Templates
**Location**: `/templates/`
**Purpose**: 新規問題用のボイラープレート
**Example**: `/templates/main.hs`（基本テンプレート）

### Tests
**Location**: `/tests/` または各問題ディレクトリ内
**Purpose**: サンプルケースとユニットテスト
**Example**: `/contests/abc300/a_test/`

## Naming Conventions

- **Files**: 小文字、問題番号に対応（`a.hs`, `b.hs`, `c.hs`...）
- **Modules**: PascalCase（`Graph`, `NumberTheory`）
- **Functions**: camelCase（`solve`, `readInt`, `binarySearch`）
- **Types**: PascalCase（`Graph`, `Edge`）

## Import Organization

```haskell
-- 標準ライブラリ
import Control.Monad
import Data.List

-- 外部パッケージ
import qualified Data.ByteString.Char8 as BS
import qualified Data.Vector.Unboxed as VU

-- プロジェクト内モジュール（開発時のみ）
import Lib.Graph
```

## Code Organization Principles

- **提出コード**: 単一ファイル完結、外部依存なし
- **ローカル開発**: モジュール分割可、テスト容易性重視
- **ライブラリ**: コピペ可能な形式で記述
- **Main 関数**: 入力パース → 計算 → 出力の3段階

---
_Document patterns, not file trees. New files following patterns shouldn't require updates_
