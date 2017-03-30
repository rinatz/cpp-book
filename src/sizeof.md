# sizeof

`sizeof` は型のサイズを得るために使用する演算子です。
使い方は次のとおりです。

```cpp
#include <cstddef>

int x = 5;
size_t size = sizeof(x);
```

`sizeof` は型のバイトサイズを返します。
GCC では `int` は 32 ビットなので `sizeof(x)` は 4 となります。
`size_t` というのはサイズを表すための整数型です。
使用するには `#include <cstddef>` を記述する必要があります。

`sizeof` には変数名でも型名でも渡すことができます。

```cpp
sizeof(x);
sizeof(int);
```

どちらも意味は同じですが、変数名を渡すほうが好まれます。
