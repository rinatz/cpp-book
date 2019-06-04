# デバッグ

[ヘロンの公式] によって
辺の長さが 3, 4, 5 である三角形の面積を求める以下の処理を例として扱います。

[ヘロンの公式]: https://ja.wikipedia.org/wiki/ヘロンの公式

この処理で期待する実行結果は `6` ですが、
このプログラムは期待通りの結果にはなりません。

なぜ期待通りの結果にならないのかをデバッグによって調査します。

```cpp
#include <array>
#include <cmath>
#include <iostream>

struct Triangle {
    std::array<double, 3> sides;
    std::int64_t id;

    Triangle(int64_t id, double a, double b, double c)
        : id(id), sides({a, b, c}) {}
};

double Area(const Triangle& t) {
    double a = t.sides[1];
    double b = t.sides[2];
    double c = t.sides[3];

    double s = (a + b + c) / 2.0;
    double area = std::sqrt(s * (s - a) * (s - b) * (s - c));
    return area;
}

int main() {
    Triangle t(1, 3.0, 4.0, 5.0);
    std::cout << Area(t) << std::endl;
    return 0;
}
```

## デバッグビルド

通常のビルドはリリースビルドと呼ばれ、
実行時に不要な情報を省いて最適化を行うことで高いパフォーマンスを実現しています。

コードにおけるファイルや行番号をはじめ、
デバッグで必要な情報の多くはリリースビルドでは省かれてしまうため、
デバッグを行うためにはデバッグビルドでビルドしたものを使用します。

デバッグビルドを行うためには `-g` を指定します。

<!-- TODO: -O0 のような最適化抑制も必要か確認する -->

```bash
$ g++ -std=c++11 -g main.cc
```
