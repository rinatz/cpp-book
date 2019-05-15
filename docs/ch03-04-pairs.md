# ペア

ペアは2つの値をひとまとめにして扱うことができる型です。
要素数が2つのタプルと同じように扱うことができます。
ペアを定義するには次のようにします。

```cpp
#include <utility>

std::pair<std::string, int> person {"Bob", 20};
```

## 要素参照

タプルと同様に要素参照を下記のようにすることができます。

```cpp
std::get<0>(person);    // "Bob"
std::get<1>(person);    // 20
```

ペアでは0番目の要素を `first`、 1番目の要素を `second` で参照することができます。

```cpp
person.first;     // "Bob"
person.second;    // 20
```

## 初期化のバリエーション

タプルと同様に初期化方法に幾つかのバリエーションがあります。

```cpp
std::pair<std::string, int> person { "Bob", 20 };
std::pair<std::string, int> person("Bob", 20);
std::pair<std::string, int> person = std::make_pair("Bob", 20);
```

## `std::tie()`

`std::tie()` を使うとペアの要素を個別の変数にまとめて代入することができます。
`std::tie()` を使うには `<tuple>` のインクルードが必要です。

```cpp
#include <tuple>

std::pair<std::string, int> person { "Bob", 20 };

std::string name;
int age;

std::tie(name, age) = person;  // name: "Bob", age: 20
```
