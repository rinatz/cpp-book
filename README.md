# ゼロから学ぶ C++

このリポジトリはオンライン学習サイト [ゼロから学ぶ C++] のソースコードリポジトリです。

## 必要なもの

ソースコードから HTML ページを生成するには下記のものが必要です。

- Python
- Poetry
- Make

## ビルド

HTML を生成するには下記のコマンドを実行してください。

```shell
$ make init
$ make build
```

ビルド結果をブラウザ上で確認するには次のコマンドを実行します。

```shell
$ make serve
```

http://localhost:8000 にアクセスすると Web ページが表示されます。

[ゼロから学ぶ C++]: https://rinatz.github.io/cpp-book
