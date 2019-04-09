# メンバ関数

C++ でメンバ関数を使用する方法について説明します。

メンバ関数をもつクラスは次のように宣言します。

```cpp
class MemberFunction {
 public:
    void Func();
};
```

メンバ関数を呼び出すには `.` を使用します。

```cpp
MemberFunction m;
m.Func();  // 呼び出し
```

## const メンバ関数

クラスの状態を変更しないメンバ関数は `const` メンバ関数にします。

引数リストのあとに `const` をつけることで `const` メンバ関数になります。

```cpp
class ConstMemberFunction {
 public:
    void Func() const;
};
```

`const` メンバ関数から
`const` メンバ関数ではないメンバ関数を呼び出すことはできません。

### 使用例

メンバ変数の値を変更する `SetA` と
メンバ変数の値を取得する `GetA` というメンバ関数をもつクラスは次のようにします。

```cpp
class SetterAndGetter {
 public:
    void SetA(int a) { a_ = a; }
    int GetA() const { return a_; }

 private:
    int a_;
};
```
