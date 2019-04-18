# 継承

クラスのメンバ (メンバ変数とメンバ関数) を引き継いで
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
メンバ関数 `SetSize` で `Rectangle` クラスのメンバ変数 `height_` と `width_` を参照したり、
メンバ関数の呼び出しで `s.Area` としたりすることができます。

継承を行った場合もメンバを持つことができるため、
`Square` クラスでは `Rectangle` クラスにはないメンバ関数 `SetSize` を追加することができます。

## メンバのアクセス指定

メンバ関数とメンバ変数のアクセスレベルは次の3つのいずれかを指定します。

| アクセス指定子 |     自クラス内     |    派生クラス内    |        外部        |
| -------------- | ------------------ | ------------------ | ------------------ |
| public         | :white_check_mark: | :white_check_mark: | :white_check_mark: |
| protected      | :white_check_mark: | :white_check_mark: | :x:                |
| private        | :white_check_mark: | :x:                | :x:                |

デフォルトでは `private` になります。

`public` に指定すると外部からメンバを使用することができます。

!!! example "public.cc"
    ```cpp hl_lines="2 3 8" linenums="1"
    class Concrete {
     public:
        void Public() {}
    };

    int main() {
        Concrete c;
        c.Public();
        return 0;
    }
    ```

`private` に指定すると自クラス内でのみメンバを使用できるようにします。

!!! example "private.cc"
    ```cpp hl_lines="4 7 8 14" linenums="1"
    class Concrete {
     public:
        void Public() {
            Private();
        }

     private:
        void Private() {}
    };

    int main() {
        Concrete c;
        c.Public();
        // c.Private();  // コンパイルエラーになります
        return 0;
    }
    ```

アクセスレベルはアクセス指定子で指定されたところから変更されます。
また、アクセス指定子はクラス内に何度でも使用できます。

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

## 継承のアクセス指定

基底クラスを継承する際のアクセスレベルは次の3つのいずれかを指定します。

* public
* protected
* private

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
