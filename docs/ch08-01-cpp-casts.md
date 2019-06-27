# C++ のキャスト

C++ では4種類のキャスト演算子が用意されています。

|   キャスト演算子   | 主な用途                                         |
|------------------|:-----------------------------------------------|
| static_cast      | 型変換を明示的に行う                               |
| dynamic_cast     | 基底クラス型のポインタを派生クラス型のポインタに変換する |
| const_cast       | const修飾子を外す                                |
| reinterpret_cast | ポインタの型変換を行う                             |

## static_cast

暗黙的な型変換を明示的に行うためのキャストです。

```cpp
double dx = 3.14;
int x = static_cast<int>(dx);
```

## dynamic_cast

ダウンキャストをする際に、 `dynamic_cast` を使います。
`dynamic_cast` の詳細については [ダウンキャスト][downcasts] を参照してください。

[downcasts]: appendix-downcasts.md


## const_cast

const修飾子を外すことができるキャストです。

```cpp
const std::string str("hoge");
std::string& x = const_cast<std::string&>(str);
```

「オブジェクトに変更を加えないようにする」ために `const` が付いているにも関わらず、
`const_cast` で「オブジェクトに変更を加えられるようにする」ことは望ましくないので、基本的には使いません。


## reinterpret_cast

ポインタの型変換を行うキャストです。

```cpp
class A {};
class B {};

A a;
B* b = reinterpret_cast<B*>(&a);
```

変換後の型から変換前の型に戻すことができる点は保証されていますが、
変換したものが正しく機能するかは実装に依存するため、なるべく `reinterpret_cast` を使わないようなコードを書くことが望ましいです。

`reinterpret_cast` はバイナリデータの読み書き時に使われることがあります。
入力ストリームの `read()` や出力ストリームの `write()` の第 1 引数のポインタの型が決まっているためです。

```cpp hl_lines="17"
#include <fstream>
#include <vector>

int main() {
    std::vector<int> nums = {1, 2, 3, 4};

    // バイナリ + 出力モードでストリームを開く
    std::ofstream ofs("nums.bin", std::ios::binary | std::ios::out);
    if(!ofs) {
        return 1;
    }

    const auto size = sizeof(int) * nums.size();  // int のサイズ * 配列要素数

    // 配列の先頭から配列全体のサイズ分をファイルに書き込む
    // 先頭ポインタはキャストが必要
    ofs.write(reinterpret_cast<const char *>(nums.data()), size);

    return 0;
}
```