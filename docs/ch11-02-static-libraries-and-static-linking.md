# 静的ライブラリと静的リンク

複数のオブジェクトファイルを1つのファイルにまとめ、
リンク時にオブジェクトファイルの代わりとして使用することができます。
複数のオブジェクトファイルをまとめたファイルを静的ライブラリといい、
そのファイルをリンクすることを静的リンクといいます。

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
静的ライブラリ `libutil.a` を作成するには下記コマンドを実行します。

```bash
$ ar rc libutil.a add.o sub.o
```

`ar` はアーカイブを操作するコマンドです。
`rc` でアーカイブを作成してファイルを追加するという指定をします。

作成したアーカイブの内容は下記コマンドで確認できます。

```bash
$ ar t libutil.a
add.o
sub.o
```

`libutil.a` を静的リンクするには下記コマンドを実行します。

```bash
$ g++ -std=c++11 main.o libutil.a
```
