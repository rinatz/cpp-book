# GDB による CUI デバッグ

## GDB の起動と終了

### 起動

デバッグビルドされた `a.exe` をデバッグするために
下記コマンドを打って GDB を起動します。

```bash
$ gdb a.exe
```

GDB は起動時にバージョンなどの情報を出力します。

`a.exe` の読み込みに成功するとバージョンなどの情報の後に
`Reading symbols from ./a.exe...done.` のようなメッセージが出力されます。

プロンプトと呼ばれる文字列 `(gdb)` が出力されると GDB のコマンドを入力することができます。

### 終了

`quit` で GDB を終了することができます。

```gdb
(gdb) quit
```

`quit` は `q` と省略できます。

```gdb
(gdb) q
```

## デバッグ開始

`run` でデバッグ対象プログラムを開始します。

```gdb
(gdb) run
```

`run` は `r` と省略できます。

```gdb
(gdb) r
```

ブレークポイントが設定されていない状態だとプログラム終了まで実行されます。

## ブレークポイント

以下のコードで説明します。

```cpp tab="main.cc" linenums="1"
#include <iostream>

#include "sum.h"

int main() {
    std::cout << Sum(1, 2) << std::endl;
    return 0;
}
```

```cpp tab="sum.h" linenums="1"
#ifndef SUM_H_
#define SUM_H_

int Sum(int a, int b);

#endif  // SUM_H_
```

```cpp tab="sum.cc" linenums="1"
#include "sum.h"

int Sum(int a, int b) {
    return a + b;
}
```

### 追加

`break ファイル:行番号` または `break 関数名` でブレークポイントを追加します。

```gdb
(gdb) break main.cc:6
Breakpoint 1 at 0x10040108d: file main.cc, line 6.
(gdb) break Sum
Breakpoint 2 at 0x10040113a: file sum.cc, line 4.
```

`break` は `b` と省略することもできます。

```gdb
(gdb) b main.cc:6
Breakpoint 1 at 0x10040108d: file main.cc, line 6.
(gdb) b Sum
Breakpoint 2 at 0x10040113a: file sum.cc, line 4.
```

### 一覧の確認

`info breakpoints` でブレークポイントの一覧を確認することができます。

```gdb
(gdb) info breakpoints
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

`info` は `i` と省略できます。
`breakpoints` は `break` や `b` と省略できます。

```gdb
(gdb) i b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

### プログラムの一時停止

ブレークポイントを追加した状態でデバッグを開始すると、
ブレークポイントに到達した時点でプログラムが一時停止します。

```gdb
(gdb) run
Starting program: a.exe
[New Thread 10676.0x3cf8]
[New Thread 10676.0x1ab8]
[New Thread 10676.0x17e4]
[New Thread 10676.0x1494]
[New Thread 10676.0x36a4]

Thread 1 "a" hit Breakpoint 1, main () at main.cc:6
6           std::cout << Sum(1, 2) << std::endl;
```

### プログラムの再開

`continue` でプログラムを再開することができます。
次のブレークポイントに到達すると再び一時停止します。

```gdb
(gdb) continue
Continuing.

Thread 1 "a" hit Breakpoint 2, Sum (a=1, b=2) at sum.cc:4
4           return a + b;
```

### 削除

`delete n` でブレークポイントを削除することができます。
`n` には `info breakpoints` の `Num` の値で指定します。

```gdb
(gdb) info breakpoints
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
(gdb) delete 1
(gdb) info breakpoints
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

`delete` は `d` と省略できます。

```gdb
(gdb) i b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
(gdb) d 1
(gdb) i b
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

`delete` で対象を指定しない場合にはすべてのブレークポイントを削除します。

```gdb
(gdb) info breakpoints
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
(gdb) delete
Delete all breakpoints? (y or n) y
(gdb) info breakpoints
No breakpoints or watchpoints.
```

## 評価値の表示

以下のコードで説明します。

```cpp tab="main.cc" linenums="1"
#include <iostream>

#include "swap.h"

// 最大公約数
int GreatestCommonDivisor(int a, int b) {
    while (a != 0) {
        b = b % a;
        Swap(&a, &b);
    }
    return b;
}

// 最小公倍数
int LeastCommonMultiple(int a, int b) {
    int gcd = GreatestCommonDivisor(a, b);
    return a * b / gcd;
}

int main() {
    int a = 12;
    int b = 18;
    std::cout << a << " と " << b << " の最小公倍数は "
              << LeastCommonMultiple(a, b) << " です" << std::endl;
    return 0;
}
```

```cpp tab="swap.h" linenums="1"
#ifndef SWAP_H_
#define SWAP_H_

// 2つの変数の値を入れ替える
void Swap(int* a, int* b);

#endif  // SWAP_H_
```

```cpp tab="swap.cc" linenums="1"
#include "swap.h"

void Swap(int* a, int* b) {
    int tmp = *a;
    *a = *b;
    *b = tmp;
}
```

### 変数の値を確認

`print` で変数の値を確認することができます。

```gdb
(gdb) break main.cc:17
(gdb) run
Thread 1 "a" hit Breakpoint 1, LeastCommonMultiple (a=12, b=18) at main.cc:17
17          return a * b / gcd;
(gdb) print a
$1 = 12
(gdb) print b
$2 = 18
(gdb) print gcd
$3 = 6
```

`print` は `p` と省略できます。

```gdb
(gdb) b main.cc:17
(gdb) r
Thread 1 "a" hit Breakpoint 1, LeastCommonMultiple (a=12, b=18) at main.cc:17
17          return a * b / gcd;
(gdb) p a
$1 = 12
(gdb) p b
$2 = 18
(gdb) p gcd
$3 = 6
```

### 確認した値の再利用

値を確認すると `$n = 値` と出力され、 `$n` で結果を再利用することができます。

```gdb hl_lines="9 17 18"
(gdb) break main.cc:8
(gdb) break main.cc:9
(gdb) run
Starting program: a.exe

Thread 1 "a" hit Breakpoint 1, GreatestCommonDivisor (a=12, b=18) at main.cc:8
8               b = b % a;
(gdb) print b
$1 = 18
(gdb) continue
Continuing.

Thread 1 "a" hit Breakpoint 2, GreatestCommonDivisor (a=12, b=6) at main.cc:9
9               Swap(&a, &b);
(gdb) print b
$2 = 6
(gdb) print $1
$3 = 18
```

### 任意の処理を実行

`print` では変数の値を確認するだけでなく、
関数呼び出しを行ってその戻り値を確認したり、任意の演算を行った結果を確認することができます。

```gdb hl_lines="7"
(gdb) break main.cc:17
(gdb) run
Thread 1 "a" hit Breakpoint 1, LeastCommonMultiple (a=12, b=18) at main.cc:17
17          return a * b / gcd;
(gdb) print gcd
$1 = 6
(gdb) print GreatestCommonDivisor(b, a)
$2 = 6
```

変数の値を変更する代入なども行えてしまうため、副作用に気をつける必要があります。

```gdb hl_lines="7"
(gdb) break main.cc:17
(gdb) run
Thread 1 "a" hit Breakpoint 1, LeastCommonMultiple (a=12, b=18) at main.cc:17
17          return a * b / gcd;
(gdb) print gcd
$1 = 6
(gdb) print gcd = 0
$2 = 0
(gdb) print gcd
$3 = 0
```

<!-- TODO: inline関数を呼び出せない理由 -->

### ポインタに対する操作

変数からポインタを得る `&` やデリファレンスの `*` が使用できます。

```gdb hl_lines="8 17"
(gdb) break main.cc:9
(gdb) break Swap
(gdb) run
Starting program: a.exe

Thread 1 "a" hit Breakpoint 1, GreatestCommonDivisor (a=12, b=6) at main.cc:9
9               Swap(&a, &b);
(gdb) print &a
$1 = (int *) 0xffffcb70
(gdb) continue
Continuing.

Thread 1 "a" hit Breakpoint 2, Swap (a=0xffffcb70, b=0xffffcb78) at swap.cc:4
4           int tmp = *a;
(gdb) print a
$2 = (int *) 0xffffcb70
(gdb) print *a
$3 = 12
```

## ステップ実行

以下のコードで説明します。

```cpp tab="main.cc" linenums="1"
#include <iostream>

#include "circle.h"

double SquareOf(double v) {
    return v * v;
}

double SquareOfDistance(const Point& p, const Point& q) {
    return SquareOf(q.X() - p.X()) + SquareOf(q.Y() - p.Y());
}

bool Intersects(const Circle& c1, const Circle& c2) {
    auto c = SquareOfDistance(c1.Center(), c2.Center());
    auto r = SquareOf(c1.Radius() + c2.Radius());
    return c < r;
}

int main() {
    Circle c1(Point(1, 2), 3);
    Circle c2(Point(5, 0), 2);

    if (Intersects(c1, c2)) {
        std::cout << "2つの円は交差します" << std::endl;
    } else {
        std::cout << "2つの円は交差しません" << std::endl;
    }
    return 0;
}
```

```cpp tab="circle.h" linenums="1"
#ifndef CIRCLE_H_
#define CIRCLE_H_

#include "point.h"

class Circle {
 public:
    Circle(const Point& center, double radius)
        : center_(center), radius_(radius) {}

    Point Center() const {
        return center_;
    }

    double Radius() const {
        return radius_;
    }

 private:
    Point center_;
    double radius_;
};

#endif  // CIRCLE_H_
```

```cpp tab="point.h" linenums="1"
#ifndef POINT_H_
#define POINT_H_

class Point {
 public:
    Point(double x, double y) : x_(x), y_(y) {}

    double X() const {
        return x_;
    }

    double Y() const {
        return y_;
    }

 private:
    double x_;
    double y_;
};

#endif  // POINT_H_
```

### ステップオーバー

`next` で現在の行から次に処理がある行まで進めます。

```gdb
(gdb) break Intersects
(gdb) run
Thread 1 "a" hit Breakpoint 1, Intersects (c1=..., c2=...) at main.cc:14
14          auto c = SquareOfDistance(c1.Center(), c2.Center());
(gdb) next
15          auto r = SquareOf(c1.Radius() + c2.Radius());
```

`next` は `n` と省略できます。

```gdb
(gdb) b Intersects
(gdb) r
Thread 1 "a" hit Breakpoint 1, Intersects (c1=..., c2=...) at main.cc:14
14          auto c = SquareOfDistance(c1.Center(), c2.Center());
(gdb) n
15          auto r = SquareOf(c1.Radius() + c2.Radius());
```

### ステップイン

`step` で現在の処理から次の処理まで進めます。
現在の処理が関数呼び出しの場合には呼び出した関数の内部で停止します。

```gdb
(gdb) break Intersects
(gdb) run
Thread 1 "a" hit Breakpoint 1, Intersects (c1=..., c2=...) at main.cc:14
14          auto c = SquareOfDistance(c1.Center(), c2.Center());
(gdb) step
Circle::Center (this=0xffffcb90) at circle.h:12
12              return center_;
```

`step` は `s` と省略できます。

```gdb
(gdb) b Intersects
(gdb) r
Thread 1 "a" hit Breakpoint 1, Intersects (c1=..., c2=...) at main.cc:14
14          auto c = SquareOfDistance(c1.Center(), c2.Center());
(gdb) s
Circle::Center (this=0xffffcb90) at circle.h:12
12              return center_;
```

### ステップアウト

`finish` で現在の関数が終了して呼び出し元に戻るまで進めます。

```gdb
(gdb) break Intersects
(gdb) run
Thread 1 "a" hit Breakpoint 1, Intersects (c1=..., c2=...) at main.cc:14
14          auto c = SquareOfDistance(c1.Center(), c2.Center());
(gdb) finish
Run till exit from #0  Intersects (c1=..., c2=...) at main.cc:14
0x0000000100401233 in main () at main.cc:23
23          if (Intersects(c1, c2)) {
Value returned is $1 = true
```

`finish` は `fin` と省略できます。

```gdb
(gdb) b Intersects
(gdb) r
Thread 1 "a" hit Breakpoint 1, Intersects (c1=..., c2=...) at main.cc:14
14          auto c = SquareOfDistance(c1.Center(), c2.Center());
(gdb) fin
Run till exit from #0  Intersects (c1=..., c2=...) at main.cc:14
0x0000000100401233 in main () at main.cc:23
23          if (Intersects(c1, c2)) {
Value returned is $1 = true
```

!!! tip "実引数で関数の戻り値を使用する場合"
    ```cpp
    auto c = SquareOfDistance(c1.Center(), c2.Center());
    ```

    のように実引数として他の関数の戻り値を使用する場合には、
    次のように `step` と `finish` を交互に使用することで実引数を求める各処理と
    実引数を定めた後に呼び出す関数をデバッグすることができます。

    ```gdb
    (gdb) break Intersects
    (gdb) run
    Thread 1 "a" hit Breakpoint 1, Intersects (c1=..., c2=...) at main.cc:14
    14          auto c = SquareOfDistance(c1.Center(), c2.Center());
    (gdb) step
    Circle::Center (this=0xffffcb90) at circle.h:12
    12              return center_;
    (gdb) finish
    Run till exit from #0  Circle::Center (this=0xffffcb90) at circle.h:12
    0x0000000100401133 in Intersects (c1=..., c2=...) at main.cc:14
    14          auto c = SquareOfDistance(c1.Center(), c2.Center());
    Value returned is $1 = {x_ = 5, y_ = 0}
    (gdb) step
    Circle::Center (this=0xffffcbb0) at circle.h:12
    12              return center_;
    (gdb) finish
    Run till exit from #0  Circle::Center (this=0xffffcbb0) at circle.h:12
    0x0000000100401143 in Intersects (c1=..., c2=...) at main.cc:14
    14          auto c = SquareOfDistance(c1.Center(), c2.Center());
    Value returned is $2 = {x_ = 1, y_ = 2}
    (gdb) step
    SquareOfDistance (p=..., q=...) at main.cc:10
    10          return SquareOf(q.X() - p.X()) + SquareOf(q.Y() - p.Y());
    ```

## スタックフレーム

以下のコードで説明します。

```cpp tab="main.cc" linenums="1"
#include <iostream>

int GreatestCommonDivisor(int a, int b) {
    if (a == 0) {
        return b;
    }

    return GreatestCommonDivisor(b % a, a);
}

int main() {
    int a = 12;
    int b = 18;
    std::cout << a << " と " << b << " の最大公約数は "
              << GreatestCommonDivisor(a, b) << " です" << std::endl;
    return 0;
}
```

### 表示

`backtrace` でスタックフレームの一覧を表示します。
現在の箇所に到達するまでの関数呼び出しを確認できます。

```gdb
(gdb) break main.cc:5
(gdb) run
Thread 1 "a" hit Breakpoint 1, GreatestCommonDivisor (a=0, b=6) at main.cc:5
5               return b;
(gdb) backtrace
#0  GreatestCommonDivisor (a=0, b=6) at main.cc:5
#1  0x00000001004010ac in GreatestCommonDivisor (a=6, b=12) at main.cc:8
#2  0x00000001004010ac in GreatestCommonDivisor (a=12, b=18) at main.cc:8
#3  0x000000010040111f in main () at main.cc:15
```

`backtrace` は `bt` と省略できます。

```gdb
(gdb) b main.cc:5
Breakpoint 1 at 0x100401094: file main.cc, line 5.
(gdb) r
Thread 1 "a" hit Breakpoint 1, GreatestCommonDivisor (a=0, b=6) at main.cc:5
5               return b;
(gdb) bt
#0  GreatestCommonDivisor (a=0, b=6) at main.cc:5
#1  0x00000001004010ac in GreatestCommonDivisor (a=6, b=12) at main.cc:8
#2  0x00000001004010ac in GreatestCommonDivisor (a=12, b=18) at main.cc:8
#3  0x000000010040111f in main () at main.cc:15
```

### 移動

`up` や `down` で GDB が参照するスタックフレームを上下に移動します。
GDB の参照箇所が移動するだけでプログラムの実行箇所は移動しません。

```gdb
(gdb) backtrace
#0  GreatestCommonDivisor (a=0, b=6) at main.cc:5
#1  0x00000001004010ac in GreatestCommonDivisor (a=6, b=12) at main.cc:8
#2  0x00000001004010ac in GreatestCommonDivisor (a=12, b=18) at main.cc:8
#3  0x000000010040111f in main () at main.cc:15
(gdb) up
#1  0x00000001004010ac in GreatestCommonDivisor (a=6, b=12) at main.cc:8
8           return GreatestCommonDivisor(b % a, a);
(gdb) down
#0  GreatestCommonDivisor (a=0, b=6) at main.cc:5
5               return b;
```

`frame` で GDB が参照しているスタックフレームを表示することができます。

```gdb
(gdb) frame
#0  GreatestCommonDivisor (a=0, b=6) at main.cc:5
5               return b;
```

`frame n` で `#n` のフレームへ移動できます。

```gdb
(gdb) frame
#0  GreatestCommonDivisor (a=0, b=6) at main.cc:5
5               return b;
(gdb) frame 3
#3  0x000000010040111f in main () at main.cc:15
15                    << GreatestCommonDivisor(a, b) << " です" << std::endl;
(gdb) frame
#3  0x000000010040111f in main () at main.cc:15
15                    << GreatestCommonDivisor(a, b) << " です" << std::endl;
```

`frame` は `f` と省略できます。

```cpp
(gdb) bt
#0  GreatestCommonDivisor (a=0, b=6) at main.cc:5
#1  0x00000001004010ac in GreatestCommonDivisor (a=6, b=12) at main.cc:8
#2  0x00000001004010ac in GreatestCommonDivisor (a=12, b=18) at main.cc:8
#3  0x000000010040111f in main () at main.cc:15
(gdb) f 3
#3  0x000000010040111f in main () at main.cc:15
15                    << GreatestCommonDivisor(a, b) << " です" << std::endl;
```

## 参考

* [GDB User Manual](https://sourceware.org/gdb/current/onlinedocs/gdb/)

<!-- TODO
## 条件付きブレークポイント
(gdb) condition 2 x==0 # Add break condition x==0 for break point 2
(gdb) condition 2 # Clear break condition
(gdb) catch throw # catch point

## ウォッチポイント
(gdb) watch i==0  # watch point / break when i==0 becomes not satisfied

## その他便利なもの
(gdb) set print pretty
(gdb) set pagination off
(gdb) shell
(gdb) return
(gdb) set x 1
(gdb) until
-->
