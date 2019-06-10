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

??? question "暗黙的にコピーコンストラクタが定義されないケース"
    コピーコンストラクタを定義していないクラスであっても、
    特定の条件を満たした場合には暗黙的なコピーコンストラクタの定義は行われなくなります。

    条件の一例として次のものがあります。

    - コピーできないメンバ変数をもつ
    - 右辺値参照型のメンバ変数をもつ
    - 下記のいずれかが明示的に定義されている
        - ムーブコンストラクタ
        - ムーブ代入演算子

    詳細は [コピーコンストラクタ - cppreference.com][cppreference_copy_constructor] を参照してください。

[cppreference_copy_constructor]: https://ja.cppreference.com/w/cpp/language/copy_constructor

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

ムーブコンストラクタを定義していないクラスでは、
コンパイラによって暗黙的にムーブコンストラクタが定義されます。

??? question "暗黙的にムーブコンストラクタが定義されないケース"
    ムーブコンストラクタを定義していないクラスであっても、
    特定の条件を満たした場合には暗黙的なムーブコンストラクタの定義は行われなくなります。

    条件の一例として次のものがあります。

    - ムーブできないメンバ変数をもつ
    - 下記のいずれかが明示的に定義されている
        - コピーコンストラクタ
        - コピー代入演算子
        - ムーブ代入演算子
        - デストラクタ

    詳細は [ムーブコンストラクタ - cppreference.com][cppreference_move_constructor] を参照してください。

[cppreference_move_constructor]: https://ja.cppreference.com/w/cpp/language/move_constructor

## 変換コンストラクタと explicit

値を1つだけ受け取るコンストラクタを変換コンストラクタといいます。
コピーコンストラクタやムーブコンストラクタも変換コンストラクタです。

```cpp hl_lines="3"
class Square {
 public:
    Square(int size) : size_(size) {}

    int Area() const {
        return size_ * size_;
    }

 private:
    int size_;
};
```

受け取る値が2個の場合と同様にオブジェクトを作成するには次のようにします。

```cpp
Square s(10);
```

以下のようにした場合、
`int` から `Square` への暗黙的な型変換で変換コンストラクタが使用されます。

```cpp
Square s = 10;
```

暗黙的な型変換で使用されないようにするには
変換コンストラクタに `explicit` をつけます。

暗黙的な型変換を意図して使用する場合を除き、
受け取る値が1つのコンストラクタには `explicit` をつけることが望ましいです。

!!! note "コピーコンストラクタとムーブコンストラクタ"
    コピーコンストラクタとムーブコンストラクタを `explicit` にすると
    関数の戻り値で値渡しすることができなくなります。
    一般的にコピーコンストラクタとムーブコンストラクタは `explicit` にはしません。

```cpp hl_lines="3"
class Square {
 public:
    explicit Square(int size) : size_(size) {}

    int Area() const {
        return size_ * size_;
    }

 private:
    int size_;
};
```

`explicit` をつけると以下の記述はコンパイルエラーになります。

```cpp
Square s = 10;
```

## 継承

派生クラスのコンストラクタは
基底クラスのデフォルトコンストラクタを暗黙的に呼び出します。

!!! example "constructor_inheritance.cc"
    ```cpp hl_lines="5 6 7 20 21 22 26" linenums="1"
    #include <iostream>

    class Rectangle {
     public:
        Rectangle() : height_(0), width_(0) {
            std::cout << "Rectangle::Rectangle() is called." << std::endl;
        }

        int Area() const {
            return height_ * width_;
        }

     private:
        const int height_;
        const int width_;
    };

    class Square : public Rectangle {
     public:
        Square() {
            std::cout << "Square::Square() is called." << std::endl;
        }
    };

    int main() {
        Square s;  // Square クラスのデフォルトコンストラクタを使用
        std::cout << "area = " << s.Area() << std::endl;
        return 0;
    }
    ```

実行結果は以下のようになります。

```txt
Rectangle::Rectangle() is called.
Square::Square() is called.
area = 0
```

コンストラクタの実行順序は、必ず次の順序になります。

1. 基底クラスのコンストラクタ
1. 派生クラスのコンストラクタ

基底クラスのコンストラクタを明示的に呼び出すこともできます。

```cpp hl_lines="16"
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

class Square : public Rectangle {
 public:
    Square(int size) : Rectangle(size, size) {}
};
```
