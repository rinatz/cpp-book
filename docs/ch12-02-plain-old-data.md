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

## クラス

C++ における構造体とクラスの違いはデフォルトのアクセス指定子だけなので、
構造体と同じ条件でクラスも POD になります。

```cpp
class FundamentalTypes {
 public:
    int16_t i;
    double d;
};
static_assert(std::is_pod<FundamentalTypes>::value, "Should be POD.");
```
