# 制御文

## if

条件分岐をしたい時には `if` を使用します。

```cpp
int x = 5;

if (x == 5) {
    ...
}
```

`if` の条件を満たさなかった場合に何か処理をしたければ `else` を使用します。

```cpp
int x = 5;

if (x == 5) {
    ...
} else {
    ...
}
```

さらに別の条件で処理を分岐したければ `else if` を使用します。

```cpp
int x = 5;

if (x == 5) {
    ...
} else if (x == 6) {
    ...
} else {
    ...
}
```

## switch

一つの変数の値を調べながら分岐するような処理を書きたい場合は `switch` 文を使います。

```cpp
switch (x) {
    case 0:
        // x == 0 のときの処理
        break;
    case 1:
        // x == 1 のときの処理
        break;
    default:
        // x がそれ以外のときの処理
        break;
}
```

ただし `switch` 文が使用できるのは基本型のみです。
上記の構文は `if` で書き直すと次と等価になります。

```cpp
if (x == 0) {
    // x == 0 のときの処理
} else if (x == 1) {
    // x == 1 のときの処理
} else {
    // x がそれ以外のときの処理
}
```

ただし `switch` 文のほうが `if` よりも比較回数が少ないため効率的です。
`if` はまずはじめに `x == 0` が `true` かどうかを調べ `false` であれば
次に `x == 1` を評価しますが、`switch` 文はいきなり特定の `case` にジャンプします。

### フォールスルー

`switch` の各 `case` 内に書かれている `break` は書かなくてもよいのですが、
その場合振る舞いが変わります。

```cpp
switch (x) {
    case 0:
        // x == 0 のときの処理
    case 1:
        // x == 1 のときの処理
    default:
        // x がそれ以外のときの処理
}
```

`break` を書いた場合は `switch` 文の処理はそこで終わりますが、
`break` を書かなかった場合はそのまま下の `case` に処理が流れてしまいます。
つまり上記のコードは `x == 0` であれば `case 0` 内の処理を行った後に
`case 1` 内の処理を行い、最後に `default` の処理を行います。
`x == 1` であれば同様の振る舞いが `case 1` から始まります。
このような `switch` 文の仕様をフォールスルーと言います。
これは `case 0` と `case 1` の処理が同じものになる場合に使用すると便利です。

```cpp
switch (x) {
    case 0:
    case 1:
        // x == 0 または x == 1 のときの処理
    default:
        // x がそれ以外のときの処理
}
```

それ以外のケースでフォールスルーをさせるシーンはまずないため、
`break` を忘れずに付けておく必要があります。

## while

`while` は `()` に渡された条件が `true` である限り
`{ ... }` 内の処理を実行し続けます。

```cpp
int x = 5;
bool done = false;

while (!done) {
    x += x - 3;

    std::cout << x << std::endl;

    if (x % 5 == 0) {
        done = true;
    }
}
```

### do-while

最初の1回は無条件で `do { ... }` 内の処理を実行し、
2回目以降は `while ()` に渡された条件が `true` である限り
`do { ... }` 内の処理を実行し続けます。

```cpp
int x = 5;
bool done = false;

do {
    x += x - 3;

    std::cout << x << std::endl;

    if (x % 5 == 0) {
        done = true;
    }
} while (!done);
```

## for

`for` はループするたびに変化する変数を使うことができます。

```cpp
for (int i = 0; i < 10; ++i) {
    std::cout << i << std::endl;
}
```

`i` はループするたびに `0, 1, 2, ..., 9` と値が変化し続けます。
`for (int i = 0; i < 10; ++i)` というのは `i` に `0` を設定して
`i < 10` を満たすまで `i` を `+1` しながらループを継続するという意味になります。

`for` はこの書き方以外に `範囲 for` という書き方もあります。
詳細は [3.9. 範囲 for][range-based-for] を参照してください。

[range-based-for]: ch03-09-range-based-for.md

## ループ処理の中断

ループ文 `while`、 `do-while`、 `for` のループ処理は
`break` または `continue` で中断することができます。

### break

現在のループ処理を中断してループ文を終了します。

```cpp
int x = 5;

while (true) {
    x += x - 3;

    std::cout << x << std::endl;

    if (x % 5 == 0) {
        break;  // while 文を抜ける
    }
}
```

ループ文がネストしている場合には、最も内側にある文のみが対象になります。

```cpp
for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
        if (i == j) {
            break;  // j のループ文を抜ける
        }

        std::cout << i << "," << j << std::endl;
    }
}
```

### continue

現在のループ処理を中断して、次のループ処理を行います。

```cpp
for (int i = 0; i < 10; ++i) {
    if (i == 5) {
        continue;  // 5 だけスキップ
    }

    std::cout << i << std::endl;
}
```

ループ文がネストしている場合には、最も内側にある文のみが対象になります。

```cpp
for (int i = 0; i < 3; ++i) {
    for (int j = 0; j < 3; ++j) {
        if (i == j) {
            continue;  // j のループ処理をスキップ
        }

        std::cout << i << "," << j << std::endl;
    }
}
```

`contiune` では次のループ処理を行うため、
`do-while` では先頭に戻るのではなく末尾へ移動する動作となります。

```cpp
do {
    std::cout << "done" << std::endl;
    continue;  // ループ処理をスキップ (先頭に戻る動作なら無限ループとなる)

    std::cout << "never reached" << std::endl;  // 実行されない
} while (false);  // 条件が false であるため1回目で終了
```
