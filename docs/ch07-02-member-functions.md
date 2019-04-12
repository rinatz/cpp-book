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

## メンバ関数の定義

クラス宣言と同時に定義するには次のようにします。

```cpp
class MemberFunction {
 public:
    void Func() {
       std::cout << "member function" << std::endl;
    }
};
```

クラス宣言とは別に定義するには次のようにします。

```cpp
class MemberFunction {
 public:
    void Func();
};

void MemberFunction::Func() {
   std::cout << "member function" << std::endl;
}
```

どのクラスのメンバ関数であるかを表すために `MemberFunction::` が必要になります。

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
