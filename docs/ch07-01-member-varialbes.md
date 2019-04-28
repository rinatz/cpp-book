# メンバ変数

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
