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

`x.emplace_back()` とすると末尾へ要素を追加することができます。

```cpp
#include <vector>

std::vector<int> x = {0, 1, 2, 3, 4};
auto size1 = x.size();  // 5

x.emplace_back(5);
auto size2 = x.size();  // 6
```

!!! question "emplace_backとpush_back"
    C++11 より前は push_back という関数のみが末尾への要素追加を担っていました。
    C++11 で追加された emplace_back は要素型のコンストラクタに
    直接引数を渡すことができるので push_back と同じか
    それ以上のパフォーマンスを得られるケースがあります。
    両者の最適な使い分けは高度なトピックとなるため、
    詳細は [書籍 Effective Modern C++](https://www.oreilly.co.jp/books/9784873117362/) で紹介される
    「項目42：要素の挿入の代わりに直接配置を検討する」を参照ください。

## 末尾から要素削除

`x.pop_back()` とすると末尾から要素を削除することができます。

```cpp
#include <vector>

std::vector<int> x = {0, 1, 2, 3, 4};
auto size1 = x.size();  // 5

x.pop_back();
auto size2 = x.size();  // 4
```

## 配列の先頭ポインタを取得

`x.data()` とすると配列の先頭ポインタが取得できます。

```cpp
#include <vector>

std::vector<int> x = {4, 3, 2, 1, 0};
auto px = x.data();  // 先頭ポインタ
auto num = *px;  // 4
```

## bool に対する特殊化

`std::vector` は `bool` に対してテンプレート特殊化されており、
`std::vector<bool>` は `bool` 以外の `std::vector` とは動作が異なります。

詳細は [vector - cpprefjp C++日本語リファレンス][cpprefjp_vector] を参照してください。

[cpprefjp_vector]: https://cpprefjp.github.io/reference/vector/vector.html
