# 演算子オーバーロード

クラスに対する演算子を定義することで演算子が使用可能になります。
演算子は関数またはメンバ関数として定義します。

## 単行演算子

整数を扱う `Integer` クラスの負号演算子を関数として定義するには次のようにします。

```cpp hl_lines="13 14 15 16 17"
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

 private:
    int value_;
};

// 負号演算子の対象が引数として渡される
Integer operator-(const Integer& v) {
    Integer tmp(-v.Value());
    return tmp;
}
```

この演算子を使用するには次のようにします。

```cpp hl_lines="2"
Integer a(2);
Integer b = -a;

std::cout << a.Value() << std::endl;  // 2
std::cout << b.Value() << std::endl;  // -2
```

メンバ関数として定義するには次のようにします。

```cpp hl_lines="9 10 11 12 13"
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

    // 負号演算子の対象のメンバ関数
    Integer operator-() const {
        Integer tmp(-Value());  // 演算対象は自オブジェクトを使用する
        return tmp;
    }

 private:
    int value_;
};
```

## 二項演算子

整数を扱う `Integer` クラスの加算演算子を関数として定義するには次のようにします。

```cpp hl_lines="13 14 15 16 17"
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

 private:
    int value_;
};

// 加算演算子の左辺が第1引数、右辺が第2引数として渡される
Integer operator+(const Integer& lhs, const Integer& rhs) {
    Integer tmp(lhs.Value() + rhs.Value());
    return tmp;
}
```

この演算子を使用するには次のようにします。

```cpp hl_lines="3"
Integer a(2);
Integer b(3);
Integer c = a + b;

std::cout << a.Value() << std::endl;
std::cout << b.Value() << std::endl;
std::cout << c.Value() << std::endl;
```

メンバ関数として定義するには次のようにします。

```cpp hl_lines="9 10 11 12 13"
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

    // 加算演算子の左辺のメンバ関数に対して、右辺が引数として渡される
    Integer operator+(const Integer& rhs) {
        Integer tmp(Value() + rhs.Value());  // 左辺は自クラスを使用する
        return tmp;
    }

 private:
    int value_;
};
```

一般に二項演算子は対称性を維持するために関数として実装されます。
たとえば整数クラスと実数クラスの二項演算子は次のように実装します。

```cpp hl_lines="25 26 27 28 30 31 32 33"
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

 private:
    int value_;
};

class RealNumber {
 public:
    explicit RealNumber(double value) : value_(value) {}

    double Value() const {
        return value_;
    }

 private:
    double value_;
};

RealNumber operator+(const Integer& lhs, const RealNumber& rhs) {
    RealNumber tmp(lhs.Value() + rhs.Value());
    return tmp;
}

RealNumber operator+(const RealNumber& lhs, const Integer& rhs) {
    RealNumber tmp(lhs.Value() + rhs.Value());
    return tmp;
}
```

<!-- TODO: 単行演算子のインクリメントの前置と後置の説明 -->

<!-- TODO: https://ja.cppreference.com/w/cpp/language/operators へのリンクを追加 -->
