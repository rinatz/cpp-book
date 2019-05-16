# 標準入出力

C++ で入出力を扱う場合は `<iostream>` ヘッダをインクルードする必要があります。


## 標準出力
`std::cout` で標準出力に対して出力します。

```cpp
#include <iostream>

std::cout << "標準出力";
```

!!! Info
    `std::endl` で改行を出力します。
    ```cpp
    std::cout << 1 + 2 << std::endl;
    std::cout << 3 + 4 << std::endl;
    ```
    ```bash
    # 出力結果
    3
    7
    ```

## 標準エラー出力
`std::cerr` で標準エラー出力に対して出力します。

```cpp
#include <iostream>

std::cerr << "標準エラー出力";
```

## 標準入力
`std::cin` で標準入力に対して入力します。

```cpp
#include <iostream>
#include <string>

std::cout << "好きな食べ物を入力してください: "
std::string food;
std::cin >> food;
std::cout << "好きな食べ物は " << food << " です。" << std::endl;
```

<!-- TODO: intに対して文字列の入力をした場合について -->