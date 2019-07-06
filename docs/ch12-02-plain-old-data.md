# POD

POD (Plain Old Data) とは C とABI互換性が保証されるデータ構造のことです。

データ構造が POD であるかは `std::is_pod` で判定することができます。
`std::is_pod` を使用するには `<type_traits>` のインクルードが必要です。
データ構造が POD であることが必要な場合には `static_assert` で保証するとよいです。

```cpp
#include <type_traits>
struct FundamentalTypes {
    int16_t i;
    double d;
};
static_assert(std::is_pod<FundamentalTypes>::value, "Should be POD.");
```

## バイト列操作

POD であれば以下の関数でデータを扱うことができます。
使用するには `<cstring>` のインクルードが必要です。

- `std::memset`
- `std::memcpy`
- `std::memcmp`

これらは C の関数であるため、
任意の型を扱うために [void ポインタ][void-pointer] が使用されます。

[void-pointer]: appendix-void-pointer.md

<!-- std::memset -->
<!-- std::memcpy -->
<!-- std::memcmp -->
