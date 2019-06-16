# Make

[Make] は1976年に登場して現在でも使用されているビルド自動化ツールです。

[Make]: https://en.wikipedia.org/wiki/Make_(software)

## インストール

msys2 のターミナルを起動して下記コマンドを打ってインストールします。

```bash
$ pacman -S make
```

## ビルド実行

`main.cc` をビルドして `a.exe` を生成する場合は `Makefile` を次のようにします。

<!-- FIXME: Codeblock probably can not treat tab character (&#009). -->

<table class="codehilitetable"><tr><td class="linenos"><div class="linenodiv"><pre><span></span>1
2</pre></div></td><td class="code"><div class="codehilite"><pre><span></span>a.exe: main.cc
&#009;g++ -std=c++11 main.cc
</pre></div>
</td></tr></table>

`g++` の前のインデントはタブ文字です。
スペース文字では代用できないので注意が必要です。

この `Makefile` がある状態で下記コマンドを実行すると `a.exe` がビルドされます。

```bash
$ make a.exe
```

`a.exe: main.cc` という記述は
`a.exe` を生成するためには `main.cc` が必要という意味です。
`a.exe` のような生成したいファイルのことを `ターゲット` と呼びます。

`a.exe` を生成した後に再度実行すると次のようなメッセージが出力されます。

```bash
$ make a.exe
make: 'a.exe' は更新済みです.
```

`a.exe` を生成するために必要な `main.cc` と `a.exe` の更新日時を確認して、
`a.exe` より `main.cc` の方が新しい場合にのみ処理を行うことでビルド時間を短縮しており、
処理が不要と判断された場合にこのようなメッセージが出力されます。

`main.cc` を更新すると `a.exe` よりも更新日時が新しくなるためビルドが実行されます。

2行目では先頭の文字をタブ文字にし、
その後に `a.exe` の生成のために実施するコマンド `g++ -std=c++11 main.cc` を記述します。
`make` は行頭がタブ文字である行をコマンド行として扱う仕様で、スペース文字では代用することができません。

??? question "ファイル単位でのコンパイル"
    複数のソースファイルから成り立つプログラムのビルドは
    一般に次のように段階を分けて実行されます。

    1. ソースファイルをコンパイルした結果をオブジェクトファイルとして保存する
    1. オブジェクトファイルをリンクする

    こうすることで変更のあったソースファイルだけをコンパイルしてオブジェクトファイルを更新し、
    リンクを再実行すればビルドが完了するため不要なコンパイルを省略してビルド時間を短縮することができます。

    このような処理を行うためには次のような `Makefile` を記述します。

    <!-- FIXME: Codeblock probably can not treat tab character (&#009). -->

    <div class="codehilite"><pre><span></span>a.exe: main.o util.o&#010;&#009;g++ -std=c++11 main.o util.o&#010;&#010;main.o: main.cc&#010;&#009;g++ -std=c++11 -c main.cc&#010;&#010;util.o: util.cc&#010;&#009;g++ -std=c++11 -c util.cc</pre></div>

## タスク実行

`.PHONY` でターゲットを擬似ターゲットとして指定することで、ファイル生成以外のタスク実行のために使用できます。

<!-- FIXME: Codeblock probably can not treat tab character (&#009). -->

<div class="codehilite"><pre><span></span>.PHONY: clean

clean:
&#009;rm -f a.exe
</pre></div>

`.PHONY` による指定を行わない場合、
ターゲットと名称が同一のファイルがあると実行不要と判断されて実行されなくなります。
