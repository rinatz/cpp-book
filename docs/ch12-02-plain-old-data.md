# POD

POD (Plain Old Data) とは C とABI互換性が保証されるデータ構造のことです。

データ構造が POD であるかは `std::is_pod` で判定することができます。
`std::is_pod` を使用するには `<type_traits>` のインクルードが必要です。
データ構造を POD にしたい場合には `static_assert` で保証するとよいです。

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

### std::memset

バイト列に指定した値をセットします。

```cpp
void* memset(void* s, int c, size_t n);
```

- 第1引数 `s` はバイト列の先頭を表すポインタ
- 第2引数 `c` はバイト単位にセットする値 (内部で `unsigned char` にキャストされます)
- 第3引数 `n` はバイト列の先頭から何バイトセットするか
- 戻り値は `s` を返却

```cpp
static_assert(CHAR_BIT == 8, "Not support 1byte != 8bits");

FundamentalTypes f;

// すべてのビットを0にする
std::memset(&f, 0, sizeof(f));
std::cout << f.i << std::endl;  // 0
std::cout << f.d << std::endl;  // 0

// すべてのビットを1にする
std::memset(&f, 0xff, sizeof(f));
std::cout << f.i << std::endl;  // -1   (2の補数表現の場合)
std::cout << f.d << std::endl;  // -nan (IEEE 754 の場合)
```

<!-- std::memcpy -->
<!-- std::memcmp -->
