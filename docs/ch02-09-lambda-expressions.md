# ラムダ式

ラムダ式は、簡潔に関数オブジェクトを記述するための式です。
ラムダ式で生成される関数オブジェクトは `auto` で保持することが出来ます。

ラムダ式の構文は次のようになります。

```cpp
// auto 変数名 = [ キャプチャ ]( 引数リスト ) -> 戻り値の型 { 処理内容 };
auto func = [](int a, int b) -> int { return a + b; };  // int を2つ受け取り、足した結果を返すラムダ式

int result = func(4, 6);
std::cout << result << std::endl;  // 10
```

## キャプチャ

ラムダ式の外にある変数をラムダ式の中で使用する場合は、
ラムダ式先頭の `[]` 内でキャプチャと呼ばれるものの指定が必要です。

キャプチャには、コピーキャプチャと参照キャプチャの2種類が存在します。

|  記述例   | 内容                                                             |
|:---------:|------------------------------------------------------------------|
| `[=]`     | ラムダ式定義時に存在する全ての変数をコピーしてラムダ式の中で使う |
| `[&]`     | ラムダ式定義時に存在する全ての変数を参照してラムダ式の中で使う   |
| `[a]`     | 変数 `a` をコピーしてラムダ式の中で使う                          |
| `[&a]`    | 変数 `a` を参照してラムダ式の中で使う                            |
| `[&a, b]` | 変数 `a` は参照し、変数 `b` はコピーしてラムダ式の中で使う       |
| `[=, &a]` | 変数 `a` は参照し、それ以外はコピーしてラムダ式の中で使う        |

```cpp
int init = 5;

// キャプチャを指定することで {} 内で変数 init を使うことができる
auto f = [init](int a, int b) { return init + a * b; };   // コピーキャプチャ
auto g = [&init](int a, int b) { return init + a * b; };  // 参照キャプチャ

init = 0;

// 【コピーキャプチャの場合】
//    ラムダ式の定義時点で init がコピーされているので、ラムダ式内の init は 5
int result_copy = f(2, 4);
std::cout << result_copy << std::endl;  // 13

// 【参照キャプチャの場合】
//    ラムダ式実行時の init の値が参照されるので、ラムダ式内の init は 0
int result_ref = g(2, 4);
std::cout << result_ref << std::endl;   // 8
```

## 引数リスト

`( 引数リスト )` は、通常の関数と同じように記述することが出来ます。

```cpp
auto func1 = [](int x) -> int { return x * x; };  // int を引数とする
auto func2 = []() -> int { return 400; };         // 引数なし
auto func3 = [] { return 400; };                  // 戻り値の型の記述を省略した場合、 () ごと省略可能
```

## 戻り値の型の省略

`-> 戻り値の型` は、 ラムダ式内の型推論に任せる場合は省略可能です。

```cpp
auto func = [](int a, int b) { return a + b; };  // a, b は共に int なので、戻り値も int と推論される
```

## 関数ポインタへの変換

キャプチャを持たないラムダ式であれば関数ポインタに暗黙変換することが出来ます。

```cpp
int (*fp)(int, int) = [](int x, int y) { return x + y; };
```

## `std::function`

`std::function` で関数ポインタやラムダ式（キャプチャを持つラムダ式も含む）を保持することが出来ます。
`std::function` を使うことで、関数ポインタのような複雑な構文が簡潔になるという利点もあります。

```cpp
#include <functional>

int Add(int x, int y) {
    return x + y;
}

int main() {
    std::function<int(int, int)> f = Add;  // std::function<戻り値の型(引数の型)> 変数名
    int result = f(3, 5);                  // f を介して関数 Add が実行される
    std::cout << result << std::endl;      // 8

    f = [](int x, int y) { return x * y; };  // ラムダ式も保持可能
    std::cout << f(4, 7) << std::endl;       // 28

    return 0;
}
```
