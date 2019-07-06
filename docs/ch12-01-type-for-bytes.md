# バイトを表す型

C++ では以下の型のサイズが1バイトと規定されています。
C でも同様です。

- `char`
- `signed char`
- `unsigned char`

ビットを取り扱う際には符号なしであることが望ましいため、
バイトを表す型としては `unsigned char` を使用します。

??? warning "char は signed char とは異なる型"
    以下の型はすべて異なる型として扱われます。

    - `char`
    - `signed char`
    - `unsigned char`

    異なる型であるため、次のようなオーバーロードが可能です。

    ```cpp linenums="1"
    #include <iostream>

    void Hoge(char c) {
        std::cout << "char: " << c << std::endl;
    }

    void Hoge(signed char c) {
        std::cout << "signed char: " << c << std::endl;
    }

    void Hoge(unsigned char c) {
        std::cout << "unsigned char: " << c << std::endl;
    }

    int main() {
        Hoge('A');                              // char: A
        Hoge(static_cast<char>('B'));           // char: B
        Hoge(static_cast<signed char>('C'));    // signed char: C
        Hoge(static_cast<unsigned char>('D'));  // unsigned char: D
        return 0;
    }
    ```

    `char` は処理系で最も効率的に処理できる文字表現の型です。
    `char` のビット表現は `signed char` または `unsigned char`
    のいずれか一方と一致しますが、どちらと一致するかは処理系依存です。

??? question "C++17 で追加された std::byte"
    文字とバイトデータの用途を明確にするため、
    C++17 で [std::byte][cpprefjp_byte] という型が追加されました。

    C++17 の機能であるため C++11 では使用できません。

[cpprefjp_byte]: https://cpprefjp.github.io/reference/cstddef/byte.html

## 1バイトは8ビットとは限らない

2008年に発行された [IEC 80000-13][wikipedia_byte] にて
$1 byte = 8 bits$ と正式に定義されました。

[wikipedia_byte]: https://ja.wikipedia.org/wiki/バイト_(情報)

それ以前は
処理系が1つのアドレスで扱うビット数 (メモリ操作の最小単位) を
1バイトと定めることが多く、
$1 byte = 8 bits$ とは限らず
$1 byte = 7 bits$ や $1 byte = 9 bits$ となることもありました。

C や C++ では以下の制約によって $1 byte = 8 bits$ 以上と規定しています。

- `char` 型のサイズを1バイトとする
- `char` 型のビット数 [CHAR_BIT] は8ビット以上とする

[CHAR_BIT]: https://cpprefjp.github.io/reference/climits/char_bit.html

C や C++ では
$1 byte = 7 bits$ は許容されませんが、
$1 byte = 9 bits$ は許容されています。

実際には
$1 byte = 8 bits$ ではない処理系は非常に少ないため、
$1 byte = 8 bits$ だけを想定した実装にすることも多いです。

$1 byte = 8 bits$ しか想定していないことを表明する必要があれば
次のようにします。

```cpp
#include <climits>
static_assert(CHAR_BIT == 8, "Not support 1byte != 8bits");
```
