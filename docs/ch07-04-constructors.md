# コンストラクタ

C++ でコンストラクタを使用する方法について説明します。

2つの整数値を受け取るコンストラクタを宣言するには次のようにします。

```cpp
class TwoArguments {
 public:
    TwoArguments(int a, int b);
};
```

クラス名と同じ名前で戻り値がない関数がコンストラクタになります。

このコンストラクタを使ってオブジェクトを作成するには次のようにします。

```cpp
TwoArguments t(1, 2);
```

コンストラクタの定義をクラス宣言の中に書く場合は次のようにします。

```cpp
class TwoArguments {
 public:
    TwoArguments(int a, int b) {
        std::cout << "a=" << a << std::endl;
        std::cout << "b=" << b << std::endl;
    }
};
```

コンストラクタの定義をクラス宣言の外に書く場合は次のようにします。

```cpp
class TwoArguments {
 public:
    TwoArguments(int a, int b);
};

TwoArguments::TwoArguments(int a, int b) {
    std::cout << "a=" << a << std::endl;
    std::cout << "b=" << b << std::endl;
}
```

## メンバ変数の初期化

コンストラクタでメンバ変数を初期化するには次のようにします。

```cpp
class TwoArguments {
 public:
    TwoArguments(int a, int b) : a_(a), b_(b) {}
 private:
    const int a_;
    int b_;
};
```

初期化は値の変更ではないため、
コンストラクタに渡された値から `const` メンバ変数の値を設定することができます。

## デフォルトコンストラクタ

値を1つも受け取らないコンストラクタをデフォルトコンストラクタといいます。

```cpp
class Default {
 public:
    Default();
};
```

デフォルトコンストラクタを使ってオブジェクトを作成するには次のようにします。

```cpp
Default d;
```

明示的に定義するコンストラクタが1つもない場合のみ、
コンパイラが暗黙的にデフォルトコンストラクタを定義します。

## コピーコンストラクタ

そのクラスの参照だけを受け取るコンストラクタをコピーコンストラクタといいます。

```cpp
class Copyable {
 public:
    Copyable();  // デフォルトコンストラクタ
    Copyable(const Copyable& c);  // コピーコンストラクタ
};
```

コピーコンストラクタを使ってオブジェクトを作成するには次のようにします。

```cpp
Copyable c1;  // デフォルトコンストラクタでオブジェクト作成
Copyable c2(c1);  // コピーコンストラクタでオブジェクト作成
```

`const` ではない参照であってもコピーコンストラクタになりますが、
コピー元を変更せずにコピーを行うために `const` の参照にすることが多いです。

コピーコンストラクタを定義していないクラスでは、
コンパイラによって暗黙的にコピーコンストラクタが定義されます。

## ムーブコンストラクタ

そのクラスの右辺値参照だけを受け取るコンストラクタをムーブコンストラクタといいます。

```cpp
class Movable {
 public:
    Movable(Movable&& m);
};
```

ムーブコンストラクタを使ってオブジェクトを作成するには次のようにします。

```cpp
Movable m1;  // デフォルトコンストラクタでオブジェクト作成
Movable m2(std::move(m1));  // ムーブコンストラクタでオブジェクト作成
```
