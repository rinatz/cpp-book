# 例外処理

例外処理とはプログラム実行中にエラーが発生した場合に、
後続の処理を行うのをやめてエラー発生時用の処理を行うための機能です。

!!! warning "コーディング規約による例外処理の使用禁止"
    C++ における例外処理は問題点が多く、
    [Google C++ Style Guide] や [LLVM Coding Standards] では例外処理の使用を原則禁止しています。

[Google C++ Style Guide]: https://google.github.io/styleguide/cppguide.html#Exceptions
[LLVM Coding Standards]: http://llvm.org/docs/CodingStandards.html#do-not-use-rtti-or-exceptions

例外処理においてエラーを表すもの例外といいます。
例外処理は次の2つの段階で構成されます。

1. エラーが発生する箇所で例外を送出し、後続の処理を行うのをやめる
1. 送出された例外を捕捉し、エラー発生時用の処理を行う

正の整数を表す `std::string` を `int` に変換する処理において、
無効な文字があった場合に変換処理をやめてエラーメッセージを出力するには
次のようにします。

```cpp hl_lines="2 18 19 23 24 25 26"
std::string str = "123XY56";
try {
    int num = 0;
    for (const auto s : str) {
        num *= 10;
        switch (s) {
            case '0':  num += 0;  break;
            case '1':  num += 1;  break;
            case '2':  num += 2;  break;
            case '3':  num += 3;  break;
            case '4':  num += 4;  break;
            case '5':  num += 5;  break;
            case '6':  num += 6;  break;
            case '7':  num += 7;  break;
            case '8':  num += 8;  break;
            case '9':  num += 9;  break;
            default:
                // コンストラクタの引数でエラーメッセージを設定
                throw std::runtime_error("数値ではない文字が入っています");
        }
    }
    std::cout << num << std::endl;  // 問題なく変換できた場合には変換後の値を出力
} catch (const std::runtime_error& e) {
    // what() でエラーメッセージを取得
    std::cout << e.what() << std::endl;
}
```

例外の送出は `throw` で行います。

この例では数値ではない文字がある場合にエラーとして
例外 `std::runtime_error` を送出し、
残っている文字の変換処理は行わずにエラー発生時用の処理を行います。

`try` ブロック内で送出した例外は `catch` ブロックで捕捉します。

この例では例外 `std::runtime_error` が送出された場合に
参照 `e` で受けて `e.what()` でエラーメッセージを取得して出力します。

## 例外の型

例外にはあらゆる型が使用できます。

```cpp
try {
    throw 123;
} catch (const int v) {
    std::cout << v << std::endl;
}
```

通常は標準ライブラリの例外クラスやそれを継承したユーザ定義クラスを使用します。

## 型に応じた捕捉

1つの `try` ブロックに対して `catch` ブロックは複数記述することができます。
これによって例外の型に応じた処理を行うことができます。

```cpp
try {
    throw 123;  // int を送出
} catch (const bool v) {  // int は bool とは異なる型であるため捕捉されない
    std::cout << "bool: " << v << std::endl;
} catch (const int v) {  // ここで捕捉される
    std::cout << "int: " << v << std::endl;
}
```

例外の型がクラスである場合にはアップキャストを含めて捕捉は行われます。
捕捉は上から順に確認して最初に一致したものだけが処理されます。

```cpp
try {
    throw std::runtime_error("test");  // std::runtime_error を送出
} catch (const std::exception& e) {
    // std::runtime_error は std::exception の派生クラスであるためここで捕捉される
    std::cout << "std::exception: " << e.what() << std::endl;
} catch (const std::runtime_error& e) {
    // この処理は実行されない
    std::cout << "std::runtime_error: " << e.what() << std::endl;
}
```

`catch (...)` と記載することであらゆる例外を捕捉することができます。
この `catch` ブロックでは例外オブジェクトを参照することができません。

```cpp
try {
    throw 123;
} catch (...) {
    std::cout << "Unexpected exception was thrown." << std::endl;
}
```

## 関数から例外を送出

関数内で例外が捕捉されない場合、
捕捉されるまで関数の呼び出し元を順に辿っていきます。

正の整数を表す `std::string` を `int` に変換する処理を関数化し、
無効な文字があった場合に関数から例外を送出するには次のようにします。

```cpp hl_lines="17"
int StringToInt(const std::string& str) {
    int num = 0;
    for (const auto s : str) {
        num *= 10;
        switch (s) {
            case '0':  num += 0;  break;
            case '1':  num += 1;  break;
            case '2':  num += 2;  break;
            case '3':  num += 3;  break;
            case '4':  num += 4;  break;
            case '5':  num += 5;  break;
            case '6':  num += 6;  break;
            case '7':  num += 7;  break;
            case '8':  num += 8;  break;
            case '9':  num += 9;  break;
            default:
                throw std::runtime_error("数値ではない文字が入っています");
        }
    }
    return num;
}
```

この関数内では例外を捕捉しないため `try` ブロックがありません。

呼び出し元で捕捉するためには次のようにします。

```cpp hl_lines="2 3 5"
std::string str = "123XY56";
try {
    auto num = StringToInt(str);
    std::cout << num << std::endl;
} catch (const std::runtime_error& e) {
    std::cout << e.what() << std::endl;
}
```

例外を送出するのは呼び出す関数の内部であるため、
この `try` ブロックには `throw` がありません。

1文字ずつの数値への変換処理を関数化すると、
例外が捕捉されるまでの間に関数呼び出しを2回遡ります。

!!! example "exception.cc"
    ```cpp linenums="1" hl_lines="17 18 27 28 36 37"
    #include <iostream>
    #include <string>

    int CharToInt(const char c) {
        switch (c) {
            case '0':  return 0;
            case '1':  return 1;
            case '2':  return 2;
            case '3':  return 3;
            case '4':  return 4;
            case '5':  return 5;
            case '6':  return 6;
            case '7':  return 7;
            case '8':  return 8;
            case '9':  return 9;
            default:
                // 関数から例外を送出
                throw std::runtime_error("数値ではない文字が入っています");
        }
    }

    int StringToInt(const std::string& str) {
        int num = 0;
        for (const auto s : str) {
            num *= 10;

            // CharToInt から例外が送出される
            num += CharToInt(s);
        }
        return num;
    }

    int main() {
        std::string str = "123XY56";
        try {
            // StringToInt 内部の CharToInt から例外が送出される
            auto num = StringToInt(str);

            std::cout << num << std::endl;
        } catch (const std::runtime_error& e) {
            std::cout << e.what() << std::endl;
        }

        return 0;
    }
    ```

## 例外が捕捉されない場合

送出された例外が捕捉されない場合、
[std::terminate][cpprefjp_terminate] が呼び出されてプログラムが異常終了します。

```cpp hl_lines="3"
int main() {
    std::string str = "123XY56";
    auto num = StringToInt(str);
    std::cout << num << std::endl;
    return 0;
}
```

実行結果は次のようになります。

```txt
$ ./a.out
terminate called after throwing an instance of 'std::runtime_error'
  what():  数値ではない文字が入っています
Aborted (core dumped)
```

## noexcept

関数が例外を送出しないことを明示的に表すには `noexcept` をつけます。
デストラクタは暗黙的に `noexcept` になります。

<!-- MEMO: delete 演算子もデフォルトで noexcept になる -->

```cpp
int Compare(int a, int b) noexcept {
    if (a < b) {
        return -1;
    } else if (a > b) {
        return 1;
    } else {  // a == b
        return 0;
    }
}
```

`noexcept` には条件を指定することができます。

```cpp
int Compare(int a, int b) noexcept(true);  // 例外を送出しない
int CharToInt(const char c) noexcept(false);  // 例外を送出する
```

`noexcept` 内で `noexcept` を使用すると、
他の関数が `noexcept` であるかどうかを条件に指定することができます。

```cpp
int StringToInt(const std::string& str) noexcept(noexcept(CharToInt(char())));
```

`noexcept` 指定された関数から例外が送出された場合、
[std::terminate][cpprefjp_terminate] が呼び出されてプログラムが異常終了します。

!!! warning "非推奨の動的例外仕様"
    関数から送出される例外を列挙するための `throw` というキーワードがありますが、
    C++11 では非推奨となっており C++17 では削除されているため使用しないでください。

    ```cpp
    int CharToInt(const char c) throw(std::runtime_error);
    ```

    詳細は
    [非推奨だった古い例外仕様を削除 - cpprefjp C++日本語リファレンス][cpprefjp_dynamic_exception_specification]
    を参照してください。

[cpprefjp_dynamic_exception_specification]: https://cpprefjp.github.io/lang/cpp17/remove_deprecated_exception_specifications.html

## 標準ライブラリの例外クラス

標準ライブラリの例外クラスの一部を紹介します。

一覧は [std::exception - cppreference.com][cppreference_exception] を参照してください。

[cppreference_exception]: https://ja.cppreference.com/w/cpp/error/exception

![クラス図][class-diagram]

[class-diagram]: img/exception_class.svg

!!! question "std::logic_error と std::runtime_error の違い"
    一般に
    プログラム実行前に検出可能なものは `std::logic_error`、
    プログラム実行時にのみ検出可能なものは `std::runtime_error` として分類されています。

### std::exception

すべての標準ライブラリの例外クラスの基底クラスです。

このクラスで例外を捕捉することにより、
標準ライブラリの例外クラスをすべて捕捉することができます。

```cpp
int main() {
    std::string str = "123XY56";
    try {
        auto num = StringToInt(str);  // std::runtime_error を送出
        std::cout << num << std::endl;
    } catch (const std::exception& e) {
        // std::exception で std::runtime_error を捕捉
        std::cout << e.what() << std::endl;
    }

    return 0;
}
```

### std::logic_error

前提条件を満たしていないなど論理エラーを表すためのクラスです。

標準ライブラリで `std::logic_error` を送出するものはありません。

### std::invalid_argument

関数の実引数が不正な値である場合の論理エラーを表すためのクラスです。

`std::bitset` で変換できない文字列を指定した場合などに送出されます。

```cpp
try {
    std::bitset<8> b("0000x111");  // 不正な文字 x を含んでいる
    std::cout << b << std::endl;
} catch (const std::invalid_argument& e) {
    std::cout << "std::invalid_argument を捕捉" << std::endl;
    std::cout << e.what() << std::endl;
}
```

`std::bitset` では文字列から2進数数値への変換処理をコンストラクタで行っています。
一般にコンストラクタには戻り値がないため、戻り値によってエラー有無を判断することができません。
そのためコンストラクタでエラーが発生した場合には、例外を送出するものがあります。

### std::out_of_range

配列のようなデータに対する要素参照で
範囲外が指定された場合の論理エラーを表すためのクラスです。

`std::vector` の `at()` で範囲外の要素を参照しようとした場合などに送出されます。

```cpp
std::vector<int> x = {1, 2, 3, 4, 5};  // 要素数が 5 のベクタ

try {
    int a = x.at(5);  // at() で要素参照
    std::cout << "5番目の値: " << a << std::endl;
} catch (const std::out_of_range& e) {
    std::cout << "std::out_of_range を捕捉" << std::endl;
    std::cout << e.what() << std::endl;
}
```

`std::vector` の `[]` で範囲外の要素を参照しようとした場合には例外は送出されません。

```cpp
std::vector<int> x = {1, 2, 3, 4, 5};  // 要素数が 5 のベクタ

try {
    int a = x[5];  // [] で要素参照
    std::cout << "5番目の値: " << a << std::endl;  // 不定値が出力される
} catch (...) {
    std::cout << "例外を捕捉" << std::endl;  // 例外は送出されないため実行されない
}
```

!!! question "セグメンテーション違反"
    この例で `[]` で範囲外の要素参照をする際に
    セグメンテーション違反が発生して OS によってプログラムが終了される可能性もあります。

<!-- TODO: 追加予定のシグナルのページへのリンクを貼る -->

### std::runtime_error

実行時に評価する値の不正や実行環境の問題など
実行時エラーを表すためのクラスです。

<!-- TODO: std::locale 以外での例を追加する -->

### std::bad_cast

dynamic_cast で失敗した場合に送出されます。

<!-- TODO: ダウンキャストのページへのリンクを貼る -->

## デストラクタと例外

例外を送出して捕捉するまでの間に、
さらに例外を送出すると [std::terminate][cpprefjp_terminate] が呼び出されて
プログラムが異常終了します。
この事象はデストラクタから例外を送出すると発生します。

例外を送出した場合、
その例外が捕捉されるまでに生存期間が終了するオブジェクトは
デストラクタを呼び出して破棄されます。

```cpp hl_lines="6 7 14 16"
#include <iostream>

class DestructorAndException {
 public:
    ~DestructorAndException() {
        // 例外を送出して捕捉するまでの間に実行される
        std::cout << "~DestructorAndException() is called." << std::endl;
    }
};

int main() {
    try {
        DestructorAndException obj;
        throw std::runtime_error("main()");
    } catch (const std::exception& e) {
        std::cout << e.what() << std::endl;
    }

    return 0;
}
```

デストラクタから例外を送出すると、
「例外を送出して捕捉するまでの間に、さらにデストラクタから例外を送出する」ことになってしまい、
[std::terminate][cpprefjp_terminate] が呼び出されてプログラムが異常終了します。

```cpp hl_lines="10 11"
#include <iostream>

class DestructorAndException {
 public:
    // デストラクタは暗黙的に noexcept になるため noexcept(false) を明示的に指定
    ~DestructorAndException() noexcept(false) {
        // 例外を送出して捕捉するまでの間に実行される
        std::cout << "~DestructorAndException() is called." << std::endl;

        // さらに例外を送出
        throw std::runtime_error("~DestructorAndException()");
    }
};

int main() {
    try {
        DestructorAndException obj;
        throw std::runtime_error("main()");
    } catch (const std::exception& e) {
        std::cout << e.what() << std::endl;
    }

    return 0;
}
```

こうした挙動にならないように、
一般にデストラクタからは例外を送出しないようにします。

[cpprefjp_terminate]: https://cpprefjp.github.io/reference/exception/terminate.html
