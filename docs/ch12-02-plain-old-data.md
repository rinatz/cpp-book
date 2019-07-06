# POD

POD (Plain Old Data) とは C とABI互換性が保証されるデータ構造のことです。

データ構造が POD であるかは [std::is_pod][cpprefjp_is_pod] で判定することができます。
`std::is_pod` を使用するには `<type_traits>` のインクルードが必要です。
データ構造を POD にしたい場合には `static_assert` で保証するとよいです。

[cpprefjp_is_pod]: https://cpprefjp.github.io/reference/type_traits/is_pod.html

```cpp
#include <type_traits>
struct FundamentalTypes {
    int16_t i;
    double d;
};
static_assert(std::is_pod<FundamentalTypes>::value, "Should be POD.");
```

## 基本型

基本形は POD です。

```cpp
enum Direction {
    kLeft,
    kRight,
    kBoth
};

static_assert(std::is_pod<char>::value, "Should be POD.");
static_assert(std::is_pod<int32_t>::value, "Should be POD.");
static_assert(std::is_pod<double>::value, "Should be POD.");
static_assert(std::is_pod<Direction>::value, "Should be POD.");
```

## 配列

POD の配列は POD です。

```cpp
static_assert(std::is_pod<int[2]>::value, "Should be POD.");
```

POD の `std::array` も POD ですが、
POD の `std::vector` は POD ではありません。

```cpp hl_lines="2"
static_assert(std::is_pod<std::array<int, 2>>::value, "Should be POD.");
static_assert(std::is_pod<std::vector<int>>::value, "Should be POD.");  // failed
```

## 参照型

参照型は POD ではありません。

```cpp hl_lines="1"
static_assert(std::is_pod<int&>::value, "Should be POD.");  // failed
```

## ポインタ型

あらゆるポインタは POD です。
POD ではない型に対するポインタも POD です。

```cpp
static_assert(std::is_pod<int*>::value, "Should be POD.");

// std::vector<int> は POD ではないが std::vector<int>* は POD
static_assert(std::is_pod<std::vector<int>*>::value, "Should be POD.");
```

## 構造体

構造体の条件は複雑なため、本書では簡単な例だけを紹介します。

??? question "POD の要件"
    トリビアルかつスタンダードレイアウトである場合に POD となります。
    詳細は以下を参照してください。

    - [is_trivial - cpprefjp C++日本語リファレンス][cpprefjp_is_trivial]
    - [is_standard_layout - cpprefjp C++日本語リファレンス][cpprefjp_is_standard_layout]

[cpprefjp_is_trivial]: https://cpprefjp.github.io/reference/type_traits/is_trivial.html
[cpprefjp_is_standard_layout]: https://cpprefjp.github.io/reference/type_traits/is_standard_layout.html

### POD になる構造体の例

以下の条件をすべて満たす構造体は POD です。

- 継承していない
- メンバ関数を持たない (暗黙的に定義される特別なメンバ関数は明示しない)
- すべてのメンバ変数は POD
- メンバ変数に対するアクセス指定子は暗黙的な `public` だけを使用する

```cpp
// メンバ変数を持たない
struct Empty {};
static_assert(std::is_pod<Empty>::value, "Should be POD.");

// すべてのメンバ変数が基本形
struct FundamentalTypes {
    int16_t i;
    double d;
};
static_assert(std::is_pod<FundamentalTypes>::value, "Should be POD.");
```

POD の構造体は入れ子にすることができます。

```cpp
// POD の構造体 FundamentalTypes をメンバ変数にもつ
struct FundamentalTypesAsChild {
    char c;
    FundamentalTypes f;
};
static_assert(std::is_pod<FundamentalTypesAsChild>::value, "Should be POD.");

// POD の構造体 FundamentalTypesAsChild をメンバ変数にもつ
struct FundamentalTypesAsGrandchild {
    char c;
    FundamentalTypesAsChild f;
};
static_assert(std::is_pod<FundamentalTypesAsGrandchild>::value,
              "Should be POD.");
```

### POD にならない構造体の例

<!-- MEMO: 多重継承や仮想継承に関連するものは言及していない -->

#### 暗黙的に定義される特別なメンバ関数をユーザ定義

ユーザ定義のデフォルトコンストラクタをもつ構造体は POD ではありません。

```cpp hl_lines="4 5"
struct UserDefinedDefaultConstructor {
    UserDefinedDefaultConstructor() {}
};
static_assert(std::is_pod<UserDefinedDefaultConstructor>::value,
              "Should be POD.");  // failed
```

`default` 指定であれば POD になります。

```cpp
struct DefaultConstructorAsExplicitDefault {
    DefaultConstructorAsExplicitDefault() = default;
};

static_assert(std::is_pod<DefaultConstructorAsExplicitDefault>::value,
              "Should be POD.");
```

デフォルトコンストラクタ以外の
暗黙的に定義される特別なメンバ関数についても同様です。

#### 仮想関数

仮想関数をもつ構造体は POD ではありません。

```cpp hl_lines="4"
struct VirtualFunction {
    virtual void Hoge() {}
};
static_assert(std::is_pod<VirtualFunction>::value, "Should be POD.");  // failed
```

#### 非 POD のメンバ変数

`static` ではないメンバ変数に POD ではない型がある構造体は POD ではありません。

```cpp hl_lines="4"
struct NonPodMemberVariable {
    std::vector<int> v;  // std::vector<int> は POD ではない
};
static_assert(std::is_pod<NonPodMemberVariable>::value, "Should be POD.");  // failed
```

#### メンバ変数に対するアクセス指定子が2種類以上

暗黙的なものを含めて、
メンバ変数に対するアクセス指定子が2種類以上ある構造体は POD ではありません。

```cpp hl_lines="7"
struct MultipleAccessSpecifierTypes {
    int public_variable;

 private:
    int private_variable;
};
static_assert(std::is_pod<MultipleAccessSpecifierTypes>::value, "Should be POD.");  // failed
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
仕様は [std::memset - cppreference.com][cppreference_memset] を参照してください。

[cppreference_memset]: https://ja.cppreference.com/w/cpp/string/byte/memset

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

### std::memcpy

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

### std::memcmp

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
