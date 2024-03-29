# 配列

配列は同一の型を持つ複数の値をまとめて管理するための型です。
使い方は次のとおりです。

```cpp
int x[5] = {0, 1, 2, 3, 4};
```

これで 5 要素の値を持つ配列が宣言されます。

## 要素参照

配列の要素を参照するには配列の何番目の要素なのかを指定します。
数えの始まりは 0 からになります。

```cpp
int x[5] = {0, 1, 2, 3, 4};
int y = x[2];  // 2
```

## 初期化のバリエーション

配列の宣言と同時に要素を設定する場合は要素数の指定が省略できます。

```cpp
int x[] = {0, 1, 2, 3, 4, 5};
```

配列の宣言後に要素を設定する場合は要素数の指定が必要です。

```cpp
int x[5];

x[0] = 0;
x[1] = 1;
x[2] = 2;
x[3] = 3;
x[4] = 4;
```

要素数に比べて設定した要素の個数が少ない場合は残りの要素がゼロで初期化されます。

```cpp
int x[5] = {0, 1, 2};  // x[3], x[4] はゼロで初期化
```

要素を全く指定しないとすべての要素がゼロで初期化されます。

```cpp
int x[5] = {};
```

これが一番手軽な初期化方法です。

## 配列とポインタ

配列はいくつかの例外を除いて常にポインタ型に暗黙変換されます。このため配列を参照する時に、 `[]` を省略すると、配列の先頭を指し示すポインタが取得できます。
先頭のポインタにインデックスを足すことで、それぞれの要素に対応したポインタが取得できます。

```cpp
#include <iostream>

int x[] = {2, 4, 6, 8, 10};
int* p = x;
std::cout << *p << std::endl;        // 2
std::cout << *(p + 1) << std::endl;  // 4
std::cout << *(p + 2) << std::endl;  // 6
std::cout << *(p + 3) << std::endl;  // 8
std::cout << *(p + 4) << std::endl;  // 10
```

## 関数に配列を渡す

配列がポインタ型に暗黙変換される仕様があることに加えてもう一つ注意するべき仕様があります。関数の引数宣言で配列型をつかうとき、ポインタ型として解釈されるのです。つまり次の例では見た目に反して `PrintArray1` と `PrintArray2` は完全に同一です。

```cpp
#include <iostream>

void PrintArray1(const int x[5]) {
    static_assert(sizeof(x)==sizeof(int*), "");
    for (int i = 0; i < 5; ++i) {
        std::cout << x[i] << std::endl;
    }
}

void PrintArray2(const int* x) {
    for (int i = 0; i < 5; ++i) {
        std::cout << x[i] << std::endl;
    }
}

int main() {
    int x[5] = {0, 1, 2, 3, 4};

    PrintArray1(x);
    PrintArray2(x);

    return 0;
}
```

つまり、関数に配列を渡すというのは配列の先頭要素へのポインタを渡すことになってしまうのです。`int [5]`という型が`int*`になってしまうため、配列の要素数の情報が欠落してしまいます。

そのため、関数に配列を渡す場合は、配列の先頭要素へのポインタと要素数をセットで渡す必要があります。

```cpp
#include <iostream>

void PrintArray(const int* x, std::size_t num) {
    for (std::size_t i = 0; i < num; ++i) {
        std::cout << x[i] << std::endl;
    }
}

int main() {
    constexpr std::size_t num = 5;
    int x[num] = {0, 1, 2, 3, 4};

    PrintArray(x, num);

    return 0;
}
```

??? question "なぜ関数の引数宣言で配列型をつかうとき、ポインタ型として解釈される仕様があるのか"
    そもそもこの仕様はC言語から受け継いだものです。C言語には関数のオーバーロードもtemplateもありません。そんななかで任意の要素数の配列を渡すときこの仕様がないと、想定しうるすべての要素数について関数を定義しなければならなくなります。これはとても面倒なことです。また後に学ぶ動的確保された配列と処理が共通化できなくなります。
    
配列の要素数を求める方法としてC++11より前ではプリプロセッサマクロを使用するのが一般的でしたが、C++11からは次のようにして求めることができます。この関数はC++17以降では `std::size` という関数として標準ライブラリに存在します。

```cpp
#include <cstddef>
template <class T, std::size_t N>
constexpr std::size_t size(const T (&)[N]) noexcept { return N; }

int main() {
    int arr[3];
    static_assert(size(arr) == 3, "");
}
```

## std::array

より高機能な配列を使用したい場合は `std::array` を使用します。ただしC++11では初期化の時に二重に波括弧が必要です。

```cpp
#include <array>

std::array<int, 5> x = {{0, 1, 2, 3, 4}};
//std::array<int, 5> x = {0, 1, 2, 3, 4}; // C++14～
```

`x` は要素数が 5 であるような `int` の配列になります。
`std::array` を使用するには `<array>` のインクルードが必要です。
要素参照は通常の配列と同じようにできます。

```cpp
x[2] = 10;
```

`x.size()` とすると要素数が取得できます。C++17からは `std::size` 関数を用いても要素数を取得できます。

```cpp
auto size = x.size();  // 5
//auto size = std::size(x);  // C++17～
```

配列と要素数を保存した変数の2つを持ち回す必要がでてきたとき、`std::array` を使えばそれらをひとまとめにして扱えるので便利です。

また、配列とは異なり `std::array` は `int` 型などと同じ感覚で扱える特徴があります。例えば配列のコピーを例に上げると単なる代入のような書き方でコピーができます。

```cpp
int arr1_1[3] = {};
//int arr1_2[3] = arr1_1;//NG
std::array<int, 3> arr2_1{};
std::array<int, 3> arr2_2 = arr2_1;//OK
```
