# 動的ロードと名前マングリング

!!! info "説明に使用する環境"
    Windows の MSYS2 環境は構成が複雑なため、説明では Linux 環境を使用します。

動的ライブラリを動的リンクする代わりに、
プログラム実行中に動的ライブラリを読み込んで使用することもできます。
プログラム実行中に動的ライブラリを読み込むことを動的ロードといいます。

動的ロードは C++ の標準機能ではないため、処理系固有の処理が必要です。
Linux 環境で使用する API の詳細は
[Man page of DLOPEN - JM Project][linuxjm_dlopen] を参照してください。

[linuxjm_dlopen]: https://linuxjm.osdn.jp/html/LDP_man-pages/man3/dlopen.3.html

次のコードで説明します。

```cpp linenums="1" tab="main.cc"
#include <iostream>

#include <dlfcn.h>

int main() {
    void* handle = dlopen("libhoge.so", RTLD_NOW);
    if (handle == NULL) {
        const char* const error_message = dlerror();
        std::cerr << error_message << std::endl;
        return 1;
    }

    void* const symbol_add = dlsym(handle, "_Z3Addii");
    {
        const char* const error_message = dlerror();
        if (error_message != NULL) {
            std::cerr << error_message << std::endl;
            dlclose(handle);
            return 1;
        }
    }

    void* const symbol_sub = dlsym(handle, "_Z3Subii");
    {
        const char* const error_message = dlerror();
        if (error_message != NULL) {
            std::cerr << error_message << std::endl;
            dlclose(handle);
            return 1;
        }
    }

    auto Add = reinterpret_cast<int(*)(int, int)>(symbol_add);
    auto Sub = reinterpret_cast<int(*)(int, int)>(symbol_sub);

    std::cout << Add(1, 2) << std::endl;
    std::cout << Sub(3, 4) << std::endl;

    dlclose(handle);
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

## 動的ロード

`add.cc` と `sub.cc` をコンパイルして生成される
2つのオブジェクトファイル `add.o` と `sub.o` から
作成した動的ライブラリを `libhoge.so` とします。

Linux 環境で動的ロードを行うためには
OS が提供する `libdl.so` を動的リンクする必要があります。
`libdl.so` を動的リンクして実行ファイルをビルドするには `-ldl` をつけます。

```bash
g++ -std=c++11 main.o -ldl
```

動的ロードは以下の手順で行います。

1. 動的ライブラリを開く
1. 関数や変数のポインタを取得
1. 動的ライブラリを閉じる

### 動的ライブラリを開く

動的ライブラリを開くには `dlopen()` を使います。
動的ロードに関する処理を使うには `<dlfcn.h>` のインクルードが必要です。

```cpp
#include <iostream>

#include <dlfcn.h>

// 第1引数に動的ライブラリのファイル名を指定する
void* handle = dlopen("libhoge.so", RTLD_NOW);
if (handle == NULL) {
    const char* const error_message = dlerror();
    std::cerr << error_message << std::endl;
    return 1;
}
```

`dlopen()` でエラーが発生した場合は `NULL` が返却されます。
`dlerror()` では最後に使用された動的ロードの API でエラーがあった場合に、エラーメッセージを返却します。

動的ライブラリの探し方は動的リンクした場合と同様です。
以下のエラーメッセージが出力される場合は `export LD_LIBRARY_PATH=.` を実行してください。

```bash
$ ./a.out
libhoge.so: cannot open shared object file: No such file or directory
```

`dlopen()` が正常に終了した場合はハンドルが返却されます。
このハンドルを用いて動的ライブラリを操作します。

### 関数や変数のポインタを取得

`dlopen()` で取得したハンドルから
関数や変数のポインタを取得するには `dlsym()` を使用します。

`dlsym()` では第1引数にハンドル、第2引数にシンボル名を指定します。
シンボル名は `nm` コマンドで
オブジェクトファイルや動的ライブラリを指定して確認することができます。

```bash
$ nm add.o
0000000000000000 T _Z3Addii
$ nm sub.o
0000000000000000 T _Z3Subii
$ nm libhoge.so
0000000000200e88 d _DYNAMIC
0000000000201000 d _GLOBAL_OFFSET_TABLE_
                 w _ITM_deregisterTMCloneTable
                 w _ITM_registerTMCloneTable
                 w _Jv_RegisterClasses
0000000000000620 T _Z3Addii
0000000000000634 T _Z3Subii
00000000000006f8 r __FRAME_END__
0000000000000654 r __GNU_EH_FRAME_HDR
0000000000200e80 d __JCR_END__
0000000000200e80 d __JCR_LIST__
0000000000201020 d __TMC_END__
0000000000201020 B __bss_start
                 w __cxa_finalize
00000000000005b0 t __do_global_dtors_aux
0000000000200e78 t __do_global_dtors_aux_fini_array_entry
0000000000201018 d __dso_handle
0000000000200e70 t __frame_dummy_init_array_entry
                 w __gmon_start__
0000000000201020 D _edata
0000000000201028 B _end
0000000000000648 T _fini
00000000000004e0 T _init
0000000000201020 b completed.7594
0000000000000520 t deregister_tm_clones
00000000000005f0 t frame_dummy
0000000000000560 t register_tm_clones
```

この例では
`int Add(int a, int b)` は `_Z3Addii`、
`int Sub(int a, int b)` は `_Z3Subii` というシンボル名になっていることがわかります。

`dlsym()` で `int Add(int a, int b)` の関数ポインタを取得するには次のようにします。

```cpp
// 第1引数にハンドル、第2引数にシンボル名を指定
void* const symbol_add = dlsym(handle, "_Z3Addii");
{
    const char* const error_message = dlerror();
    if (error_message != NULL) {
        std::cerr << error_message << std::endl;
        dlclose(handle);
        return 1;
    }
}
```

`dlsym()` が正常に終了した場合にはそのシンボルのポインタが返却されます。
シンボルが関数なら関数ポインタとなります。

`dlsym()` でエラーが発生した場合は `NULL` が返却されますが、
正常に終了した場合の結果が `NULL` になることもあるため、エラーの有無は直後の `dlerror()` の結果で判断します。
`dlerror()` は最後に使用された動的ロードの API でエラーがなければ `NULL` を返却します。

`dlsym()` の戻り値は `void*` でそのまま使用できないためキャストが必要です。
関数であれば以下のようにキャストして使用します。

```cpp
auto Add = reinterpret_cast<int(*)(int, int)>(symbol_add);
std::cout << Add(1, 2) << std::endl;
```

### 動的ライブラリを閉じる

開いた動的ライブラリは使用が終わったら閉じる必要があります。
動的ライブラリを閉じるには `dlclose()` を使用します。

```cpp
dlclose(handle);
```

## 名前マングリング

オブジェクトファイルでは変数や関数を名前だけで識別する必要があります。

C 言語はリンケージ指定が内部リンケージではない変数や関数を名前だけで識別していますが、
C++ は C 言語にはない以下の機能によって名前だけで識別することができません。

- クラス
- 名前空間
- テンプレート
- 関数オーバーロード

この問題を解決するために、
識別に必要な情報をすべて名前に含めるなどして生成した一意な名前を使用しています。
これを名前マングリングといいます。

`int Add(int a, int b)` が `_Z3Addii` といったシンボル名になるのは名前マングリングの結果です。

名前マングリングを行う前の情報は `c++filt` コマンドで確認することができます。

```bash
$ nm add.o
0000000000000000 T _Z3Addii
$ nm add.o | c++filt
0000000000000000 T Add(int, int)
```

名前マングリングの方法はコンパイラ依存です。
同じコンパイラであってもバージョンが異なれば、名前マングリングの結果が一致する保証はありません。
具体例は [名前修飾 - コンパイラによる名前修飾の相違 - Wikipedia][name-mangling-diff] を参照してください。

[name-mangling-diff]: https://ja.wikipedia.org/wiki/名前修飾#コンパイラによる名前修飾の相違

名前マングリングを無効化することでコンパイラに依存せずにシンボル名を指定することができます。
名前マングリングを無効化するには宣言を `extern "C"` のブロックに含めます。
これは C 言語でリンク可能にするという指定で、
名前の重複を禁止する代わりに名前マングリングが行われなくなります。

```cpp
extern "C" {

int Add(int a, int b) {
    return a + b;
}

}
```

`extern "C"` のブロックで宣言された場合には、関数名がそのままシンボル名として使用されます。

```bash
$ nm add.o
0000000000000000 T Add
```

`dlsym()` も次のように関数名を指定することになります。

```cpp
void* const symbol_add = dlsym(handle, "Add");
```
