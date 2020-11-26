# マップ

配列では要素参照のために何番目の要素と指定しますが、
`std::map` または `std::unorderd_map` という型を使用すると
何番目という指定の代わりに任意の型をキーとして指定できます。

この機能は連想配列や辞書とも呼ばれます。

```cpp
#include <map>

std::map<std::string, int> persons = {
    {"Alice", 18},
    {"Bob", 20}
};
```

```cpp
#include <unordered_map>

std::unordered_map<std::string, int> persons = {
    {"Alice", 18},
    {"Bob", 20}
};
```

要素参照は次のようにします。

```cpp
persons["Alice"];  // 18
persons["Bob"];    // 20
```

## 要素追加

`insert()` で要素を追加することができます。

```cpp
persons.insert({"Eve", 19});
```

## 要素削除

`erase()` で要素を削除することができます。

```cpp
persons.erase("Bob");
```

## `std::map` と `std::unordered_map` の違い

`std::map` はキーでソートしてデータを管理するのに対し、
`std::unordered_map` はキーから計算するハッシュと呼ばれる値でデータを管理します。

キーの順番を保持したい場合を除いて、パフォーマンスは常に `std::unordered_map` の方が優れています。
