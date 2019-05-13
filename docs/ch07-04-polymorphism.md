# 多態性

## アップキャスト

派生クラスの参照やポインタから
基底クラスの参照やポインタへの型変換をアップキャストといいます。

アップキャストによって、
派生クラスのオブジェクトを基底クラスの参照またはポインタで扱うことができます。

!!! example "polymorphism_upcast.cc"
    ```cpp hl_lines="25 26" linenums="1"
    #include <iostream>

    class Rectangle {
     public:
        int Area() const {
            return height_ * width_;
        }

        int height_;
        int width_;
    };

    class Square : public Rectangle {
     public:
        void SetSize(int size) {
            height_ = size;
            width_ = size;
        }
    };

    int main() {
        Square s;
        s.SetSize(10);

        const Rectangle& r = s;
        std::cout << "area = " << r.Area() << std::endl;

        return 0;
    }
    ```

この例では `Square` クラスのオブジェクト `s` を `Rectangle` クラスの参照 `r` で扱っています。

アップキャストは暗黙的に行われるため、明示的に型変換を行う必要はありません。

## ダウンキャスト

基底クラスの参照やポインタから
派生クラスの参照やポインタへの型変換をダウンキャストといいます。

ダウンキャストを行わないで済むようなコードを書くことが望ましいです。

<!-- TODO: キャストのページへのリンクを追加する -->

## 仮想関数とオーバーライド

派生クラスで挙動を変更できるメンバ関数を仮想関数といいます。
仮想関数にするには基底クラスのメンバ関数に `virtual` をつけます。

派生クラスで仮想関数の挙動を変更することをオーバーライドといいます。
オーバーライドするには派生クラスのメンバ関数に `override` をつけます。

!!! example "polymorphism_override.cc"
    ```cpp hl_lines="5 21 31" linenums="1"
    #include <iostream>

    class Rectangle {
     public:
        virtual void Describe() const {
            std::cout << "height = " << height_ << std::endl;
            std::cout << "width = " << width_ << std::endl;
        }

        int height_;
        int width_;
    };

    class Square : public Rectangle {
     public:
        void SetSize(int size) {
            height_ = size;
            width_ = size;
        }

        void Describe() const override {
            std::cout << "size = " << height_ << std::endl;
        }
    };

    int main() {
        Square s;
        s.SetSize(10);

        const Rectangle& r = s;
        r.Describe();

        return 0;
    }
    ```

実行結果は以下のようになります。

```txt
size = 10
```

この例ではメンバ関数 `Describe` がオーバーライドされているため、
`Rectangle` クラスではなく `Square` クラスの `Describe` が実行されます。

## 純粋仮想関数とインターフェース

定義をもたない仮想関数を純粋仮想関数といいます。
純粋仮想関数にするには仮想関数に `= 0` をつけます。

```cpp hl_lines="3"
class Polygon {
 public:
    virtual void Area() const = 0;
};
```

純粋仮想関数があるクラスのオブジェクトは作ることができません。

C++ にはインターフェースクラスをつくるための専用の記法はないため、
メンバ関数がすべて純粋仮想関数であるクラスをインターフェースとして使います。

```cpp hl_lines="3 8"
class Polygon {
 public:
    virtual int Area() const = 0;
};

class Rectangle : public Polygon {
 public:
    int Area() const override {
        return height_ * width_;
    }

    int height_;
    int width_;
};
```
