# 構造体

クラスのアクセス指定子はデフォルトで `private` ですが、
デフォルトのアクセス指定子を `public` にしたものが構造体です。

`class` の代わりに `struct` とすると構造体になります。

```cpp
struct Rectangle {
    int height;
    int width;
};
```

この例では明示的にアクセス指定子は書いてありませんが、
デフォルトの値が `public` であるため次のようにメンバ変数を参照することができます。

```cpp
Rectangle r;
r.height = 10;
r.width = 20;
```

クラスと構造体の使い分けについてコーディング規約で指定されることもあります。
