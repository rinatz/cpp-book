# ベクタ

要素数を実行時に変更できる配列を扱うには `std::vector` を使用します。

```cpp
#include <vector>

std::vector<int> x = {0, 1, 2, 3, 4};
```

`x` は要素数が 5 であるような `int` の配列になります。
`std::vector` を使用するには `<vector>` のインクルードが必要です。
要素参照は通常の配列と同じようにできます。

```cpp
x[2] = 10;
```

`x.size()` とすると要素数が取得できます。

```cpp
auto size = x.size();  // 5
```

## 末尾へ要素追加

`x.push_back()` とすると末尾へ要素を追加することができます。

```cpp
#include <vector>

std::vector<int> x = {0, 1, 2, 3, 4};
auto size1 = x.size();  // 5

x.push_back(5);
auto size2 = x.size();  // 6
```

## 末尾から要素削除

`x.pop_back()` とすると末尾から要素を削除することができます。

```cpp
#include <vector>

std::vector<int> x = {0, 1, 2, 3, 4};
auto size1 = x.size();  // 5

x.pop_back();
auto size2 = x.size();  // 4
```

## bool に対する特殊化

`std::vector` は `bool` に対してテンプレート特殊化されており、
`std::vector<bool>` は `bool` 以外の `std::vector` とは動作が異なります。

詳細は [vector - cpprefjp C++日本語リファレンス][cpprefjp_vector] を参照してください。

[cpprefjp_vector]: https://cpprefjp.github.io/reference/vector/vector.html
