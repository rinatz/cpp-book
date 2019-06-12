# 標準入出力

C++ で入出力を扱う場合は `<iostream>` ヘッダをインクルードする必要があります。


## 標準出力
`std::cout` で標準出力に対して出力します。

```cpp
#include <iostream>

std::cout << "標準出力";
```

!!! info
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

`int` などの数値型を用意することで数値の入力を読み込むことも可能です。

また、読み込み成否をif文で判定することが可能です。

```cpp
#include <iostream>

int main() {
    int x = 0;

    std::cout << "整数を入力してください: ";
    if (std::cin >> x) {
        std::cout << "入力した整数は " << x << " です。" << std::endl;
    } else {
        std::cout << "不正な入力です。" << std::endl;
    }

    return 0;
}
```

```bash
# 実行例1
整数を入力してください: 3
入力した整数は 3 です。

# 実行例2
整数を入力してください: カレー
不正な入力です。
```