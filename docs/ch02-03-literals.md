# リテラル

ソースコードの中に記述される定数値のことをリテラルといいます。

本項では整数リテラルについて紹介します。他のリテラルについては [式 - cppreference.com][cppreference_expressions] を参照してください。

## 整数リテラル

数字の先頭に特定の文字を加えることで整数の基数を変えることが出来ます。

```cpp
26   // 10進整数リテラル
032  // 先頭に0を付けると8進整数リテラル
0x1a // 先頭に0xを付けると16進整数リテラル
0x1A // 16進整数リテラル内の文字は小文字でも大文字でも区別されないので0x1aと同じ
```

数字の末尾に文字を加えることで次のような型を表現できます。

```cpp
26u    // unsigned型の26
26l    // long型の26
26ul   // unsigned long型の26
0x1Aul // unsigned long型の0x1A
```

[cppreference_expressions]: https://ja.cppreference.com/w/cpp/language/expressions