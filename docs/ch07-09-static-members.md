# static メンバ

## static メンバ変数

クラスのオブジェクトごとではなく、クラスそのものがもつ変数です。

!!! warning "初期化と破棄のタイミング"
    static メンバ変数の初期化/破棄はプログラムの開始/終了時にまとめて行われますが、
    実行順序を制御することができません。

    誤った扱いをすると原因特定が難しいエラーが発生しやすい機能であり、使用には注意が必要です。

メンバ変数の宣言に `static` をつけることで `static` メンバ変数を宣言することができます。

```cpp
class Counter {
 public:
    static int count_;
};
```

static メンバ変数はクラスの外で実体を定義する必要があります。

```cpp
int Counter::count_ = 10;  // 値 10 で初期化
```

ヘッダファイルが2つ以上のファイルでインクルードされる場合、
ヘッダファイルで実体の定義を行うと多重定義となりリンクエラーになってしまいます。
この問題を避けるために static メンバ変数の実体の定義はソースファイルで行います。

```cpp tab="counter.cc"
#include "counter.h"

int Counter::count_ = 10;
```

```cpp tab="counter.h"
#ifndef COUNTER_H_
#define COUNTER_H_

class Counter {
 public:
    static int count_;
};

#endif  // COUNTER_H_
```

static メンバ変数を参照するには `Counter::count_` のようにします。

```cpp
#include <iostream>

#include "counter.h"

int main() {
    ++Counter::count_;
    std::cout << Counter::count_ << std::endl;  // 11
    return 0;
}
```

## static メンバ関数

クラスのオブジェクトごとではなく、クラスそのものがもつ関数です。

メンバ関数の宣言に static をつけることで static メンバ関数を宣言することができます。

```cpp
class Brightness {
 public:
    explicit Brightness(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

    static Brightness Maximum();
    static Brightness Minimum();
    static Brightness Median();

 private:
    int value_;
};
```

static メンバ関数は static メンバ変数以外のメンバ変数は直接参照できないため、
static メンバ関数ではなく通常の関数で十分なことが多いです。

通常の関数との違いは static メンバ関数はクラスに属するため、
`protected` や `private` のメンバにもアクセスできることです。

```cpp
Brightness Brightness::Maximum() {
    return Brightness(100);
}

Brightness Brightness::Minimum() {
    return Brightness(0);
}

Brightness Brightness::Median() {
    return Brightness((Maximum().value_ + Minimum().value_) / 2);
}
```

static メンバ関数は実行順序が定まるため、
static メンバ変数の代わりに static メンバ関数を使用することで
初期化順序を制御できない問題を回避することができます。
