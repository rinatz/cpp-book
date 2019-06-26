# 内部リンケージ

宣言された同名のシンボルを同一のものとして扱うかどうかを示す概念のことをリンケージと言います。

ここでは、内部リンケージについて紹介します。
内部リンケージを持つシンボルは宣言されたファイル内でのみ参照できるようになります。

<!-- MEMO: ここで言うファイルとは厳密にはプリプロセス後の翻訳単位である -->

## static

シンボルの宣言に `static` 指定子を付与することで内部リンケージを持たせることが出来ます。

```cpp tab="main.cc"
#include <iostream>

int main() {
    std::cout << x << std::endl;  // リンクエラー。main.cc からは other.cc の x が参照できない。

    return 0;
}
```

```cpp tab="other.cc"
static int x = 246;  // 内部リンケージ。 other.cc 内でのみ参照可能
```

## 無名名前空間

`namespace 名前 {}` で名前空間を定義することが出来ますが、
名前を付けずに `namespace {}` とすることで無名名前空間を定義することが出来ます。

無名名前空間内に宣言された変数や関数は、 `static` 指定子と同様に内部リンケージを持ちます。

```cpp tab="main.cc"
#include <iostream>

#include "other.h"

int main() {
    Print();

    std::cout << x << std::endl;  // ここから x は参照できない
}
```

```cpp tab="other.h"
#ifndef OTHER_H_
#define OTHER_H_

void Print();

#endif  // OTHER_H_
```

```cpp tab="other.cc" hl_lines="5 6 7"
#include "other.h"

#include <iostream>

namespace {
    int x = 50;  // x に内部リンケージを持たせる
}  // unnamed namespace

void Print() {
    std::cout << x << std::endl;  // ここから x は参照可能
}
```

C++ において `static` は [様々な意味を持つ][cppreference-static] ため、分かりづらいキーワードとなっています。
宣言に内部リンケージを持たせる場合は、 `static` ではなく無名名前空間を使うようにしましょう。

[cppreference-static]: https://ja.cppreference.com/w/cpp/keyword/static

## 内部リンケージと定義重複

ソースファイル間で定義が重複している時、通常は定義の重複によるエラーになりますが、
各々の内部リンケージを持たせて別のファイルから見えなくしていれば、別の定義として扱うことができます。

```cpp tab="main.cc" hl_lines="6"
#include <iostream>

#include "other.h"

namespace {
    int hoge = 0;  // main.cc 内の hoge
}

int main()
{
    hoge += 2;

    IncrementHoge();

    std::cout << "main.cc: " << hoge << std::endl;  // main.cc: 2

    PrintHoge();

    return 0;
}
```

```cpp tab="other.h"
#ifndef OTHER_H_
#define OTHER_H_

void IncrementHoge();
void PrintHoge();

#endif  // OTHER_H_
```

```cpp tab="other.cc" hl_lines="6"
#include "other.h"

#include <iostream>

namespace {
    int hoge = 0;  // other.cc 内の hoge
}

void IncrementHoge() {
    ++hoge;
}

void PrintHoge() {
    std::cout << "other.cc: " << hoge << std::endl;  // other.cc: 1
}
```