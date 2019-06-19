# メンバ関数

クラスが持つ関数をメンバ関数といいます。

長方形を扱う `Rectangle` クラスに
面積を求めるメンバ関数 `Area` を持たせるには次のようにします。

```cpp hl_lines="3 4 5"
class Rectangle {
 public:
    int Area() {
       return height_ * width_;
    }

    int height_;
    int width_;
};
```

メンバ関数を使用するには `.` を使用します。

```cpp hl_lines="4"
Rectangle r;
r.height_ = 10;
r.width_ = 20;
r.Area();
```

## クラス宣言とは別に定義

クラス宣言とは別にメンバ関数を定義するには次のようにします。

```cpp hl_lines="3 9 10 11"
class Rectangle {
 public:
    int Area();

    int height_;
    int width_;
};

int Rectangle::Area() {
    return height_ * width_;
}
```

どのクラスのメンバ関数であるかを表すために `Rectangle::` が必要になります。

## const メンバ関数

引数リストのあとに `const` をつけることで `const` メンバ関数になります。

```cpp hl_lines="3"
class Rectangle {
 public:
    int Area() const;
};
```

`const` メンバ関数ではメンバ変数を変更することができません。

```cpp hl_lines="10"
class Rectangle {
 public:
    int Area() const;

    int height_;
    int width_;
};

int Rectangle::Area() const {
    height_ = 0;  // メンバ変数を変更するとコンパイルエラーになります
    return height_ * width_;
}
```

`const` メンバ関数はメンバ変数を変更しないため、
オブジェクトの状態を変化させずに呼び出すことができます。

メンバ変数を変更しないという制約を満たすために、
`const` メンバ関数から呼び出せるメンバ関数は `const` メンバ関数に限定されます。

## this ポインタ

メンバ関数では `this` で自オブジェクトのポインタを取得することができます。

```cpp
class Rectangle {
 public:
    int Area();

    int height_;
    int width_;
};

int Rectangle::Area() {
   // this ポインタ経由でメンバ変数を使用
    return this->height_ * this->width_;
}
```
