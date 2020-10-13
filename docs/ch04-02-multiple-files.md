# 複数ファイル

## ファイルの種類

C++ では2種類のファイルを扱います。

- ヘッダ (拡張子: `.h` , `.hpp` )
    - 関数のプロトタイプ宣言を記述します。
- ソース (拡張子: `.cpp` , `.cc` , `.cxx` )
    - 関数の実装を記述します。

## ソースファイルを分ける

1 つのソースファイルにコードを書き続けていると、
コードの量が多くなった時に、読みにくくなったり、書きにくくなったりするので、
適度にコードを複数のファイルに分ける必要があります。

複数のファイルを跨いだコードを書くには次のようにします。
`main.cc` 内で `a.cc` の関数を使うためにプロトタイプ宣言をしています。

=== "main.cc"

    ```cpp linenums="1" hl_lines="1 2 3 4 5"
    void DoSomething();   // プロトタイプ宣言
    void DoSomething2();  // プロトタイプ宣言
    void DoSomething3();  // プロトタイプ宣言
    void DoSomething4();  // プロトタイプ宣言
    void DoSomething5();  // プロトタイプ宣言

    int main() {
        DoSomething();
        DoSomething2();
        DoSomething3();
        DoSomething4();
        DoSomething5();

        return 0;
    }
    ```

=== "a.cc"

    ```cpp linenums="1"
    void DoSomething() { /* 実装省略 */ }
    void DoSomething2() { /* 実装省略 */ }
    void DoSomething3() { /* 実装省略 */ }
    void DoSomething4() { /* 実装省略 */ }
    void DoSomething5() { /* 実装省略 */ }
    ```

!!! info "複数ファイルのコンパイル"
    複数ファイルをコンパイルして実行ファイルを生成する場合は、
    次のようにコンパイルしたいソースファイルを並べてコマンドを実行します。

    ```bash
    $ g++ -std=c++11 main.cc a.cc
    ```

上記のコードでも動作はしますが、
`a.cc` に記述している関数を他の様々なソースから利用したいとなった場合に、
その都度、それぞれのソースにプロトタイプ宣言を追加することになり、手間がかかります。

## ヘッダファイルを利用する

ソースファイルを分けるだけでは、手間がかかりますが、合わせてヘッダを使うことで簡潔になります。
プロトタイプ宣言だけヘッダに記述することで、宣言を 1 回書くだけで済むようになります。

=== "main.cc"

    ```cpp linenums="1" hl_lines="1"
    #include "a.h"

    int main() {
        DoSomething();
        DoSomething2();
        DoSomething3();
        DoSomething4();
        DoSomething5();

        return 0;
    }
    ```

=== "a.h"

    ```cpp linenums="1" hl_lines="1 2 3 4 5"
    void DoSomething();   // プロトタイプ宣言
    void DoSomething2();  // プロトタイプ宣言
    void DoSomething3();  // プロトタイプ宣言
    void DoSomething4();  // プロトタイプ宣言
    void DoSomething5();  // プロトタイプ宣言
    ```

=== "a.cc"

    ```cpp linenums="1"
    void DoSomething() { /* 実装省略 */ }
    void DoSomething2() { /* 実装省略 */ }
    void DoSomething3() { /* 実装省略 */ }
    void DoSomething4() { /* 実装省略 */ }
    void DoSomething5() { /* 実装省略 */ }
    ```

`main.cc` 内で `a.cc` の関数を利用できるようにするために

1. `a.h` で `a.cc` の関数のプロトタイプ宣言をします。
1. `main.cc` で `a.h` を取り込むために `#include "a.h"` と記述します。

これで `main.cc` から `a.cc` の関数を利用することが出来ます。
例え、他のソースから `a.cc` の関数を利用したいとなっても、そのソース毎に `#include "a.h"` を記述するだけで済みます。

コンパイル時には、ヘッダファイルを指定する必要はありません。

```bash
# a.h は指定しなくて良い
g++ -std=c++11 main.cc a.cc
```

## インクルードガード

ヘッダにはインクルードガードが必要です。

=== "a.h"

    ```cpp linenums="1" hl_lines="1 2 7"

    #ifndef A_H_
    #define A_H_

    void DoSomething();
    void DoSomething2();

    #endif  // A_H_
    ```

インクルードガードがあることで、ソースが同じヘッダを複数回取り込む事がなくなり、
変数や関数の定義が重複することを防げます。

インクルードガードは一般的にプロジェクトごとに命名規則を設けます。

!!! warning "使用してはいけない名前"
    `_` で始まる名前や `__` を含むような名前は、
    コンパイラや標準ライブラリにて予約されている識別子と名前が被る恐れがあるため使ってはいけません。

    ```cpp
    #define _A_H_  //  _ で始まるのでNG
    #define A__H_  // __ を含むのでNG
    ```

インクルードガードはプリプロセッサ司令の仕組みを用いて実現しています。
プリプロセッサ司令の詳細については、 [プリプロセッサ司令] を参照してください。

[プリプロセッサ司令]: appendix-preprocessor-directives.md