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

引数リストのあとに `const` をつけることで `const` メンバ関数になります。

```cpp
class ConstMemberFunction {
 public:
    void Func() const;
};
```

`const` メンバ関数ではメンバ変数を変更することができません。

```cpp hl_lines="8" linenums="1"
class ConstMemberFunction {
 public:
    void Func() const;
    int a_;
};

void ConstMemberFunction::Func() const {
    a_ = 1;  // メンバ変数を変更するとコンパイルエラーになります
}
```

`const` メンバ関数はメンバ変数を変更しないため、
オブジェクトの状態を変化させずに呼び出すことができます。

メンバ変数を変更しないという制約を満たすため、
`const` メンバ関数から呼び出せるメンバ関数は `const` メンバ関数に限定されます。
