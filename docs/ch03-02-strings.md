# 文字列

文字列を扱うには `std::string` という型を使用します。

```cpp
#include <string>

std::string s = "Hello";
```

`std::string` は文字列データを `char` の配列として扱うため
配列のように操作することができます。

```cpp
std::string s = "Hello";

s[0];   // 'H'
s[1];   // 'e'
s[2];   // 'l'
s[3];   // 'l'
s[4];   // 'o'
```

`s.size()` とすると文字列数を取得できます。

```cpp
s.size();   // 5
```

!!! info
    `std::string` はバイト列を保持しており `s.size()` が返す値はバイト数です。マルチバイト文字を保持する場合、`s.size()` が返す値は文字列数と一致しません。