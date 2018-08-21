# Hello, World!

Visual Studio Code 上で `main.cc` というファイルを作成して
下記のようなソースコードを作成します。

!!! example "main.cc"
    ```cpp linenums="1"
    #include <iostream>

    int main() {
        std::cout << "Hello, World!" << std::endl;

        return 0;
    }
    ```

msys2 のターミナルを起動して下記コマンドを打ってコンパイルします。

```bash
$ g++ main.cc
```

成功すると `a.exe` というファイルができていると思います。
これが実行ファイルになるので、実行すると `Hello, World!` という
メッセージが表示されます。

```bash
$ ./a.exe
Hello, World!
```
