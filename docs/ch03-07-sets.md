# セット

`std::set` または `std::unordered_set` という型を使用すると
任意の型の集合を扱うことができます。

```cpp
#include <set>

std::set<std::string> persons = {
    "Alice",
    "Bob"
};
```

```cpp
#include <unordered_set>

std::unordered_set<std::string> persons = {
    "Alice",
    "Bob"
};
```

## 要素追加

`insert()` で要素を追加することができます。

```cpp
persons.insert("Eve");
```

## 要素削除

`erase()` で要素を削除することができます。

```cpp
persons.erase("Bob");
```

## std::set と std::unordered_set の違い

`std::set` はキーでソートしてデータを管理するのに対し、
`std::unordered_set` はキーから計算するハッシュと呼ばれる値でデータを管理します。

キーの順番を保持したい場合を除いて、パフォーマンスは常に `std::unordered_set` の方が優れています。
