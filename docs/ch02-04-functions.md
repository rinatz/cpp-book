# 関数

C++での関数の使用方法について説明します。

関数`HelloWorld()`を作成し、`main()`から呼び出して利用する場合は次のようにします。

!!! example "main.cc"
    ```cpp hl_lines="3 4 5 6 7 10" linenums="1"
    #include <iostream>

    void HelloWorld(int n) {
        for (int i = 0; i < n; ++i) {
            std::cout << "[" << i << "] " << "Hello World!" << std::endl;
        }
    }

    int main() {
        HelloWorld(10);

        return 0;
    }
    ```

ここで注目すべき点は、関数`HelloWorld()`が、呼び出されている10行目より上の行で記述されている点です。
コンパイラはソースコードを上から順に解釈しているため、コンパイラに対して`HelloWorld()`が何者なのかを事前に教えることで、`HelloWorld()`の関数呼び出しが行なえるようになります。

試しに`HelloWorld()`を`main()`よりも下の行に記述すると、コンパイルに失敗します。

!!! failure "main.cc"
    ```cpp hl_lines="4" linenums="1"
    #include <iostream>

    int main() {
        HelloWorld(10);  // ここでコンパイルエラー

        return 0;
    }

    void HelloWorld(int n) {
        for (int i = 0; i < n; ++i) {
            std::cout << "[" << i << "] " << "Hello World!" << std::endl;
        }
    }
    ```

4行目の時点では、`HelloWorld()`が何者なのかコンパイラには理解できないためです。

## プロトタイプ宣言

関数の宣言のみを呼び出し箇所よりも上の行に記述することで、関数の存在をコンパイラに教えることが出来ます。
これをプロトタイプ宣言（前方宣言）と呼びます。

!!! example "main.cc"
    ```cpp hl_lines="3" linenums="1"
    #include <iostream>

    void HelloWorld(int n);  // プロトタイプ宣言（前方宣言）

    int main() {
        HelloWorld(10);

        return 0;
    }

    void HelloWorld(int n) {
        for (int i = 0; i < n; ++i) {
            std::cout << "[" << i << "] " << "Hello World!" << std::endl;
        }
    }
    ```

`HelloWorld()`の本体は`main()`の呼び出し箇所よりも下に記述されていますが、プロトタイプ宣言があることで問題なくコンパイルできます。

## main関数
これまでのサンプルコードで度々現れた`main()`をmain関数と呼びます。

C++で生成された実行ファイルを実行すると、main関数を起点に処理が進みます。

## コマンドライン引数

main関数にも引数を渡すことが可能です。main関数に渡される引数をコマンドライン引数と呼びます。
コマンドライン引数は、プログラム実行時に実行ファイル名に続けて半角スペース区切りで複数指定することが出来ます。

```bash
# 実行ファイル名 <引数1> <引数2> <引数3> ...
$ ./a.exe XXX YYY ZZZ
```

コマンドライン引数を受け取る場合、main関数の引数は次のようにします。

```cpp
int main(int argc, char* argv[]);
```

- `int argc`: コマンドライン引数の個数を表す
- `char* argv[]`: コマンドライン引数が格納される

!!! example "main.cc"
    ```cpp linenums="1"
    #include <iostream>

    int main(int argc, char* argv[]) {
        for (int i = 0; i < argc; ++i) {
            std::cout << "argv[" << i << "]: " << argv[i] << std::endl;
        }

        return 0;
    }
    ```

```bash
# 実行結果
$ ./a.exe Hello World!
argv[0]: ./a.exe
argv[1]: Hello
argv[2]: World!
```

## オーバーロード
関数の引数の個数や型が異なる場合、同じ名前の関数を定義することが出来ます。
これを（関数の）オーバーロードと呼びます。引数の個数や型の情報を元に呼び出す関数を決定しています。

!!! example "main.cc"
    ```cpp linenums="1"
    #include <iostream>

    void Print(int x) {
        std::cout << "int: " << x << std::endl;
    }

    void Print(double x) {
        std::cout << "double: " << x << std::endl;
    }

    int main() {
        Print(2);
        Print(2.1);

        return 0;
    }
    ```

```bash
# 実行結果
$ ./a.exe
int: 2
double: 2.1
```