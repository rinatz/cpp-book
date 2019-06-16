# プリプロセッサ司令

プリプロセッサはコンパイルを行う前にソースファイルの変換などを行うプログラムです。

## インクルード

`#include` で指定ファイルを読み込んでその場に展開します。
単純なファイル展開であるためインクルードガードなどが必要となります。

ファイルの指定には `"..."` と `<...>` の2種類があります。

`<...>` は標準のインクルードディレクトリからファイルを検索します。
標準のインクルードディレクトリは一般に次のもので構成されます。

* `C` および `C++` の標準ライブラリ
* 処理系の標準ライブラリ (Windows における `windows.h` など)
* オプション指定されたディレクトリ (外部ライブラリなど)

`"..."` はカレントディレクトリからファイルを検索します。
見つからなかった場合には `<...>` と同様に標準のインクルードディレクトリからファイルを検索します。

## マクロ

`#define` でマクロを定義して文字列置換を行います。

定義されたマクロはソースファイルの末尾まで有効です。
ソースファイルの途中で無効化するには `#undef` を使用します。

### オブジェクト形式

オブジェクト形式のマクロは固定の文字列へ置換されます。

一般に定数として利用されますが、
特別な理由がない限り `constexpr` 変数の使用が望ましいです。

```cpp
#define BUFFER_SIZE 256

int main() {
    // `char buffer[256];` に置換される
    char buffer[BUFFER_SIZE];

    return 0;
}
```

### 関数形式

関数形式のマクロは引数を使用して文字列へ置換されます。

一般に型に依存しない関数として使用されますが、
特別な理由がない限り関数テンプレートの使用が望ましいです。

```cpp
#define ECHO(VALUE) VALUE

int main() {
    // `std::cout << 2 << std::endl;` に置換される
    std::cout << ECHO(2) << std::endl;

    // `std::cout << ECHO("abc") << std::endl;` に置換される
    std::cout << ECHO("abc") << std::endl;

    return 0;
}
```

意図しない挙動にならないよう置換内容の工夫が必要となることがあります。

```cpp
#include <iostream>

// VALUE1 と VALUE2 の和
#define SUM(VALUE1, VALUE2) VALUE1 + VALUE2

int main() {
    // `1 + 2` に置換される
    int a = SUM(1, 2);

    // `1 + 2 * 3` に置換される
    int b = SUM(1, 2) * 3;

    std::cout << a << std::endl;  // 3
    std::cout << b << std::endl;  // 7 (9 にならない)

    return 0;
}
```

意図通りの挙動にするためには次のように括弧で囲む必要があります。

```cpp
// VALUE1 と VALUE2 の和
#define SUM(VALUE1, VALUE2) (VALUE1 + VALUE2)
```

他にも次のようなケースがあります。

```cpp
// 条件 EXPECTED が満たされていない時に MESSAGE を出力
#define ERROR_LOG(EXPECTED, MESSAGE)       \  // \ で改行できる
    if (!(EXPECTED)) {                     \
        std::cout << MESSAGE << std::endl; \
    }

int main() {
    // 期待通りの動作
    ERROR_LOG(1 > 0, "message1");  // true なので実行されない
    ERROR_LOG(1 < 0, "message2");  // false なので実行される

    // 展開されるとブロック有り if 文なのでセミコロンがなくてもエラーにならない
    ERROR_LOG(false, "message3")

    // ブロック無し if 文では制御構造が変化してしまう
    if (false)
        ERROR_LOG(false, "message4")
    else
        ERROR_LOG(false, "message5")  // 実行されない

    return 0;
}
```

ブロック無し if 文では次のように展開されます。

```cpp
if (false)
    if (!(false)) { std::cout << "message4" << std::endl; }
else
    if (!(false)) { std::cout << "message5" << std::endl; }
```

分かりやすいように整形すると次のようになります。

```cpp
if (false)
    if (!(false)) {
        std::cout << "message4" << std::endl;
    } else if (!(false)) {
        std::cout << "message5" << std::endl;
    }
```

`else` が `if` の中に入ってしまってい、次の `if` とつながって `else if` となっています。

このような問題を避けるためには
[複文マクロ][more_cplusplus_idioms_multi_statement_macro] と呼ばれるイディオムを使用します。

[more_cplusplus_idioms_multi_statement_macro]: https://ja.wikibooks.org/wiki/More_C%2B%2B_Idioms/複文マクロ(Multi-statement_Macro)

```cpp
#define ERROR_LOG(EXPECTED, MESSAGE)           \
    do {                                       \
        if (!(EXPECTED)) {                     \
            std::cout << MESSAGE << std::endl; \
        }                                      \
    } while (false)
```

### 定義済みマクロ

定義済みマクロの一部を紹介します。

一覧は [テキストマクロの置換 - cppreference.com][cppreference_replace] を参照してください。

[cppreference_replace]: https://ja.cppreference.com/w/cpp/preprocessor/replace

#### ファイル名と行番号

ソースファイルやヘッダファイルの情報として
`__FILE__` でファイル名、
`__LINE__` で行番号を取得することができます。

ログ出力ではこれらの値を使用するために、
ログ出力関数を関数形式のマクロで定義するのが一般的です。

#### C++ バージョン

`__cplusplus` で使用している C++ のバージョンを表す数値を取得できます。
C++11 であれば `201103L` という値に置換されます。

C++ のバージョンに応じて有効/無効を制御するために使用されます。

## 条件

次の司令で条件に応じてコードの有効/無効を分けることができます。

* `#if`
* `#elif`
* `#else`
* `#endif`

```cpp
#include <iostream>

int main() {
#if true
    std::cout << "true" << std::endl;  // 有効 (コンパイルされる)
#endif

#if false
    std::cout << "false" << std::endl;  // 無効 (コンパイル前に削除される)
#endif

#if false
    std::cout << "1" << std::endl;  // 無効
#elif true
    std::cout << "2" << std::endl;  // 有効
#else
    std::cout << "3" << std::endl;  // 無効
#endif

    return 0;
}
```

`defined` によってマクロが定義されているかどうかを条件にすることができます。

```cpp
#include <iostream>

// 条件だけに使用するマクロは置換文字列を空にする
#define SAMPLE_A

int main() {
#if defined SAMPLE_A
    std::cout << "A" << std::endl;  // 有効
#endif

#if defined SAMPLE_B
    std::cout << "B" << std::endl;  // 無効
#endif

    return 0;
}
```

### #ifdef と #ifndef

マクロが定義されているかという条件は多用されるため、
`#if defined` の短縮として `#ifdef`、
否定 `#if !defined` の短縮として `#ifndef` という司令があります。

これらを活用してインクルードガードは実現されています。

```cpp
#ifndef SAMPLE_H_
#define SAMPLE_H_

// 内容

#endif  // SAMPLE_H_
```
