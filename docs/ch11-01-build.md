# 11.1 ビルド

ソースファイルから実行ファイルを生成する処理をビルドといいます。
ビルドは次の手順で行われます。

1. コンパイル
1. リンク

## コンパイル

人間が扱うソースファイルをコンピュータで扱うために0と1の表現 (機械語) に変換することをコンパイルといいます。
コンパイルはソースファイル単位で行います。

狭義ではコンパイルを行うプログラムのことをコンパイラといいますが、
通常はコンパイラと呼んでいるプログラムによって一連のビルド処理が提供されます。

ソースファイルを機械語に変換した結果はオブジェクトファイルと呼ばれます。
コンパイルだけ実行するには `-c` を指定します。

```bash
$ g++ -std=c++11 -c main.cc
$ g++ -std=c++11 -c util.cc
```

このコマンドを実行すると
`main.cc` から `main.o`、 `util.cc` から `util.o` へコンパイルされます。

コンパイルだけでは実行ファイルは生成されません。