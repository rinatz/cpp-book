# コンストラクタ

オブジェクトを作成する際に呼び出されるメンバ関数をコンストラクタといいます。
コンストラクタはメンバ変数の初期化を行うために使用します。

クラス名と同じ名前で戻り値がない関数がコンストラクタになります。

```cpp hl_lines="3"
class Rectangle {
 public:
    Rectangle(int height, int width);

    int Area() const;

 private:
    const int height_;
    const int width_;
};
```

このコンストラクタを使ってオブジェクトを作成するには次のようにします。

```cpp
Rectangle r(10, 20);
```

## メンバ変数の初期化

コンストラクタでメンバ変数を初期化するには次のようにします。

```cpp hl_lines="3"
class Rectangle {
 public:
    Rectangle(int height, int width) : height_(height), width_(width) {}

    int Area() const {
        return height_ * width_;
    }

 private:
    const int height_;
    const int width_;
};
```

初期化は値の変更ではないため、
コンストラクタに渡された値から `const` メンバ変数の値を設定することができます。

## クラス宣言とは別に定義

クラス宣言とは別にコンストラクタを定義するには次のようにします。

```cpp hl_lines="3 14"
class Rectangle {
 public:
    Rectangle(int height, int width);

    int Area() const {
        return height_ * width_;
    }

 private:
    const int height_;
    const int width_;
};

Rectangle::Rectangle(int height, int width) : height_(height), width_(width) {}
```

## デフォルトコンストラクタ

値を1つも受け取らないコンストラクタをデフォルトコンストラクタといいます。

```cpp hl_lines="3"
class Rectangle {
 public:
    Rectangle() : height_(0), width_(0) {}

    int Area() const {
        return height_ * width_;
    }

 private:
    const int height_;
    const int width_;
};
```

デフォルトコンストラクタを使ってオブジェクトを作成するには次のようにします。

```cpp
Rectangle r;
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
