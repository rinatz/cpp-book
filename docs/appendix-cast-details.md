# キャストの詳しい説明

C++ の4種類のキャスト演算子には以下のような違いがあります。

|  キャスト演算子  |  CV 修飾子の除去   | CV 修飾子以外の型情報の変更 |  ビット表現の変換  |
|------------------|--------------------|-----------------------------|--------------------|
| static_cast      | :x:                | :white_check_mark:          | :white_check_mark: |
| dynamic_cast     | :x:                | :white_check_mark:          | :white_check_mark: |
| const_cast       | :white_check_mark: | :x:                         | :x:                |
| reinterpret_cast | :x:                | :white_check_mark:          | :x:                |

CV 修飾子の追加はどのキャストでも行うことができます。

## CV 修飾子

`const` 修飾子と `volatile` 修飾子 をまとめて CV 修飾子と呼びます。

`volatile` 修飾子は
[cv (const および volatile) 型修飾子 - cppreference.com][cppreference_cv]
を参照してください。

[cppreference_cv]: https://ja.cppreference.com/w/cpp/language/cv

## static_cast と dynamic_cast

`static_cast` と `dynamic_cast` は値の変換方法を決定するタイミングが違います。

- `static_cast` はコンパイル時に決定
- `dynamic_cast` は実行時に決定

この違いによって安全にダウンキャストができるかなどの差があります。
詳細は [ダウンキャスト][downcasts] を参照してください。

[downcasts]: appendix-downcasts.md

## ビット表現の変換

`static_cast` や `dynamic_cast` では型の変換と同時にビット表現を変換しますが、
`reinterpret_cast` ではビット表現を変更せずに型だけを変更します。

整数型と浮動小数点数型などビット表現が異なる型の変換を行うと、
値の変換の有無によって挙動の差異が生じます。

```cpp
double x = 2;

int64_t s = static_cast<const int64_t&>(x);
int64_t r = reinterpret_cast<const int64_t&>(x);

std::cout << s << std::endl;  // 2
std::cout << r << std::endl;  // 4611686018427387904 (IEEE 754 の場合)
```

一般に派生クラスから基底クラスへアップキャストする場合にもビット表現の変換は必要です。
たとえば [多重継承][wikipedia_multiple_inheritance] をしている場合に、
オフセットが 0 ではない基底クラスへアップキャストすると正しい値を参照することができません。

[wikipedia_multiple_inheritance]: https://ja.wikipedia.org/wiki/継承_(プログラミング)#多重継承と仮想継承

```cpp linenums="1" hl_lines="31"
#include <iostream>

class Base1 {
 public:
    virtual ~Base1() = default;
    int x = 2;
};

class Base2 {
 public:
    virtual ~Base2() = default;
    int y = 3;
};

class Sub : public Base1, public Base2 {
 public:
    ~Sub() override = default;
};

int main() {
    Sub sub;

    Base1* s1 = static_cast<Base1*>(&sub);
    Base2* s2 = static_cast<Base2*>(&sub);
    std::cout << s1->x << std::endl;  // 2
    std::cout << s2->y << std::endl;  // 3

    Base1* r1 = reinterpret_cast<Base1*>(&sub);
    Base2* r2 = reinterpret_cast<Base2*>(&sub);
    std::cout << r1->x << std::endl;  // 2
    std::cout << r2->y << std::endl;  // 2

    return 0;
}
```

## C++ のキャストではできないこと

C++ のキャストではアクセス指定子を無視した変換などは行えませんが、
C 言語形式のキャストなら変換することができます。

アクセス指定子を無視した変換が必要となるのはクラス設計に問題がある場合なので、
C 言語形式のキャストを用いるのではなく、
アクセス指定子を修正して C++ のキャストを使用しましょう。

詳細は
[明示的な型変換 - cppreference.com][cppreference_explicit_cast]
を参照してください。

[cppreference_explicit_cast]: https://ja.cppreference.com/w/cpp/language/explicit_cast
