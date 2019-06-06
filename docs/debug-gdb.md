# GDB による CUI デバッグ

## GDB の起動

デバッグビルドされた `a.exe` をデバッグするために
下記コマンドを打って GDB を起動します。

```bash
$ gdb a.exe
```

GDB は起動時にバージョンなどの情報を出力します。

`a.exe` の読み込みに成功するとバージョンなどの情報の後に
`Reading symbols from ./a.exe...done.` のようなメッセージが出力されます。

プロンプトと呼ばれる文字列 `(gdb)` が出力されると GDB のコマンドを入力することができます。

## GDB の終了

`quit` で GDB を終了することができます。

```gdb
(gdb) quit
```

`quit` は `q` と省略できます。

```gdb
(gdb) q
```

## デバッグ開始

`run` でデバッグ対象プログラムを開始します。

```gdb
(gdb) run
```

`run` は `r` と省略できます。

```gdb
(gdb) r
```

ブレークポイントが設定されていない状態だとプログラム終了まで実行されます。

## ブレークポイント

### 追加

`break ファイル:行番号` または `break 関数名` でブレークポイントを追加します。

```gdb
(gdb) break main.cc:25
Breakpoint 1 at 0x100401186: file main.cc, line 25.
(gdb) break Area
Breakpoint 2 at 0x10040108c: file main.cc, line 14.
```

`break` は `b` と省略することもできます。

```gdb
(gdb) b main.cc:25
(gdb) b Area
```

### 一覧の確認

`info break` でブレークポイントの一覧を確認することができます。

```gdb
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000100401186 in main() at main.cc:25
2       breakpoint     keep y   0x000000010040108c in Area(Triangle const&)
                                                   at main.cc:14
```

`info` は `i` と省略できます。

```gdb
(gdb) i b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000100401186 in main() at main.cc:25
2       breakpoint     keep y   0x000000010040108c in Area(Triangle const&)
                                                   at main.cc:14
```

### プログラムの一時停止

ブレークポイントを追加した状態でデバッグを開始すると、
ブレークポイントに到達した時点でプログラムが一時停止します。

```gdb
(gdb) run

Thread 1 "a" hit Breakpoint 1, main () at main.cc:25
25              std::cout << Area(t) << std::endl;
```

### プログラムの再開

`continue` でプログラムを再開することができます。
次のブレークポイントに到達すると再び一時停止します。

```gdb
(gdb) continue
Continuing.

Thread 1 "a" hit Breakpoint 2, Area (t=...) at main.cc:14
14              double a = t.sides[1];
```

### 削除

`delete n` でブレークポイントを削除することができます。
`n` には `info break` の `Num` の値で指定します。

```gdb
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000100401186 in main() at main.cc:25
2       breakpoint     keep y   0x000000010040108c in Area(Triangle const&)
                                                   at main.cc:14
(gdb) delete 1
(gdb) info break
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x000000010040108c in Area(Triangle const&)
                                                   at main.cc:14
```

`delete` は `d` と省略できます。

```gdb
(gdb) i b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000100401186 in main() at main.cc:25
2       breakpoint     keep y   0x000000010040108c in Area(Triangle const&)
                                                   at main.cc:14
(gdb) d 1
(gdb) i b
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x000000010040108c in Area(Triangle const&)
                                                   at main.cc:14
```

`delete` で対象を指定しない場合にはすべてのブレークポイントを削除します。

```gdb
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x0000000100401186 in main() at main.cc:25
2       breakpoint     keep y   0x000000010040108c in Area(Triangle const&)
                                                   at main.cc:14
(gdb) delete
Delete all breakpoints? (y or n) y
(gdb) info break
No breakpoints or watchpoints.
```

## 値の確認

`print` で値を確認することができます。

```gdb
(gdb) break main.cc:18
(gdb) run
Thread 1 "a" hit Breakpoint 1, Area (t=...) at main.cc:18
warning: Source file is more recent than executable.
18              double s = (a + b + c) / 2.0;
(gdb) print a
$1 = 4
(gdb) print b
$2 = 5
```

`print` は `p` と省略できます。

```gdb
(gdb) b main.cc:18
Breakpoint 1 at 0x1004010da: file main.cc, line 18.
(gdb) r
Thread 1 "a" hit Breakpoint 1, Area (t=...) at main.cc:18
warning: Source file is more recent than executable.
18              double s = (a + b + c) / 2.0;
(gdb) p a
$1 = 4
(gdb) p b
$2 = 5
```

値を確認すると `$n = 値` と出力され、
この `$n` で確認した値を再利用することができます。

```gdb
(gdb) print $1
$3 = 4
```

### 任意の処理を実行

`print` で値を確認する対象は変数だけではなく、
関数呼び出しを行ってその戻り値を確認したり、任意の演算を行った結果を確認することができます。

```gdb
(gdb) print (a + b + c)
$4 = 9
```

変数の値を変更する代入なども行えてしまうため、副作用に気をつける必要があります。

```gdb
(gdb) print a
$5 = 4
(gdb) print a = 0
$6 = 0
(gdb) print a
$7 = 0
```

<!-- TODO: inline関数を呼び出せない理由 -->
