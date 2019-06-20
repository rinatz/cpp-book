# 動的ライブラリと動的リンク

実行に必要な処理の一部を分割して外部ファイルにしておき、実行時に結合することができます。
これはビルド時に依存関係の設定だけを行い、実行時に解決することで実現されます。
この外部ファイルを動的ライブラリといい、
そのファイルをリンクして依存関係を設定することを動的リンクといいます。

次のコードで説明します。

```cpp linenums="1" tab="main.cc"
int Add(int a, int b);
int Sub(int a, int b);

int main() {
    Add(1, 2);
    Sub(3, 4);
    return 0;
}
```

```cpp linenums="1" tab="add.cc"
int Add(int a, int b) {
    return a + b;
}
```

```cpp linenums="1" tab="sub.cc"
int Sub(int a, int b) {
    return a - b;
}
```

## GCC の場合

`add.cc` と `sub.cc` をコンパイルして生成される
2つのオブジェクトファイル `add.o` と `sub.o` から
動的ライブラリ `libutil.so` を作成するには下記コマンドを実行します。

```bash
$ g++ -std=c++11 -shared -o libutil.so add.o sub.o
```

`-shared` をつけることで動的ライブラリの生成が行われます。
生成する動的ライブラリのファイル名は `-o` で指定します。

`libutil.so` を動的リンクしてリンクを行うには下記コマンドを実行します。

```bash
$ g++ -std=c++11 main.o libutil.so
```

動的ライブラリの子依存関係は `ldd` コマンドで確認できます。

```bash
$ ldd a.exe
        ntdll.dll => /c/WINDOWS/SYSTEM32/ntdll.dll (0x7ffa5c1c0000)
        KERNEL32.DLL => /c/WINDOWS/System32/KERNEL32.DLL (0x7ffa5b090000)
        KERNELBASE.dll => /c/WINDOWS/System32/KERNELBASE.dll (0x7ffa58db0000)
        libutil.so => /home/sample-user/libutil.so (0x559ab0000)
        msys-2.0.dll => /usr/bin/msys-2.0.dll (0x180040000)
```

依存関係は実行ファイルだけでなく動的ライブラリにも存在します。

```bash
$ ldd libutil.so
        ntdll.dll => /c/WINDOWS/SYSTEM32/ntdll.dll (0x7ffa5c1c0000)
        KERNEL32.DLL => /c/WINDOWS/System32/KERNEL32.DLL (0x7ffa5b090000)
        KERNELBASE.dll => /c/WINDOWS/System32/KERNELBASE.dll (0x7ffa58db0000)
        msys-2.0.dll => /usr/bin/msys-2.0.dll (0x180040000)
        advapi32.dll => /c/WINDOWS/System32/advapi32.dll (0x7ffa59610000)
        msvcrt.dll => /c/WINDOWS/System32/msvcrt.dll (0x7ffa59560000)
        sechost.dll => /c/WINDOWS/System32/sechost.dll (0x7ffa5c0f0000)
        RPCRT4.dll => /c/WINDOWS/System32/RPCRT4.dll (0x7ffa5be50000)
        CRYPTBASE.DLL => /c/WINDOWS/SYSTEM32/CRYPTBASE.DLL (0x7ffa57bb0000)
        bcryptPrimitives.dll => /c/WINDOWS/System32/bcryptPrimitives.dll (0x7ffa58c90000)
```

このように依存関係は子依存だけでは完結せず、連鎖して発生します。

??? question "-l オプションによるライブラリのリンク指定"
    ライブラリパスに配置されているライブラリは
    `-l` でライブラリ名称を用いてリンク指定できます。
    ライブラリパスは処理系で必要なパスがデフォルトで入っており、
    `-L` でユーザ指定パスを追加できます。
    ライブラリ名称は接頭辞 `lib` と拡張子をとったもので
    `libutil.so` や `libutil.a` なら `util` となります。

    `-l` でカレントディレクトリにある `libutil.so` を動的リンクするには次のようにします。

    ```bash
    $ g++ -std=c++11 main.o -lutil -L.
    ```

    動的ライブラリ `libutil.so` がない場合には、
    同じコマンドで静的ライブラリ `libutil.a` の静的リンクが行われます。
