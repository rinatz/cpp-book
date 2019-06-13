# 演算子オーバーロード

クラスに対する演算子を定義することで演算子が使用可能になります。
演算子は関数またはメンバ関数として定義します。

## 単項演算子

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

std::cout << a.Value() << std::endl;  // 2
std::cout << b.Value() << std::endl;  // 3
std::cout << c.Value() << std::endl;  // 5
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
        Integer tmp(Value() + rhs.Value());  // 左辺は自オブジェクトを使用する
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

## インクリメント/デクリメント

インクリメント/デクリメントには前置と後置の2種類があります。

前置は単行演算子の方法で定義します。

```cpp hl_lines="9 10 11 12"
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

    Integer& operator++() {
        ++value_;
        return *this;
    }

 private:
    int value_;
};
```

次のように前置インクリメントが使用できるようになります。

```cpp hl_lines="2"
Integer a(2);
Integer b = ++a;

std::cout << a.Value() << std::endl;  // 3
std::cout << b.Value() << std::endl;  // 3
```

後置は二項演算子の方法で定義します。
これは前置と後置を区別するために後置では `int` (通常は値 `0`) が渡される決まりがあるからです。

```cpp hl_lines="9 10 11 12 13"
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const {
        return value_;
    }

    Integer operator++(int) {  // 引数の int は使用しない
        Integer tmp(Value());
        ++value_;
        return tmp;
    }

 private:
    int value_;
};
```

次のように後置インクリメントが使用できるようになります。

```cpp hl_lines="2"
Integer a(2);
Integer b = a++;

std::cout << a.Value() << std::endl;  // 3
std::cout << b.Value() << std::endl;  // 2
```

## 期待される振る舞い

演算子の振る舞いについては制約がほとんどありませんが、
一般に組み込みの演算子と同様の振る舞いになることが期待されます。

たとえば次のように期待する動作と異なる実装にすることも可能ではあります。

```cpp
class Integer {
 public:
    explicit Integer(int value) : value_(value) {}

    int Value() const { return value_; }

    Integer& operator-() {
        return *this;  // 何もしないで自オブジェクトを返却
    }

 private:
    int value_;
};
```

この定義に対して演算子を使用すると次のようになります。

```cpp
Integer a(2);
Integer b = -a;

std::cout << a.Value() << std::endl;  // 2
std::cout << b.Value() << std::endl;  // 2 (-2 ではない)
```

このように期待される振る舞いと異なる振る舞いにならないように、
組み込みの演算子となるべく同じ振る舞いになるよう定義するのが一般的です。

期待される振る舞いについては
[演算子オーバーロード - cppreference.com][cppreference_operators] を参照してください。

[cppreference_operators]: https://ja.cppreference.com/w/cpp/language/operators
