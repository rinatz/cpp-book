# ダウンキャスト

基底クラスの参照やポインタから派生クラスの参照やポインタへの型変換をダウンキャストといいます。
C++ では、ダウンキャストをする際に `dynamic_cast` や `static_cast` を使います。

ダウンキャストをしたクラスを扱う場合、
キャスト失敗を考慮したコードを書く必要があったり、
メモリアクセス違反を引き起こすようなコードになる可能性があります。
そのため、ダウンキャストを行わないで済むようなコードを書くことが望ましいです。

## dynamic_cast によるダウンキャスト

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
`dynamic_cast` は [実行時型情報 (RTTI)][wikipedia_RTTI] を確認した上で、継承関係が不正であった場合、キャストに失敗します。

[wikipedia_RTTI]: https://ja.wikipedia.org/wiki/実行時型情報

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

## static_cast によるダウンキャスト

キャスト元のポインタが正しくキャスト後のオブジェクトを指していることが自明であれば、
`static_cast` を利用してダウンキャストを行うことも可能です。

```cpp
class Base {
 public:
    virtual ~Base(){}
};
class Sub1 : public Base {
 public:
    int x_;
};
class Sub2 : public Base {}

Base* base = new Sub1();  // Sub1 からのアップキャスト
Sub1* sub1 = static_cast<Sub1*>(base);  // Sub1 へのダウンキャスト
                                        // base の実体は Sub1 なので問題なし
```

`static_cast` は `dynamic_cast` とは違い、
実行時の型の情報をチェックしていないので、
次のような危険なダウンキャストも出来てしまいます。
`static_cast` の場合、キャストが成功しても動作は保証されないので注意が必要です。

```cpp
class Base {
 public:
    virtual ~Base(){}
};
class Sub1 : public Base {
 public:
    int x_;
};
class Sub2 : public Base {}

Base* base = new Sub2();  // Sub2 からのアップキャスト
Sub1* sub1 = static_cast<Sub1*>(base);  // Sub1 へのダウンキャスト

sub1->x_ = 100;  // sub1 は Sub2 のメモリ領域を指したポインタ
                 // Sub2 には存在しない領域 x_ を参照しようとして不正なメモリアクセスになる
```