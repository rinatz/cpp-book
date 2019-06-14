# メンバ変数

クラスとは変数と関数を集約した型をつくるための仕組みです。

クラスが持つ変数をメンバ変数といいます。

長方形を扱う `Rectangle` クラスに
`int` 型のメンバ変数 `height` と `width` を持たせるには次のようにします。

```cpp
class Rectangle {
 public:
    int height_;
    int width_;
};
```

メンバ変数を参照するには `.` を使用します。

```cpp
Rectangle r;
r.height_ = 10;
r.width_ = 20;
```

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
