# 標準出力と標準エラー出力

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