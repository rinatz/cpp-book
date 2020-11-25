# 共用体

共用体は複数の型のどれかを格納したい、という場合に用いるものです。

```cpp
#include <string>
union X {
    int m1;
    double m2;
    std::string m3;
    X() : m1(0) {}
    ~X() {}
};
template <class T>
void destroy_at(T* location)
{
    location->~T();
}
int main()
{
    X x;
    new (&x.m3) std::string("aaa");
    destroy_at(&x.m3);
}
```

共用体に暗黙ではない特殊メンバ関数(コンストラクタなど)が定義されているようなクラス型を入れる場合、いくつか注意があります。

- 共用体の対応する特殊メンバ関数は削除されるので自力で定義しなければならない
- そのクラス型の値を入れる場合、[配置new](https://cpprefjp.github.io/reference/new/op_new.html)という機能を使ってクラスのコンストラクタを呼び出さなければならない。またデストラクタも同様

デストラクタの呼び出しは上の例では `destory_at` という関数を定義して行っています。同様の処理をしてくれるものがC++17以降では `<memory>` ヘッダーに [`std::destory_at`](https://cpprefjp.github.io/reference/memory/destroy_at.html) としてあります。

構造体の大きさがメンバーのすべての型の大きさの総和にパディングなどを足したものであったのに対して、
共用体ではメンバーの型の大きさの最大値にパディングなどを足したものとなります。
結果としてメモリーを節約することができるので、複数の型のどれかを格納したいという場合にはよく用いられます。

## 実用的な例: JSONのパース

例えば[JSON](https://www.json.org/json-en.html)をパースすることを考えます。
JSONの値はオブジェクト、配列、文字列、数値、bool、nullを持つことができます。
とりあえず最もわかりやすく表現するデータ構造を考えると次のようになります。

```cpp
#include <map>
#include <string>
#include <vector>
#include <iostream>
template <class T>
void destroy_at(T* location)
{
    location->~T();
}
struct value {
    enum class kind {
        null,
        object,
        array,
        string,
        number,
        boolean
    };
    kind k_;
    union data {
        bool b_;
        double num_;
        std::string str_;
        std::vector<value> arr_;
        std::map<std::string, value> obj_;
        data() : b_{} {}
        ~data() {}
    } data_;
    value()  : k_() {}
    value(std::string s) : k_(kind::string)
    {
        new(&data_.str_) std::string(std::move(s));
    }
    ~value()
    {
        switch(k_) {
        case kind::object:
            destroy_at(&data_.obj_); break;
        case kind::array:
            destroy_at(&data_.arr_); break;
        case kind::string:
            destroy_at(&data_.str_); break;
        default:
            break;
        }
    }
    kind get_kind() { return k_; }
    std::string get_string_or(std::string default_value)
    {
        return (k_ == kind::string) ? data_.str_ : default_value;
    }
};
int main()
{
    value v1;
    std::cout << static_cast<int>(v1.get_kind()) << v2.get_string_or("bbb") << std::endl;
    value v2("aaa");
    std::cout << static_cast<int>(v2.get_kind()) << v2.get_string_or("bbb") << std::endl;
}
```

共用体にどんなデータが入っているかを別途変数で持っておき、読み出す時に条件分岐して処理するというのが一般的な扱いです。上の例では `value` クラスの中に `kind` という列挙型を定義してその型の変数 `k_` も定義しました。この `k_` に今なんのデータが共用体に入っているかを記録し、共用体にアクセスするときはこの `k_` を確認してからアクセスします。

## アクティブな共用体のメンバ変数

共用体のあるメンバ変数にデータを入れたとき、そのメンバ変数の寿命が開始しアクティブになります。

別のメンバ変数にデータを入れるとそれまでアクティブだったメンバー変数の寿命が尽き、新たにデータが入ったメンバー変数の寿命が開始しアクティブになります。

アクティブになることができるメンバ変数は最大で1つまでです。

```cpp
union A { int x; int y[4]; };
struct B { A a; };
union C { B b; int k; };
int f() {
  C c;                  // どの共用体のメンバの寿命も開始しない
  c.b.a.y[3] = 4;       // OK: c.bとc.b.a.yの寿命が開始してオブジェクトが作られる
  return c.b.a.y[3];    // OK: c.b.a.yは作られたオブジェクトを指す
}
struct X { const int a; int b; };
union Y { X x; int k; };
int g() {
  Y y = { { 1, 2 } };   // OK: y.x はアクティブな共用体のメンバ
  int n = y.x.a;
  y.k = 4;              // OK: y.xの寿命が尽き、y.kの寿命が開始、y.kはアクティブな共用体のメンバ
  y.x.b = n;            // undefined behavior: Xのデフォルトコンストラクタは削除されています
                        // したがってy.xの寿命は暗黙のうちに開始できません
}
union Z {
    int int_value;
    char char_value[4];
};
int main()
{
    f();
    g();
    Z z;// どの共用体のメンバの寿命も開始しない
    z.int_value = 65535;// OK: z.int_valueの寿命が開始してオブジェクトが作られる
    z.char_value[0];    // NG: z.char_valueの寿命は開始していない
}
```

!!! error "C++には存在しないtrap representation"
    C言語のC99以降にはtrap representationと言われる仕様があります。上の例でいう共用体 `Z` をみたとき、 `z.char_value[0]` のようなアクセスをすると新しい型のオブジェクト表現として再解釈されるというものです。しかしながらC++には存在しません。よくある誤りなので、共用体に値を入れたらその入れたものからだけ読み取るように注意しましょう。
