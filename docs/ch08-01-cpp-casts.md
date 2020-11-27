# C++ のキャスト

C++ では4種類のキャスト演算子が用意されています。

|   キャスト演算子   | 主な用途                                         |
|------------------|:-----------------------------------------------|
| static_cast      | 型変換を明示的に行う                               |
| dynamic_cast     | 基底クラス型のポインタと派生クラス型のポインタを変換する |
| const_cast       | const修飾を変化させる                                |
| reinterpret_cast | 型情報だけ変える                             |

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

一般にダウンキャストをする際に、 `dynamic_cast` を使います。アップキャストに使うときは `static_cast` と同じ意味を持ちます。
`dynamic_cast` の詳細については [ダウンキャスト][downcasts] を参照してください。

[downcasts]: appendix-downcasts.md

## const_cast

一般にconst修飾子を外すときに用いるキャストです。const修飾を付加するときは `static_cast` と同じ意味を持ちます。

```cpp
const std::string str("hoge");
std::string& x = const_cast<std::string&>(str);
```

「オブジェクトに変更を加えないようにする」ために `const` が付いているにも関わらず、
`const_cast` で「オブジェクトに変更を加えられるようにする」ことは望ましくないので、基本的には使いません。

## reinterpret_cast

値はそのまま型情報の変換を行うキャストです。安全に使用するためにはいくつもの落とし穴があります。
[Strict Aliasing Rules]のようにキャスト単体でみれば問題なくても全体としてみると未定義動作を引き起こすこともあります。
`std::nullptr_t -> T -> std::nullptr_t` が反例で、常にA→B→Aというふうに変換できるという保証もありません。
`reinterpret_cast` とはこうした未定義動作と未規定の動作などがそこかしこに横たわる魔境といえるでしょう。
事実として `reinterpret_cast` の誤った用法をしばしば目にします。先人が書いたコードや解説を信用してはいけません。
したがってなるべく `reinterpret_cast` を使わないようなコードを書くことが望ましいです。

[Strict Aliasing Rules]: https://yohhoy.hatenadiary.jp/entry/20120220/p1

`reinterpret_cast` はバイナリデータの読み書き時に使われることがあります。
入力ストリームの `read()` や出力ストリームの `write()` の第 1 引数のポインタの型が決まっているためです。

```cpp hl_lines="18"
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
    // const char*型への変換はStrict Aliasing Rulesに反しない
    ofs.write(reinterpret_cast<const char *>(nums.data()), size);

    return 0;
}
```

??? question "Strict Aliasing Rules"
    ポインタがどう使われているかコンパイラが解析することは極めて困難なため、最適化を行いやすくするために定められた規則の一つです。  
    もう少し言うとどのようなとき2つの変数が実際には同じメモリ位置を参照するかもしれないと仮定すべきかが定められています。  
    特に `reinterpret_cast` を用いるとき、Strict Aliasing Rulesに十分注意する必要があります。規則に反すれば未定義動作になります。

    - [（翻訳）C/C++のStrict Aliasingを理解する または - どうして#$@##@^%コンパイラは僕がしたい事をさせてくれないの！ - yohhoyの日記](https://yohhoy.hatenadiary.jp/entry/20120220/p1)
    - [C++20規格書 [basic.lval#11]](https://timsong-cpp.github.io/cppwp/n4861/basic.lval#11)

    このルールの判定は実際にメモリーへのアクセスが行われたタイミングでどう振る舞うかというものであり、単一のキャストだけで判断できるものでは有りません。  
    例えば次のコードは、 `A` と `B` という全く関係のない型へのポインタを変換しようとしています。しかしキャストしているだけではStrict Aliasing Rulesに反していません  
    このあと実際に変数 `b` にアクセスしたときに違反し、未定義動作となります。

    ```cpp
    class A {};
    class B {};

    A a;
    B* b = reinterpret_cast<B*>(&a);
    ```

    よくあるStrict Aliasing Rulesを破っているコードの例を示します。これはネットワーク通信などでよく見られるエンディアンを変換しようとするコードです。  
    32bitのストレージを16bitごとに区切ってswapしようと試みていますが、未定義動作を踏んでいます。

    ```cpp
    #include <cstdint>
    #include <iostream>
    #include <iomanip>
    using std::uint32_t;
    using std::uint16_t;
    uint32_t swaphalves(uint32_t a) {
        uint32_t acopy=a;
        uint16_t *ptr=reinterpret_cast<uint16_t*>(&acopy);// ptrはacopyのaliasにならない
        uint16_t tmp=ptr[0];
        ptr[0]=ptr[1];// Undefined Behavior: ptrへの変更操作があるがaliasではない
        ptr[1]=tmp;
        return acopy;
    }

    int main()
    {
        uint32_t a = 32;
        std::cout << std::hex << std::setfill('0') << std::setw(8) << a << std::endl;
        a = swaphalves(a);
        std::cout << std::setw(8) << a << std::endl;
    }
    ```

    Strict Aliasing Rulesを回避するには `std::memcpy` を用いるかC++20で追加された [`std::bit_cast`](https://cpprefjp.github.io/reference/bit/bit_cast.html) を用います
