# AtCoder Problem Fetcher

AtCoder の問題 URL から問題文と Haskell ソースファイルを自動生成する CLI ツール。

## Features

- AtCoder の問題ページから問題文を取得して Markdown 形式で保存
- テンプレート付きの Haskell ソースファイルを自動生成
- コンテスト一括取得と単一問題取得をサポート
- 設定ファイルによるデフォルト値の永続化

## Requirements

- GHC 9.4+
- Stack 2.x

## Installation

### Using Docker (Recommended)

```bash
# Build and run development environment
docker-compose run --rm dev

# Inside container
stack build
stack exec atcoder-problem-fetcher -- --help
```

### Using Stack

```bash
stack build
stack exec atcoder-problem-fetcher -- --help
```

## Usage

### Fetch a single problem

```bash
atcoder-problem-fetcher fetch https://atcoder.jp/contests/abc300/tasks/abc300_a
```

### Fetch all problems in a contest

```bash
atcoder-problem-fetcher fetch https://atcoder.jp/contests/abc300/tasks
```

### Configure defaults

```bash
atcoder-problem-fetcher setup
```

## Development

```bash
# Run tests
stack test

# Run with Docker
docker-compose run --rm test
```

## License

MIT
