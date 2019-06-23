# 動的ライブラリと動的リンク

!!! info "説明に使用する環境"
    Windows の MSYS2 環境は構成が複雑なため、説明では Linux 環境を使用します。

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

`add.cc` と `sub.cc` をコンパイルして生成される
2つのオブジェクトファイル `add.o` と `sub.o` から
動的ライブラリ `libhoge.so` を作成するには下記コマンドを実行します。

```bash
$ g++ -std=c++11 -shared -o libhoge.so add.o sub.o
```

`-shared` をつけることで動的ライブラリの生成が行われます。
生成する動的ライブラリのファイル名は `-o` で指定します。

`libhoge.so` を動的リンクするには下記コマンドを実行します。

```bash
$ g++ -std=c++11 main.o libhoge.so
```

動的ライブラリの子依存関係は `ldd` コマンドで確認できます。

```bash
$ ldd a.out
        linux-vdso.so.1 =>  (0x00007ffeacf68000)
        libhoge.so => ./libhoge.so (0x00007f86f4381000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f86f3fb7000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f86f4583000)
```

`libhoge.so => not found` と出力される場合は
`export LD_LIBRARY_PATH=.` を実行してください。

```bash hl_lines="3 6 9"
$ ldd a.out
        linux-vdso.so.1 =>  (0x00007ffc49540000)
        libhoge.so => not found
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007feb00b3e000)
        /lib64/ld-linux-x86-64.so.2 (0x00007feb00f08000)
$ export LD_LIBRARY_PATH=.
$ ldd a.out
        linux-vdso.so.1 =>  (0x00007ffeacf68000)
        libhoge.so => ./libhoge.so (0x00007f86f4381000)
        libc.so.6 => /lib/x86_64-linux-gnu/libc.so.6 (0x00007f86f3fb7000)
        /lib64/ld-linux-x86-64.so.2 (0x00007f86f4583000)
```

依存関係は実行ファイルだけでなく動的ライブラリにも存在します。

```bash
$ ldd /lib/x86_64-linux-gnu/libc.so.6
        /lib64/ld-linux-x86-64.so.2 (0x00007f53f0153000)
        linux-vdso.so.1 =>  (0x00007fff235c4000)
```

このように依存関係は子依存だけでは完結せず、連鎖して発生します。

子依存がない場合は次のように出力されます。

```bash
$ ldd libhoge.so
        statically linked
```

??? question "-l オプションによるライブラリのリンク指定"
    ライブラリパスに配置されているライブラリは
    `-l` でライブラリ名称を用いてリンク指定できます。
    ライブラリパスは処理系で必要なパスがデフォルトで入っており、
    `-L` でユーザ指定パスを追加できます。
    ライブラリ名称は接頭辞 `lib` と拡張子をとったもので
    `libhoge.so` や `libhoge.a` なら `hoge` となります。

    `-l` でカレントディレクトリにある `libhoge.so` を動的リンクするには次のようにします。

    ```bash
    $ g++ -std=c++11 main.o -lhoge -L.
    ```

    動的ライブラリ `libhoge.so` がない場合には、
    同じコマンドで静的ライブラリ `libhoge.a` の静的リンクが行われます。
