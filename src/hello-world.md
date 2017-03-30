# Hello, World!

標準出力に `Hello, World!` と表示するプログラムを書いてみます。

## プロジェクトディレクトリの作成

ソースコードを保存するディレクトリを作成します。

    $ mkdir -p ~/projects/hello_world
    $ cd ~/projects/hello_world

## ソースコード作成

`main.cc` というソースコードを下記のように作成します。

**main.cc**

```cpp
#include <iostream>

int main() {
  std::cout << "Hello, World!" << std::endl;

  return 0;
}
```

完成したら次のようにコマンドを実行します。

    $ g++ main.cc
    $ ./a.out
    Hello, World!

## 構文の説明

`main()` はプログラム内で最初に実行される関数です。
必ずただ1つ定義する必要があります。
`main()` の戻り値は成功(0)または失敗(0以外)を返します。

`std::cout` は標準出力に文字列を出力するクラスインスタンスです。
`#include <iostream>` と書いておくことで使用できるようになります。
`<<` の後ろに出力したい文字列を指定します。
`<<` は何度でもつなげることができ、数値なども指定できます。

```cpp
std::cout << "Hello" << ", " <<  123 << ", " << 3.14 << std::endl;
```

`std::endl` はそこで改行することを意味しています。

## コンパイル

コンパイルとはソースコードを実行可能な形式に変換する処理のことを言います。
コンパイルするには `g++` という GCC のコマンドを実行します。

    $ g++ main.cc

成功すれば `a.out` という実行ファイルが作成されます。

    $ ls
    a.out main.cc

`a.out` を叩けばプログラムが実行されます。

    $ ./a.out
    Hello, World!
