# 継承

クラスのメンバ (データメンバとメンバ関数) を引き継いで
新しいクラスを作成することを継承といいます。

長方形を扱う `Rectangle` クラスを継承して
正方形を扱う `Square` クラスを作るには次のようにします。

```cpp hl_lines="13"
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
    std::cout << s.Area() << std::endl;
    return 0;
}
```

`Square` クラスでは `Rectangle` クラスの全メンバを使用できます。
メンバ関数 `SetSize` で `Rectangle` クラスのデータメンバ `height_` と `width_` を参照したり、
メンバ関数の呼び出しで `s.Area` としたりすることができます。

継承を行った場合もメンバを持つことができるため、
`Square` クラスでは `Rectangle` クラスにはないメンバ関数 `SetSize` を追加することができます。

## 基底クラスと派生クラス

継承の元になったクラスのことを基底クラス、
継承して作ったクラスのことを派生クラスといいます。

`Rectangle` クラスを継承して `Square` クラスを作る場合、
`Rectangle` クラスが基底クラス、 `Square` クラスが派生クラスとなります。

## アクセス指定子

メンバを参照できる範囲はアクセス指定子によって制限することができます。
アクセス指定子には次の3つがあります。

| アクセス指定子 |      自クラス      |   継承したクラス   |       その他       |
| -------------- | ------------------ | ------------------ | ------------------ |
| public         | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| protected      | :white_check_mark: | :white_check_mark: | :x:                |
| private        | :white_check_mark: | :x:                | :x:                |

デフォルトでは `private` になります。

### メンバに対するアクセス指定子

`private` にすると自クラス内でのみメンバが参照できます。

!!! example "private_member.cc"
    ```cpp hl_lines="7 8 9 15 16 22 23" linenums="1"
    class Rectangle {
     public:
        int Area() const {
            height_ * width_;  // 参照可
        }

     private:
        int height_;
        int width_;
    };

    class Square : public Rectangle {
     public:
        void SetSize(int size) {
            height_ = size;  // コンパイルエラーになります
            width_ = size;   // コンパイルエラーになります
        }
    };

    int main() {
        Rectangle r;
        r.height_ = 10;  // コンパイルエラーになります
        r.width_ = 20;   // コンパイルエラーになります

        Square s;
        s.SetSize(10);
        return 0;
    }
    ```

`protected` にすると自クラス内に加え、継承したクラス内でも参照できるようになります。

!!! example "protected_member.cc"
    ```cpp hl_lines="7 8 9 22 23" linenums="1"
    class Rectangle {
     public:
        int Area() const {
            height_ * width_;  // 参照可
        }

     protected:
        int height_;
        int width_;
    };

    class Square : public Rectangle {
     public:
        void SetSize(int size) {
            height_ = size;  // 参照可
            width_ = size;   // 参照可
        }
    };

    int main() {
        Rectangle r;
        r.height_ = 10;  // コンパイルエラーになります
        r.width_ = 20;   // コンパイルエラーになります

        Square s;
        s.SetSize(10);
        return 0;
    }
    ```

`public` にすると参照できる範囲の制限はなくなります。

!!! example "public_member.cc"
    ```cpp hl_lines="7 8 9" linenums="1"
    class Rectangle {
     public:
        int Area() const {
            height_ * width_;  // 参照可
        }

     public:
        int height_;
        int width_;
    };

    class Square : public Rectangle {
     public:
        void SetSize(int size) {
            height_ = size;  // 参照可
            width_ = size;   // 参照可
        }
    };

    int main() {
        Rectangle r;
        r.height_ = 10;  // 参照可
        r.width_ = 20;   // 参照可

        Square s;
        s.SetSize(10);
        return 0;
    }
    ```

アクセス指定子は次のアクセス指定子が出現するまでが有効範囲となります。
また、アクセス指定子は何度でも使用できます。

```cpp
class AccessSpecifier {
    void Private1();  // デフォルトは private

 public:
    void Public1();
    void Public2();

 public:  // 対象となるメンバがなくても問題なし
 private:
    void Private2();

 private:  // アクセスレベルの変化がなくても問題なし
    void Private3();
};
```

読みづらいコードになってしまうのを防ぐため、
アクセス指定子の使い方についてコーディング規約で指定されることもあります。

### 継承に対するアクセス指定子

派生クラスではアクセス指定子によって
基底クラスのメンバを参照できる範囲をさらに制限することができます。

デフォルトでは `private` になります。

```cpp
class Base {};

class Sub1 : public Base {};  // public 継承
class Sub2 : protected Base {};  // protected 継承
class Sub3 : private Base {};  // private 継承
class Sub4 : Base {};  // private 継承 (デフォルト)
```

インターフェースのクラスを継承して実装を行う場合には `public` を使用します。

詳細は [派生クラス - cppreference.com][cppreference_derived_class] を参照してください。

[cppreference_derived_class]: https://ja.cppreference.com/w/cpp/language/derived_class
