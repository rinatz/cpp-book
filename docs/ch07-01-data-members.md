# データメンバ

クラスとは変数と関数を集約した型をつくるための仕組みです。

クラスが持つ変数をデータメンバといいます。

!!! note "メンバ変数"
    データメンバのことを俗にメンバ変数と呼ぶこともありますが、
    C++ ではデータメンバという呼び方が正式な呼び方なので
    本ドキュメントもそれに従います。

長方形を扱う `Rectangle` クラスに
`int` 型のデータメンバ `height` と `width` を持たせるには次のようにします。

```cpp
class Rectangle {
 public:
    int height_;
    int width_;
};
```

データメンバを参照するには `.` を使用します。

```cpp
Rectangle r;
r.height_ = 10;
r.width_ = 20;
```

クラスのオブジェクトをポインタで扱う場合に、データメンバを参照するには次のようにします。

```cpp
Rectangle rectangle;
Rectangle* r = &rectangle;
(*r).height_ = 10;
(*r).width_ = 20;
```

括弧をつけずに `*r.height_` とすると意味が変わってコンパイルエラーとなります。

この記述方法は不便なため `(*r).` の代わりに `r->` と記述することができます。

```cpp
Rectangle rectangle;
Rectangle* r = &rectangle;
r->height_ = 10;
r->width_ = 20;
```

??? question "コンパイルエラーになる理由"
    演算子の優先順位が原因です。

    演算子には優先順位があります。
    たとえば加算 `+` と乗算 `*` では乗算 `*` を優先することになっているため、
    `1 + 2 * 3` は `1 + (2 * 3)` と解釈されて結果は `7` になります。
    `(1 + 2) * 3)` の結果である `9` にはなりません。

    デリファレンスの `*` とデータメンバ参照の `.` では
    データメンバ参照の `.` を優先することになっているため、
    `*r.height_` は `*(r.height_)` と解釈されます。
    しかしながら `r` の型である `std::unique_ptr<Rectangle>` には
    `height_` というデータメンバはないためコンパイルエラーとなります。

    詳細は [C++の演算子の優先順位 - cppreference.com][cppreference_operator_precedence]
    を参照してください。

[cppreference_operator_precedence]: https://ja.cppreference.com/w/cpp/language/operator_precedence
