# ダウンキャスト

基底クラスの参照やポインタから派生クラスの参照やポインタへの型変換をダウンキャストといいます。

C++ では、ダウンキャストをする際に `dynamic_cast` を使います。
`dynamic_cast` が使えるのは仮想関数を持ったクラスに限定されます。

```cpp
class Base {
 public:
    virtual ~Base(){}
};
class Sub1 : public Base {};

Sub1* sub1 = dynamic_cast<Sub1*>(new Base());  // ダウンキャスト
```

`dynamic_cast` は他のキャスト演算子と異なり、実行時にキャストの成否を判断します。
`dynamic_cast` は実行時の型の情報を確認した上で、継承関係が不正であった場合、キャストに失敗します。
「ポインタでのキャスト」と「参照でのキャスト」では、失敗時の挙動が異なります。

ポインタでのキャストでは、失敗時に `nullptr` を返却します。

```cpp
class Base {
 public:
    virtual ~Base(){}
};
class Sub1 : public Base {};
class Sub2 : public Base {};

int main() {
    Base* base = new Sub1;
    Sub2* sub2 = dynamic_cast<Sub2*>(base);  // ダウンキャスト
    if (sub2 == nullptr) {
        std::cout << "ダウンキャスト失敗" << std::endl;
    }

    return 0;
}
```

参照でのキャストでは、失敗時に `std::bad_cast` 例外を送出します。

```cpp
class Base {
 public:
    virtual ~Base(){}
};
class Sub1 : public Base {};
class Sub2 : public Base {};

int main() {
    try {
        Base* base = new Sub1();
        Sub2& sub2 = dynamic_cast<Sub2&>(*base);  // ダウンキャスト
    } catch (const std::bad_cast&) {
        std::cout << "ダウンキャスト失敗" << std::endl;
    }

    return 0;
}
```

ダウンキャストをしたクラスを扱う場合、注意をしないとメモリアクセス違反を引き起こす可能性があります。
そのため、ダウンキャストを行わないで済むようなコードを書くことが望ましいです。

```cpp
class Base {
 public:
    virtual ~Base(){}
};
class Sub1 : public Base {
 public:
    int x_;
};

int main() {
    Base* base = new Base();  // Base 型分のメモリが確保される
    Sub1* sub1 = dynamic_cast<Sub1*>(base);  // ダウンキャスト

    sub1->x_ = 100;  // sub1 は base のメモリ領域を指したポインタ
                     // base には存在しない領域 x_ を参照しようとして不正なメモリアクセスになる
    return 0;
}
```