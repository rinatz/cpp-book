# クラステンプレート

クラスに対するテンプレートをクラステンプレートといいます。
クラステンプレートを定義するには次のようにします。

```cpp
template <typename T>
class Rectangle {
 public:
    Rectangle(T height, T width) : height_(height), width_(width) {}

    T Area() const {
       return height_ * width_;
    }

 private:
    const T height_;
    const T width_;
};
```

クラステンプレートのクラスのオブジェクトを生成するには次のようにします。

```cpp
Rectangle<int> r1(10, 20);
Rectangle<double> r2(1.2, 3.4);
```

クラステンプレートではテンプレート実引数を省略することはできません。

テンプレート引数が必要なのはオブジェクト生成時のみで、
生成後は通常のクラスと同様に使用することができます。

```cpp
r1.Area();  // 200
r2.Area();  // 4.08
```

## 複数のテンプレート引数

パラメータ化する型やコンパイル時に定まる値は
クラステンプレートでも複数にすることができます。

```cpp
template <typename T, typename U>
class Rectangle {
 public:
    Rectangle(T height, U width) : height_(height), width_(width) {}

    double Area() const {
       return height_ * width_;
    }

 private:
    const T height_;
    const U width_;
};
```

この例ではメンバ関数 `Area()` の戻り値を `double` に固定して
テンプレート引数を2つにしています。

## メンバ関数の戻り値の型推論

クラステンプレートでメンバ関数の戻り値の型を推論するには
`decltype` 内で `std::declval` を使用します。

```cpp hl_lines="6"
template <typename T, typename U>
class Rectangle {
 public:
    Rectangle(T height, U width) : height_(height), width_(width) {}

    auto Area() const -> decltype(std::declval<T>() * std::declval<U>()) {
        return height_ * width_;
    }

 private:
    const T height_;
    const U width_;
};
```

## コンパイル時に定まる値のパラメータ化

コンパイル時に定まる値のパラメータ化はクラステンプレートでも使用できます。

```cpp
template <typename T, int N>
class Array {
 public:
    int size() const {
       return N;
    }

    T data_[N];
};
```
