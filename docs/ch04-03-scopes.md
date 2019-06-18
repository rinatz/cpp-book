# スコープ

<!-- MEMO: ここでは単一のプログラム内でのシンボル解決の話に留める -->

プログラムは、特定の範囲毎に変数の名前（シンボル）を識別しています。
この範囲のことを スコープ と言います。
同一のスコープ内に同名の変数が存在した場合、シンボルを一意に識別する事ができない（シンボル重複）のでリンク時にエラーになります。

また、スコープを決める範囲のことを ブロック と言います。 `{}` で括られた範囲が一つのブロックになります。

!!! tip "名前修飾（名前マングリング）"
    C++ では同一のスコープ内に同名の関数があっても、引数や戻り値の型が異なれば宣言することが可能です。（関数のオーバーロード）

    これは、シンボルに引数や戻り値の型の情報なども含める [名前修飾（名前マングリング）][name-mangling] を行なった上で関数を一意に識別することで実現しています。

[name-mangling]: https://ja.wikipedia.org/wiki/名前修飾

## 名前空間スコープ

`namespace 名前 {}` で名前空間の定義をすることが出来ます。
`namespace` ブロックで括られたシンボルは、その名前空間に属することになります。

```cpp
namespace A {
    int count = 2;  // 名前空間 A に属する変数
}  // namespace A

namespace B {
    int count = 4;  // 名前空間 B に属する変数。名前空間 A とは別スコープなのでエラーにはならない。
}  // namespace B
```

スコープ解決演算子 `::` を付けることで、名前空間内のシンボルを利用する事ができます。

```cpp
#include <iostream>

namespace A {
    int count = 2;
}  // namespace A

namespace B {
    int count = 4;
}  // namespace B

int main() {
    std::cout << A::count << std::endl;  // 2
    std::cout << B::count << std::endl;  // 4

    return 0;
}
```

同一の名前空間に属する場合は、スコープ解決演算子 `::` による名前空間の指定を省略することが可能です。

```cpp
namespace A {
    int count = 2;

    int GetCount() {
      return count;  // A::count と同じ
    }
}  // namespace A
```

名前空間は入れ子にすることが出来ます。

```cpp
#include <iostream>

namespace A {
    int count = 2;  // A::count

    namespace P {
        int count = 4;  // A::P::count

        int GetCount() {
            return count;
        }
    }  // namespace P
}  // namespace A

int main() {
    std::cout << A::P::GetCount() << std::endl;  // 4;

    return 0;
}
```

同一の名前空間内に指定したシンボルが見つからなかった場合、シンボルを探す範囲を `namespace` ブロック毎に外に広げていき、最初に見つかったものが利用されます。

```cpp
#include <iostream>

namespace A {
    int count = 2;  // A::count

    namespace P {
        namespace X {
            int GetCount() {
                /*
                 * A::P::X::count は存在しない
                 * -> A::P::count は存在しない
                 *    -> A::count が利用される
                 */
                return count;
            }
        }  // namespace X
    }  // namespace P
}  // namespace A

int main() {
    std::cout << A::P::X::GetCount() << std::endl;  // 2;

    return 0;
}
```

!!! tip "std 名前空間"
    これまでに出てきた、 `std::cout` や `std::vector` 等の `std::` は std 名前空間の事を指しています。
    C++ の標準ライブラリの機能は、ほとんどが std 名前空間に属しています。

## 関数スコープ

関数内で宣言されたオブジェクトはその関数内でのみ有効になります。

```cpp hl_lines="4 5 6 7"
#include <iostream>

int GetCount() {
    int x = 5;  // GetCount() 内の x の有効範囲はここから

    return x;
}  // ここまで

int main() {
    int x = GetCount();  // main() の x と GetCount() の x は別スコープ
    std::cout << x << std::endl;

    return 0;
}
```

## ブロックスコープ

ブロック内もスコープの一つです。
`if` 文を始めとした制御文で使われる `{}` もブロックスコープに該当します。

名前空間同様、同一のブロック内に指定したシンボルが見つからなかった場合、シンボルを探す範囲をブロック毎に外に広げていき、最初に見つかったものが利用されます。

```cpp
#include <iostream>

int main() {
    int x = 3;

    {
        int x = 5;
        std::cout << x << std::endl;  // 5
    }

    {
        std::cout << x << std::endl;  // 3
    }

    return 0;
}
```

## グローバルスコープ

名前空間や関数に属さない場所はグローバルスコープと言います。
グローバルスコープに宣言された変数や関数は、宣言以降であればどこからでも利用することが出来ます。
また、グローバルスコープに宣言した変数・関数のことを一般的にグローバル変数・関数と言います。

```cpp hl_lines="3"
#include <iostream>

int x = 100;  // グローバル変数

int main() {
    std::cout << x << std::endl;  // 100

    return 0;
}
```

グローバル変数は「どこからでも利用することが出来る」という性質上、どこからでも値を書き換えることが出来ます。
どこで変数の値が書き換えられたのか特定しづらくなるため、可能な限り使わないことが望ましいです。

グローバルスコープは、一番外側の名前空間として捉えることも出来ます。
そのため、スコープ解決演算子 `::` を利用して、明示的にグローバルスコープを指定することが出来ます。

```cpp
#include <iostream>

int x = 20;

int main() {
    int x = 40;

    std::cout << x << std::endl;    // 40
    std::cout << ::x << std::endl;  // 20

    return 0;
}
```

<!-- MEMO: クラススコープはクラス側で話しているのでここでは言及しない -->