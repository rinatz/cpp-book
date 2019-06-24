# inline 関数

関数に `inline` をつけると
コンパイラに [インライン展開] するように指示することができます。
この指示をした関数のことを inline 関数といいます。

[インライン展開]: https://ja.wikipedia.org/wiki/インライン展開

実際にインライン展開をするかどうかはコンパイラの判断次第です。
`inline` をつけてもインライン展開されないことや、
`inline` をつけなくてもインライン展開されることがあります。

inline 関数は定義が同一である場合に限って、定義が複数存在してもいいと決められています。
これによって inline 関数であればヘッダファイルで関数定義をしてもリンク時にエラーにはなりません。

```cpp tab="hello_world.h"
#ifndef HELLO_WORLD_H_
#define HELLO_WORLD_H_

#include <iostream>

inline void HelloWorld() {
    std::cout << "Hello World!" << std::endl;
}

#endif  // HELLO_WORLD_H_
```

```cpp tab="main.cc"
#include "hello_world.h"
#include "something.h"

int main() {
    HelloWorld();
    Something();

    return 0;
}
```

```cpp tab="something.h"
#ifndef SOMETHING_H_
#define SOMETHING_H_

void Something();

#endif  // SOMETHING_H_
```

```cpp tab="something.cc"
#include "something.h"

#include "hello_world.h"

void Something() {
    HelloWorld();
}
```
