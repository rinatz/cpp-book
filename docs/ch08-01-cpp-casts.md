# C++ のキャスト

C++ では4種類のキャスト演算子が用意されています。

|   キャスト演算子   | 主な用途                                         |
|------------------|:-----------------------------------------------|
| static_cast      | 型変換を明示的に行う                               |
| dynamic_cast     | 基底クラス型のポインタを派生クラス型のポインタに変換する |
| const_cast       | const修飾子を外す                                |
| reinterpret_cast | ポインタの型変換を行う                             |

本節では基本的な使い方だけを説明します。
詳しい説明は [キャストの詳しい説明][cast-details] を参照してください。

[cast-details]: appendix-cast-details.md

## static_cast

型変換を明示的に行うためのキャストです。必要があれば値を変化させます。

```cpp
double dx = 3.14;
int x = static_cast<int>(dx);  // 3
```

列挙型と数値型の変換など
暗黙的に変換されない型変換も行うことができます。

```cpp
enum class Day {
    Sun,  // 0
    Mon,  // 1
    Tue,  // 2
    Wed,  // 3
    Thu,  // 4
    Fri,  // 5
    Sat   // 6
};

Day day1 = static_cast<Day>(1);         // Day::Mon
int day2 = static_cast<int>(Day::Tue);  // 2
```

型変換を明示的に行うことで、
`explicit` 指定された変換コンストラクタによる変換も行うことができます。

```cpp
class Square {
 public:
    explicit Square(int size) : size_(size) {}

 private:
    int size_;
};

Square square = static_cast<Square>(10);
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
