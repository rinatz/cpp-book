# POD の API 互換性

C と C++ でヘッダファイルを共有して、
同じ型宣言を使用するには API 互換性が必要です。
POD であれば ABI 互換性は保証されますが、 API 互換性は保証されません。

POD にする場合には API 互換性もあるように定義しましょう。

## C には存在しない C++ の機能

C に存在しない機能を使用していると API 互換性はありません。
C に存在しない機能の一例として次のものがあります。

- クラス
- 名前空間
- テンプレート
- C++ の標準ヘッダファイル

<!-- WARNING: stdbool.h の bool と C++ の bool は互換性があるか不明 -->

### クラス

C にはクラスはありませんが構造体はあります。
そのため POD の型はクラスではなく構造体にするのが一般的です。

C の構造体はデータメンバをもつ以外の機能はなく、以下の機能は使用できません。

- メンバ関数
- 継承
- データメンバに対するアクセス指定子

API 互換性を保つためには、
これらの機能を一切使用しないで構造体を定義するとよいです。

```cpp
struct Sample {
    unsigned char c;
    double d;
};
```

### C++ の標準ヘッダファイル

C++ の標準ヘッダファイルは C では使用できませんが、
C の標準ヘッダファイルは C++ でも使用できます。

C の標準ヘッダファイルに対して、
C++ では先頭に `c` をつけて拡張子を除いたものが用意されています。
たとえば C の標準ヘッダファイル `<stdint.h>` に対して
C++ の標準ヘッダファイル `<cstdint>` があります。

通常 C++ では C++ の標準ヘッダファイルを使用するのが望ましいのですが、
C の標準ヘッダファイルを使用することができます。
この2つの違いは C++ のものは `std` 名前空間に属するようになることです。

API 互換性を保つためには、 C の標準ヘッダファイルを使用します。

```cpp
#include <stdint.h>

struct FundamentalTypes {
    int16_t i;
    double d;
};
```

## C++ には存在しない C の機能

C++ は C と高い互換性がありますが、完全上位互換ではありません。
C++ に存在しない機能を使用していると API 互換性はありません。
C++11 は [C99] というバージョンの C の機能を概ね取り込んでいますが、
すべての機能を取り込んでいる訳ではありません。

[C99]: https://ja.wikipedia.org/wiki/C99

たとえば C99 には複合リテラルという機能がありますが C++ では使用できません。

```c hl_lines="9 10"
int Sum(const int v[], int n) {
    int sum = 0;
    for (int i = 0; i < n; ++i) {
        sum += v[i];
    }
    return sum;
}

// 複合リテラルによる配列の生成
int sum = Sum((int[]){1, 2, 3, 4, 5}, 5);
```

同様の処理を C++ で行うには `std::array` などを使用する必要があります。

```cpp
int sum = Sum(std::array<int, 5>({1, 2, 3, 4, 5}).data(), 5);
```

詳細は
[複合リテラル - cppreference.com][cppreference_compound_literal]
を参照してください。

[cppreference_compound_literal]: https://ja.cppreference.com/w/c/language/compound_literal

## C と C++ で異なるソースコードにする

[プリプロセッサ司令] を使用して C と C++ で異なるソースコードにすることができます。

[プリプロセッサ司令]: appendix-preprocessor-directives.md

C++ では `__cplusplus` というマクロが定義されますが、
C では定義されないことを利用して次のようにすることができます。

```cpp
#ifdef __cplusplus
// C++ だけで有効なソースコード
#else
// C だけで有効なソースコード
#endif  // __cplusplus
```

これを利用すれば C には存在しない C++ の機能を C++ だけで有効にすることができますが、
メモリレイアウトが同一になることを担保するのが難しいため基本的には推奨しません。

??? question "C++ だけで名前空間を有効にする"
    名前空間は名前マングリングに影響しますが、メモリレイアウトには影響しません。
    名前マングリングが問題にならなければ C++ だけで名前空間を有効にすることができます。

    ```cpp linenums="1"
    #ifdef __cplusplus
    namespace sample {
    #endif  // __cplusplus

    struct Sample {
        unsigned char c;
        double d;
    };

    #ifdef __cplusplus
    }
    #endif  // __cplusplus
    ```

??? question "C++ だけでメンバ関数を有効にする"
    仮想関数がある場合は POD ではありませんが、
    仮想関数ではないメンバ関数があっても POD になります。

    仮想関数ではないメンバ関数の有無はメモリレイアウトに影響しないため、
    C++ だけでメンバ関数を有効にすることができます。

    ```cpp linenums="1"
    struct Sample {
        unsigned char c;
        double d;

    #ifdef __cplusplus
        double GetD() const {
            return d;
        }
    #endif  // __cplusplus
    };
    ```

    メンバ関数を追加するだけの派生クラスを C++ だけで使用する方法もあります。

    ```cpp linenums="1"
    struct Sample {
        unsigned char c;
        double d;
    };

    #ifdef __cplusplus
    class SampleCpp : public Sample {
     public:
        double GetD() const {
            return d;
        }
    };
    #endif  // __cplusplus
    ```
