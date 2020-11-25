# 特殊化

テンプレートでは実引数に応じて関数やクラスを生成します。

```cpp
// 関数テンプレート
template <typename T>
T Sum(T a, T b) {
    return a + b;
}

// 関数テンプレートの関数の呼び出し
Sum<int>(1, 2);
```

`Sum<int>(1, 2)` という関数テンプレートの関数の呼び出しによって
`T` が `int` である関数が必要と判断され、次の関数が生成されます。

```cpp
int Sum(int a, int b) {
    return a + b;
}
```

このようにテンプレートを使用する箇所において、
関数テンプレートから関数を生成することおよび
クラステンプレートからクラスを生成することを特殊化 (または暗黙的インスタンス化) といいます。

特殊化はコンパイラによって行われるため、
ヘッダファイルで関数テンプレートを使用する場合にはそのヘッダファイルで定義も行います。

=== "sum.h"

    ```cpp
    #ifndef SUM_H_
    #define SUM_H_

    template <typename T>
    inline T Sum(T a, T b) {  // inline 指定が必要
        return a + b;
    }

    #endif  // SUM_H_
    ```

=== "main.cc"

    ```cpp
    #include <iostream>

    #include "sum.h"

    int main() {
        std::cout << Sum(1, 2) << std::endl;
        return 0;
    }
    ```

??? question "テンプレートの明示的インスタンス化とextern template"
    ヘッダーファイルなどのテンプレートを使用する箇所で関数やクラスを生成すると、
    コンパイル速度が低下してしまいます。
    ヘッダファイルでは宣言だけ行い、ソースファイルで明示的に関数やクラスを生成することで
    予めtenmplateを実体化できるのでコンパイル速度が向上します。

    === "sum.h"

        ```cpp
        #ifndef SUM_H_
        #define SUM_H_

        template <typename T>
        T Sum(T a, T b);  // 宣言だけ行う (inline もつけない)

        #endif  // SUM_H_
        ```

    === "sum.cc"

        ```cpp
        #include "sum.h"

        // 関数テンプレートの定義
        template <typename T>
        T Sum(T a, T b) {
            return a + b;
        }

        // 明示的インスタンス化
        template int Sum<int>(int, int);
        ```

    こうした構成にすると使用可能な型はソースファイルで明示的な生成を行う型のみとなってしまいます。
    たとえば `Sum<double>(double, double)` は生成されていないため
    `Sum(1.2, 3.4)` のように関数テンプレートの関数を呼び出すとリンクエラーになります。
    かといって明示的なインスタンス化を増やしていくと、それを共有ライブラリにすることを考えた場合、
    ライブラリサイズが肥大化してしまいます。

    こうした問題を避けるためには、extern templateを利用します。
    通常通りヘッダファイルでtemplate関数/クラスの定義を行うのですが
    実体化する頻度が高いものだけをexternし、ソースファイルで実体化させます

    === "sum.h"

        ```cpp
        #ifndef SUM_H_
        #define SUM_H_

        // 関数テンプレートの定義
        template <typename T>
        T Sum(T a, T b) {
            return a + b;
        }

        //暗黙的実体化を阻止
        extern template int Sum<int>(int, int);
        #endif  // SUM_H_
        ```

    === "sum.cc"

        ```cpp
        #include "sum.h"

        //よく使うものだけ実体化させる
        template int Sum<int>(int, int);
        ```

## 完全特殊化

特殊化によって関数テンプレートやクラステンプレートから関数やクラスを生成する代わりに、
通常の関数やクラスを使用するように指定することで
特定のテンプレート引数に対する挙動を変更することができます。
これを完全特殊化 (または明示的特殊化) といいます。

関数テンプレートの完全特殊化は次のようにします。

```cpp hl_lines="6 7 8 9"
template <typename T>
T DoSomething(T a, T b) {
    return a + b;
}

template <>
double DoSomething<double>(double a, double b) {
    return a * b;
}

std::cout << DoSomething(2, 3) << std::endl;  // 5
std::cout << DoSomething(2.0, 3.0) << std::endl;  // 6
```

関数の前に `template <>` を付けて完全特殊化を行うことを指定し、
関数名の後に `< ... >` で対象となるテンプレート引数を指定します。

クラステンプレートの完全特殊化も同様です。

```cpp hl_lines="21 22"
template <typename T>
class Array {
 public:
    explicit Array(int size)
        : size_(size),
          data_(new T[size_]) {}

    ~Array() {
        delete[] data_;
    }

    int Size() const {
        return size_;
    }

 private:
    const int size_;
    T* data_;
};

template <>
class Array<bool> {
 public:
    explicit Array(int size)
        : size_(size),
          data_size_((size - 1) / 8 + 1),
          data_(new uint8_t[data_size_]) {}

    ~Array() {
        delete[] data_;
    }

    int Size() const {
        return size_;
    }

 private:
    const int size_;
    const int data_size_;
    uint8_t* data_;
};
```

この例では8個の `bool` 値を1個の `uint8_t` で扱って省メモリ化するために、
`bool` に対する完全特殊化を行っています。

## 部分特殊化

特定のテンプレート引数に対して
特殊化で使用する関数テンプレートやクラステンプレートを別のテンプレートに変更することができます。
これを部分特殊化といいます。

詳細は
[テンプレートの部分特殊化 - cppreference.com][cppreference_partial_specialization]
を参照してください。

[cppreference_partial_specialization]: https://ja.cppreference.com/w/cpp/language/partial_specialization
