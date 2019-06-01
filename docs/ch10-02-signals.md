# シグナル

シグナルとはプログラム実行中に外部から要求を通知する仕組みです。
OS からのエラー通知などで使用されます。

`<csignal>` で定義されるシグナルには以下の6種類があります。

## SIGSEGV

無効なメモリアクセス (セグメンテーション違反) を行うと発生します。

```cpp
int* x = nullptr;

// nullptr に対するデリファレンスで SIGSEGV が発生
std::cout << *x << std::endl;
```

## SIGFPE

整数の0除算など不正な算術演算を行うと発生します。

```cpp
int x = 2;
int y = 0;
int z = x / y;  // 整数の0除算
```

!!! note "浮動小数点数に対する算術演算エラー"
    多くの処理系では浮動小数点数の規格として [IEEE 754] が使用されており、
    以下を値として使用することができます。

    * 非数 `NaN`
    * 符号付ゼロ ($+0$ と $-0$)
    * 無限大 ($+\infty$ と $-\infty$)

    こうした処理系では浮動小数点数の演算結果でこれらの値を使用し、
    浮動小数点数のシグナルを発生させないようにしている場合が多いです。

[IEEE 754]: https://ja.wikipedia.org/wiki/IEEE_754

<!-- MEMO: シグナルが発生しない場合でも <cfenv> を利用することで検知可能
https://ja.cppreference.com/w/cpp/numeric/fenv
-->

## SIGABRT

[std::abort][cpprefjp_abort] の呼び出しによって発生します。

[std::abort][cpprefjp_abort] は
[std::terminate][cpprefjp_terminate] などから呼び出されます。

```cpp
#include <exception>

int main() {
    // 例外が捕捉されないため std::terminate が呼び出される
    throw std::exception();

    return 0;
}
```

[cpprefjp_abort]: https://cpprefjp.github.io/reference/cstdlib/abort.html
[cpprefjp_terminate]: https://cpprefjp.github.io/reference/exception/terminate.html

<!-- TODO: 以下を追加
SIGTERM
SIGINT
SIGILL
-->
