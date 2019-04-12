# 継承

C++ で継承を使用する方法について説明します。

`Concrete` クラスで `Interface` クラスを継承するには次のようにします。

```cpp
class Interface {};

class Concrete : public Interface {};
```

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
