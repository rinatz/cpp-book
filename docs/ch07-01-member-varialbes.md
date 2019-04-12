# メンバ変数

C++ でメンバ変数を使用する方法について説明します。

`int` 型の変数 `x` と `std::string` 型の文字列 `s` をもつクラス
を宣言するには次のようにします。

```cpp
class MemberVariable {
 public:
    int x;
    std::string s;
};
```

メンバ変数を参照するには `.` を使用します。

```cpp
MemberVariable m;
m.x = 5;
m.s = "Hello";
```
