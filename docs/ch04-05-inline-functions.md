# inline 関数

関数に `inline` をつけた関数のことを inline 関数といいます。

inline 関数は定義が同一である場合に限って、
異なるソースファイルで同一の定義をしてもいいと決められています。

=== "main.cc"

    ```cpp hl_lines="5 6 7"
    #include <iostream>

    #include "something.h"

    inline void HelloWorld() {
        std::cout << "Hello World!" << std::endl;
    }

    int main() {
        HelloWorld();
        Something();

        return 0;
    }
    ```

=== "something.h"

    ```cpp
    #ifndef SOMETHING_H_
    #define SOMETHING_H_

    void Something();

    #endif  // SOMETHING_H_
    ```

=== "something.cc"

    ```cpp hl_lines="5 6 7"
    #include "something.h"

    #include <iostream>

    inline void HelloWorld() {
        std::cout << "Hello World!" << std::endl;
    }

    void Something() {
        HelloWorld();
    }
    ```

この例では `main.cc` と `something.cc` で
定義が同一である inline 関数 `HelloWorld()` がそれぞれ存在します。

これによって inline 関数であればヘッダファイルで関数定義をしてもリンク時にエラーにはなりません。

=== "hello_world.h"

    ```cpp hl_lines="6 7 8"
    #ifndef HELLO_WORLD_H_
    #define HELLO_WORLD_H_

    #include <iostream>

    inline void HelloWorld() {
        std::cout << "Hello World!" << std::endl;
    }

    #endif  // HELLO_WORLD_H_
    ```

=== "main.cc"

    ```cpp
    #include "hello_world.h"
    #include "something.h"

    int main() {
        HelloWorld();
        Something();

        return 0;
    }
    ```

=== "something.h"

    ```cpp
    #ifndef SOMETHING_H_
    #define SOMETHING_H_

    void Something();

    #endif  // SOMETHING_H_
    ```

=== "something.cc"

    ```cpp
    #include "something.h"

    #include "hello_world.h"

    void Something() {
        HelloWorld();
    }
    ```

??? question "lnlineとインライン展開"
    しばしば `inline` 指定を関数につけるのは「関数を強制的に[インライン展開]させるための機能」と誤解されていますが誤りです。
    [インライン展開]: https://github.com/EzoeRyou/cpp17book/blob/master/035-cpp17-core-inline-variables.md
    現代のコンパイラは十分に賢いので、 `inline` はインライン展開と関係が無くなっています。
    
    したがって、ヘッダーファイルに関数を定義するときに定義は一つだけというルールを回避するためにのみ `inline` 指定は用いられます。
    
