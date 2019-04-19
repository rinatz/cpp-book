# 演算子

算術演算子を中心に、C++ で利用できる演算子を紹介します。
本項で紹介されていない演算子については [式 - cppreference.com][cppreference_expressions] を参照してください。

## 四則演算と剰余

基本的な演算は次の演算子を使うことで可能です。

```cpp
x + y; // 加算
x - y; // 減算
x * y; // 乗算
x / y; // 除算
x % y; // 剰余
```

`0` で除算(剰余)を行うと実行時エラーになるため、注意してください。

!!! failure ""
    ```cpp
    int div = 100 / 0; // 実行時エラー
    int mod = 100 % 0; // 実行時エラー
    ```

<!-- MEMO: 型変換の話はキャスト側でも良いかもしれない -->

<!-- 演算の対象となるいずれかの値が `double` ( `float` )の場合、
他方の値も `double` ( `float` ) として変換された上で演算が行われます。 -->

<!-- ```cpp
int ix = 100;
int iy = 50;
double dx = 100.0;
double dy = 50.0;

auto a = ix / iy; // int = int / int
auto b = ix / dy; // double = double(intから変換) / double
auto c = dx / iy; // double = double / double(intから変換)
auto d = dx / dy; // double = double / double
``` -->

## インクリメント/デクリメント

```cpp
++x; // 前置インクリメント
x++; // 後置インクリメント
--x; // 前置デクリメント
x--; // 後置デクリメント
```

使用するコンパイラにも依りますが、後置インクリメント/デクリメントよりも前置インクリメント/デクリメントのほうが効率が良いとされています。

## ビットの演算

ビットに対する演算は次の演算子を使うことで可能です。

```cpp
~x // 否定
x << y // 左シフト
x >> b // 右シフト
x & y // 論理積
x | y // 論理和
x ^ y // 排他的論理和
```

`std::bitset` を使うことで、ビット列(2進数)での表記が確認できます。

```cpp
#include <bitset>
#include <iostream>

auto bits_a = std::bitset<8>("00001111"); // 15を8ビットで表す: 00001111
std::cout << ~bits_a << std::endl; // 否定: 11110000
std::cout << (bits_a << 2) << std::endl; // 左に2シフト: 00111100
std::cout << (bits_a >> 2) << std::endl; // 右に2シフト: 00000011

auto bits_b = std::bitset<8>("00111100"); // 60を8ビットで表す: 00111100
std::cout << (bits_a & bits_b) << std::endl; // 論理積: 00001100
std::cout << (bits_a | bits_b) << std::endl; // 論理和: 00111111
std::cout << (bits_a ^ bits_b) << std::endl; // 排他的論理和: 00110011
```

数値型でもビット演算は行なえます。
ビットを取り扱う際は、 `unsigned` が付いた符号なし整数型を利用することが望ましいです。

```cpp
unsigned int a = 0x0000000f; // 15
std::cout << std::showbase << std::hex; // 基数のプレフィックスを出力 + 16進法で出力
std::cout << ~a << std::endl; // 0xfffffff0
std::cout << (a << 2) << std::endl; // 0x3c
std::cout << (a >> 2) << std::endl; // 0x3

unsigned int b = 0x0000003c; // 60
std::cout << (a & b) << std::endl; // 0xc
std::cout << (a | b) << std::endl; // 0x3f
std::cout << (a ^ b) << std::endl; // 0x33
```

[cppreference_expressions]: https://ja.cppreference.com/w/cpp/language/expressions