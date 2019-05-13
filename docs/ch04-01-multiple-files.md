# 複数ファイル

C++ では2種類のファイルを扱います。

- ヘッダ (拡張子: `.h` , `.hpp` )
    - 関数のプロトタイプ宣言を記述します。
- ソース (拡張子: `.cpp` , `.cc` , `.cxx` )
    - 関数の実装を記述します。

複数のファイルを跨いだコードを書くには次のようにします。
`main.cc` 内で `a.cc` の `DoSomething()` を使うためにプロトタイプ宣言をしています。

!!! example "main.cc"
    ```cpp linenums="1" hl_lines="1"
    void DoSomething(); // プロトタイプ宣言

    int main() {
        DoSomething();
    }
    ```

!!! example "a.cc"
    ```cpp linenums="1"
    void DoSomething() { /* 実装省略 */ }
    ```

!!! info
    複数ファイルをコンパイルして実行ファイルを生成する場合は、
    次のようにコンパイルしたいファイルを並べてコマンドを実行します。

    ```bash
    $ g++ main.cc a.cc
    ```

上記のコードでも動作はしますが、
`a.cc` に記述している関数を他の様々なソースから利用したいとなった場合に、
その都度、それぞれのソースにプロトタイプ宣言を追加することになり、手間がかかります。

そこで登場するのがヘッダです。
プロトタイプ宣言だけヘッダに記述することで、宣言を1回書くだけで済むようになります。

!!! example "a.h"
    ```cpp linenums="1" hl_lines="1 2"
    void DoSomething();
    void DoSomething2();
    ```

!!! example "main.cc"
    ```cpp linenums="1" hl_lines="1"
    #include "a.h"

    int main() {
        DoSomething();
        DoSomething2();
    }
    ```

!!! example "a.cc"
    ```cpp linenums="1"
    void DoSomething() { /* 実装省略 */ }
    void DoSomething2() { /* 実装省略 */ }
    ```

`main.cc` 内で `a.cc` の関数を利用できるようにするために

1. `a.h` で `a.cc` の関数のプロトタイプ宣言をします。
2. `main.cc` で `a.h` を取り込むために `#include "a.h"` と記述します。

これで `main.cc` から `a.cc` の関数を利用することが出来ます。

## インクルードガード

ヘッダにはインクルードガードが必要です。

!!! example "a.h"
    ```cpp linenums="1" hl_lines="1 2 7"

    #ifndef A_H_
    #define A_H_

    void DoSomething();
    void DoSomething2();

    #endif  // A_H_
    ```

インクルードガードがあることで、ソースが同じヘッダを複数回インクルードすることを防ぎます。

`_` で始まる名前や `__` を含むような名前は、
コンパイラや標準ライブラリにて予約されている識別子と名前が被る恐れがあるため使ってはいけません。

!!! Warning ""
    ```cpp
    #define _A_H_ //  _ で始まるのでNG
    #define A__H_ // __ を含むのでNG
    ```

インクルードガードは一般的にプロジェクトごとに命名規則を設けます。