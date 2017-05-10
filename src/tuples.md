# タプル

タプルは複数の値をひとまとめにして扱うことができる型です。
配列と似た部分がありますが、配列と異なり各要素は同じ型である必要はありません。
タプルを定義するには次のようにします。

```cpp
#include <tuple>

std::tuple<std::string, int> person { "Bob", 20 };
```

`< ... >` の部分に各要素の型を指定します。
要素数はいくつでも増やすことができます。

```cpp
std::tuple<std::string, int, std::string> person { "Bob", 20, "USA" };
```

## 要素参照

配列と同じようにタプルも要素参照を下記のようにすることができます。

```cpp
std::get<0>(person);    // "Bob"
std::get<1>(person);    // 20
```

## 初期化のバリエーション

タプルは初期化方法に幾つかのバリエーションがあります。

```cpp
std::tuple<std::string, int> person { "Bob", 20 };
std::tuple<std::string, int> person("Bob", 20);
std::tuple<std::string, int> person = std::make_tuple("Bob", 20);
```

## tie()

`std::tie()` という関数を使うとタプルの要素を個別の変数に
まとめて代入することができます。

```cpp
std::tuple<std::string, int, std::string> person { "Bob", 20, "USA" };

std::string name;
int age;
std::string country;

std::tie(name, age, country) = person;  // name: "Bob", age: 20, country: "USA"
```
