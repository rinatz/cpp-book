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

??? question "暗黙的な inline 指定"
    クラス宣言の中でメンバ関数を定義した場合、暗黙的に `inline` 指定されます。
    そのため、ヘッダファイルのクラス宣言の中でメンバ関数を定義しても
    リンク時にエラーにはなりません。

    ```cpp linenums="1" tab="rectangle.h" hl_lines="6 7 8"
    #ifndef RECTANGLE_H_
    #define RECTANGLE_H_

    class Rectangle {
     public:
        int Area() {
            return height_ * width_;
        }

        int height_;
        int width_;
    };

    #endif  // RECTANGLE_H_
    ```

    ```cpp linenums="1" tab="something.h"
    #ifndef SOMETHING_H_
    #define SOMETHING_H_

    void Something();

    #endif  // SOMETHING_H_
    ```

    ```cpp linenums="1" tab="something.cc"
    #include "something.h"

    #include <iostream>

    #include "rectangle.h"

    void Something() {
        Rectangle r;

        r.height_ = 2;
        r.width_ = 3;
        std::cout << r.Area() << std::endl;
    }
    ```

    ```cpp linenums="1" tab="main.cc"
    #include <iostream>

    #include "rectangle.h"
    #include "something.h"

    int main() {
        Rectangle r;
        r.height_ = 10;
        r.width_ = 20;
        std::cout << r.Area() << std::endl;

        Something();

        return 0;
    }
    ```

    クラス宣言とは別にメンバ関数を定義すると暗黙的な inline 指定はされなくなります。
    ヘッダファイル内でクラス宣言とは別にメンバ関数の定義を行うとリンク時にエラーとなります。

    ```cpp linenums="1" tab="rectangle.h" hl_lines="12 13 14"
    #ifndef RECTANGLE_H_
    #define RECTANGLE_H_

    class Rectangle {
     public:
        int Area();

        int height_;
        int width_;
    };

    int Rectangle::Area() {
        return height_ * width_;
    }

    #endif  // RECTANGLE_H_
    ```

    ヘッダファイル内でクラス宣言とは別にメンバ関数の定義を行うには、
    明示的に `inline` 指定する必要があります。

    ```cpp linenums="1" tab="rectangle.h" hl_lines="12"
    #ifndef RECTANGLE_H_
    #define RECTANGLE_H_

    class Rectangle {
     public:
        int Area();

        int height_;
        int width_;
    };

    inline int Rectangle::Area() {
        return height_ * width_;
    }

    #endif  // RECTANGLE_H_
    ```

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
