# アサーション

## assert

実行時に条件を満たさないと
[std::abort][cpprefjp_abort] を呼び出してプログラムを異常終了させる処理です。

`assert` を使用するには `<cassert>` のインクルードが必要です。

[cpprefjp_abort]: https://cpprefjp.github.io/reference/cstdlib/abort.html

```cpp linenums="1" hl_lines="7"
#include <cassert>
#include <iostream>
#include <limits>
#include <vector>

int Max(const std::vector<int>& v) {
    assert(!v.empty());

    int max = std::numeric_limits<int>::min();
    for (auto e : v) {
        if (e > max) {
            max = e;
        }
    }
    return max;
}

int main() {
    std::vector<int> v1 = {1, 2, 3, 4, 5};
    std::vector<int> v2;

    std::cout << Max(v1) << std::endl;
    std::cout << Max(v2) << std::endl;

    return 0;
}
```

実行結果は次のようになります。

```bash
$ ./a.exe
5
assertion "!v.empty()" failed: file "main.cc", line 7, function: int Max(const std::vector<int>&)
Aborted (コアダンプ)
```

`assert` は開発中にバグを取り除くことを想定した機能で、 `NDEBUG` が定義されるリリースビルドでは無効となります。
`NDEBUG` を定義するには `-DNDEBUG` を指定します。

```bash
$ g++ -std=c++11 -DNDEBUG main.cc
```

`NDEBUG` を定義してビルドすると実行結果は次のように変化します。

```bash
$ ./a.exe
5
-2147483648
```

## static_assert

コンパイル時に条件を満たさないとコンパイルエラーにする処理です。

```cpp
template <typename T, int N>
class Array {
    static_assert(N > 0, "サイズは0より大きくなければなりません");

 public:
    int size() const { return N; }

    T data_[N];  // サイズ 0 の配列はコンパイルエラーにならない
};

int main() {
    Array<int, 0> a;
    return 0;
}
```

コンパイル結果は以下のようになります。

```bash
$ g++ -std=c++11 -c main.cc
main.cc: In instantiation of ‘class Array<int, 0>’:
main.cc:12:19:   required from here
main.cc:3:5: エラー: static assertion failed: サイズは0より大きくなければなりま
せん
     static_assert(N > 0, "サイズは0より大きくなければなりません");
     ^~~~~~~~~~~~~
```
