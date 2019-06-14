# メンバ変数

クラスとは変数と関数を集約した型をつくるための仕組みです。

クラスが持つ変数をメンバ変数といいます。

長方形を扱う `Rectangle` クラスに
`int` 型のメンバ変数 `height` と `width` を持たせるには次のようにします。

```cpp
class Rectangle {
 public:
    int height_;
    int width_;
};
```

メンバ変数を参照するには `.` を使用します。

```cpp
Rectangle r;
r.height_ = 10;
r.width_ = 20;
```

クラスのオブジェクトをポインタで扱う場合に、メンバ変数を参照するには次のようにします。

```cpp
std::unique_ptr<Rectangle> r(new Rectangle);
(*r).height_ = 10;
(*r).width_ = 20;
```

括弧をつけずに `*r.height_` とすると意味が変わってコンパイルエラーとなります。

この記述方法は不便なため `(*r).` の代わりに `r->` と記述することができます。

```cpp
std::unique_ptr<Rectangle> r(new Rectangle);
r->height_ = 10;
r->width_ = 20;
```

??? question "コンパイルエラーになる理由"
    演算子の優先順位が原因です。

    演算子には優先順位があります。
    たとえば加算 `+` と乗算 `*` では乗算 `*` を優先することになっているため、
    `1 + 2 * 3` は `1 + (2 * 3)` と解釈されて結果は `7` になります。
    `(1 + 2) * 3)` の結果である `9` にはなりません。

    デリファレンスの `*` とメンバ変数参照の `.` では
    メンバ変数参照の `.` を優先することになっているため、
    `*r.height_` は `*(r.height_)` と解釈されます。
    しかしながら `r` の型である `std::unique_ptr<Rectangle>` には
    `height_` というメンバ変数はないためコンパイルエラーとなります。

    詳細は [C++の演算子の優先順位 - cppreference.com][cppreference_operator_precedence]
    を参照してください。

[cppreference_operator_precedence]: https://ja.cppreference.com/w/cpp/language/operator_precedence
