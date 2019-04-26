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
