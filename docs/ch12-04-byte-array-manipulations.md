# バイト列操作

POD であれば以下の関数でデータを扱うことができます。
使用するには `<cstring>` のインクルードが必要です。

- `std::memset`
- `std::memcpy`
- `std::memcmp`

これらは C の関数であるため、
任意の型を扱うために [void ポインタ][void-pointer] が使用されます。

[void-pointer]: appendix-void-pointer.md

次のコードで説明します。

```cpp
static_assert(CHAR_BIT == 8, "Not support 1byte != 8bits");

struct FundamentalTypes {
    int16_t i;
    double d;
};
```

## std::memset

バイト列に指定した値をセットします。
仕様は [std::memset - cppreference.com][cppreference_memset] を参照してください。

[cppreference_memset]: https://ja.cppreference.com/w/cpp/string/byte/memset

```cpp
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

<!-- MEMO: C++11 の言語仕様では1の補数表現が許容されているため注釈を入れている -->

## std::memcpy

バイト列をコピーします。
仕様は [memcpy, memcpy_s - cppreference.com][cppreference_memcpy] を参照してください。

[cppreference_memcpy]: https://ja.cppreference.com/w/c/string/byte/memcpy

```cpp
FundamentalTypes f1;
f1.i = -2;
f1.d = 2.71;

FundamentalTypes f2;

// f1 から f2 へバイト列をコピー
std::memcpy(&f2, &f1, sizeof(FundamentalTypes));

std::cout << f2.i << std::endl;  // -2
std::cout << f2.d << std::endl;  // 2.71
```

## std::memcmp

バイト列を比較します。
仕様は [std::memcmp - cppreference.com][cppreference_memcmp] を参照してください。

[cppreference_memcmp]: https://ja.cppreference.com/w/cpp/string/byte/memcmp

```cpp
FundamentalTypes f1;
f1.i = -2;
f1.d = 2.71;

FundamentalTypes f2;
f2.i = 3 - 5;
f2.d = 2.71;

FundamentalTypes f3;
std::memset(&f3, 0, sizeof(f3));

if (std::memcmp(&f1, &f2, sizeof(FundamentalTypes)) == 0) {
    std::cout << "f1 and f2 are same" << std::endl;
} else {
    std::cout << "f1 and f2 are different" << std::endl;
}

if (std::memcmp(&f1, &f3, sizeof(FundamentalTypes)) == 0) {
    std::cout << "f1 and f3 are same" << std::endl;
} else {
    std::cout << "f1 and f3 are different" << std::endl;
}
```

実行結果は次のようになります。

```
f1 and f2 are same
f1 and f3 are different
```
