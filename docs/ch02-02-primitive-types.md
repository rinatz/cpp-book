# 基本型

C++ ではじめから使用できる基本型について説明します。

## bool

`bool` は真偽値を表す型で `true` または `false` が設定できます。

```cpp
bool ok = true;
```

## char

`char` はアスキー文字1文字を表現する型です。
ただし内部表現はアスキーコードの整数値として扱われ、
標準出力などに出力する際に文字に変換されて出力されます。

```cpp
char x = 'x';
```

## 数値

数値を表現する型は複数種類用意されています。

### 整数型

整数を表現するための型です。

* `char`
* `short`
* `int`
* `long`

下に行くに連れて大きな値が表現できるようになり、変数のサイズも増大します。
具体的なサイズはコンパイラによって変わってきますが
GCC では 8, 16, 32, 64 ビットで定義されています。
一般的には `int` が使用されます。

### 符号付き・符号なし整数型

各整数型に `unsigned` を付けると正の数しか表現できなくなる代わりに
大きな値が表現できるようになります。

```cpp
unsigned int x = 4000000000;
```

`signed` を付けると正負両方の値が表現できます。
明示的に付けなくてもデフォルトは `signed` になります。

### サイズ指定付き整数型

上述の整数型は型のサイズがコンパイラによってまちまちなので
複数のコンパイラに対応するプログラムを書くときは
移植性の面で問題が発生することがあります。
そのようなときはサイズ指定付き整数型を使用します。

* `int8_t`
* `int16_t`
* `int32_t`
* `int64_t`
* `uint8_t`
* `uint16_t`
* `uint32_t`
* `uint64_t`

数値は型のビットサイズを表しており、u は `unsigned` を表しています。
サイズ指定付き整数型を使用する場合は `#include <cstdint>` と記述する必要があります。

```cpp
#include <cstdint>

int32_t x = 5;
```

### 浮動小数点型

小数を表現する型は次の2つの型があります。

* `float`
* `double`

`float` は 32 ビットの大きさを持ち、`double` は 64 ビットの大きさを持ちます。
また `double` の方が `float` に比べて計算精度が高いですが数値計算の
パフォーマンスは低いです。

## 列挙型

列挙型は、名前を付けた定数（列挙子）の集合を扱う型です。

### enum

列挙型である `enum` を定義するには次のようにします。

```cpp
enum Day {
  Sun,  // 0
  Mon,  // 1
  Tue,  // 2
  Wed,  // 3
  Thu,  // 4
  Fri,  // 5
  Sat   // 6
};
```

`enum` の各列挙子は、内部では整数として扱われています。
各列挙子の定義の際に値を指定しなければ、 `0` から順に値が割り振られます。

`列挙子 = 整数` と書くことで値を指定することができます。値が指定された列挙子以降は、順に整数が割り振られます。

```cpp
enum Day {
  Sun = 1,  // 1
  Mon,      // 2
  Tue,      // 3
  Wed = 8,  // 8
  Thu,      // 9
  Fri,      // 10
  Sat       // 11
};
```

`enum` を扱うには次のようにします。

```cpp
Day day = Fri;
```

数値型に `enum` の値を代入することは可能ですが、 `enum` に数値を直接代入することは出来ません。

```cpp
int x = Fri;  // OK
Day day = 5;  // コンパイルエラー
```

列挙子の名前は被らないようにする必要があります。

```cpp
enum Day {
  Sun,
  Mon,
  Tue,
  Wed,
  Thu,
  Fri,
  Sat
};

enum SolarSystem {
  Sun,  // Sun は enum Day 内で定義済みのためコンパイルエラー
  Mercury,
  Venus,
  Earth,
  Mars,
  Jupiter,
  Saturn,
  Uranus,
  Neptune
};
```

### enum class

`enum class` で列挙型を定義することもできます。

```cpp
enum class Day {
  Sun,
  Mon,
  Tue,
  Wed,
  Thu,
  Fri,
  Sat
};
```

基本的には `enum` と同じですが、以下の点が異なります。

`enum class` を扱うには `型名::列挙子名` とします。

```cpp
Day day = Day::Fri;  // OK
Day day = Fri;       // コンパイルエラー
```

明示的に型変換をしない限り、数値型に `enum class` の値の代入はできません。

```cpp
int x = Day::Fri;  // コンパイルエラー
```

!!! tip "明示的な型変換"
    [明示的に型変換][cpp-casts] を行うことで、数値型などに `enum class` の値の代入が可能です。

    ```cpp
    int x = static_cast<int>(Day::Fri);
    ```

[cpp-casts]: ch08-01-cpp-casts.md

`enum class` の場合、列挙子の名前はその型ごとに紐づくため、
他の列挙型の列挙子と名前が被っても問題ありません。

```cpp
enum class Day {
  Sun,  // Day::Sun
  Mon,
  Tue,
  Wed,
  Thu,
  Fri,
  Sat
};

enum class SolarSystem {
  Sun,  // Day::Sun と SolarSystem::Sun は区別されるためOK
  Mercury,
  Venus,
  Earth,
  Mars,
  Jupiter,
  Saturn,
  Uranus,
  Neptune
};
```