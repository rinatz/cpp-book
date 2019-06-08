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

以下のコードでブレークポイントの使い方を説明します。

```cpp tab="main.cc" linenums="1"
#include <iostream>

#include "sum.h"

int main() {
    std::cout << Sum(1, 2) << std::endl;
    return 0;
}
```

```cpp tab="sum.h" linenums="1"
#ifndef SUM_H_
#define SUM_H_

int Sum(int a, int b);

#endif  // SUM_H_
```

```cpp tab="sum.cc" linenums="1"
#include "sum.h"

int Sum(int a, int b) {
    return a + b;
}
```

### 追加

`break ファイル:行番号` または `break 関数名` でブレークポイントを追加します。

```gdb
(gdb) break main.cc:6
Breakpoint 1 at 0x10040108d: file main.cc, line 6.
(gdb) break Sum
Breakpoint 2 at 0x10040113a: file sum.cc, line 4.
```

`break` は `b` と省略することもできます。

```gdb
(gdb) b main.cc:6
Breakpoint 1 at 0x10040108d: file main.cc, line 6.
(gdb) b Sum
Breakpoint 2 at 0x10040113a: file sum.cc, line 4.
```

### 一覧の確認

`info break` でブレークポイントの一覧を確認することができます。

```gdb
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

`info` は `i` と省略できます。

```gdb
(gdb) i b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

### プログラムの一時停止

ブレークポイントを追加した状態でデバッグを開始すると、
ブレークポイントに到達した時点でプログラムが一時停止します。

```gdb
(gdb) run
Starting program: a.exe
[New Thread 10676.0x3cf8]
[New Thread 10676.0x1ab8]
[New Thread 10676.0x17e4]
[New Thread 10676.0x1494]
[New Thread 10676.0x36a4]

Thread 1 "a" hit Breakpoint 1, main () at main.cc:6
6           std::cout << Sum(1, 2) << std::endl;
```

### プログラムの再開

`continue` でプログラムを再開することができます。
次のブレークポイントに到達すると再び一時停止します。

```gdb
(gdb) continue
Continuing.

Thread 1 "a" hit Breakpoint 2, Sum (a=1, b=2) at sum.cc:4
4           return a + b;
```

### 削除

`delete n` でブレークポイントを削除することができます。
`n` には `info break` の `Num` の値で指定します。

```gdb
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
(gdb) delete 1
(gdb) info break
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

`delete` は `d` と省略できます。

```gdb
(gdb) i b
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
(gdb) d 1
(gdb) i b
Num     Type           Disp Enb Address            What
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
```

`delete` で対象を指定しない場合にはすべてのブレークポイントを削除します。

```gdb
(gdb) info break
Num     Type           Disp Enb Address            What
1       breakpoint     keep y   0x000000010040108d in main() at main.cc:6
2       breakpoint     keep y   0x000000010040113a in Sum(int, int) at sum.cc:4
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

## ステップ実行

### ステップオーバー

`next` でステップオーバーします。
ステップオーバーは現在の行から次の行に処理がある行まで進める処理です。

```gdb
(gdb) break main
(gdb) run

Thread 1 "a" hit Breakpoint 1, main () at main.cc:24
warning: Source file is more recent than executable.
24              Triangle t(1, 3.0, 4.0, 5.0);
(gdb) next
25              std::cout << Area(t) << std::endl;
(gdb) next
-nan
26              return 0;
```

`next` は `n` と省略できます。

```gdb
(gdb) b main
(gdb) r

Thread 1 "a" hit Breakpoint 1, main () at main.cc:24
warning: Source file is more recent than executable.
24              Triangle t(1, 3.0, 4.0, 5.0);
(gdb) n
25              std::cout << Area(t) << std::endl;
(gdb) n
-nan
26              return 0;
```

### ステップイン

`step` でステップインします。
ステップオーバーは現在の処理から次の処理まで進める処理です。
関数呼び出しの場合に関数の内部で停止します。

```gdb
(gdb) break main.cc:25
(gdb) run

Thread 1 "a" hit Breakpoint 1, main () at main.cc:25
warning: Source file is more recent than executable.
25              std::cout << Area(t) << std::endl;
(gdb) step
Area (t=...) at main.cc:14
14              double a = t.sides[1];
```

`step` は `s` と省略できます。

```gdb
(gdb) b main.cc:25
(gdb) r

Thread 1 "a" hit Breakpoint 1, main () at main.cc:25
warning: Source file is more recent than executable.
25              std::cout << Area(t) << std::endl;
(gdb) s
Area (t=...) at main.cc:14
14              double a = t.sides[1];
```

### ステップアウト

`finish` でステップアウトします。
ステップアウトは現在の関数が終了して呼び出し元に戻るまで進める処理です。

```gdb
(gdb) break Area
(gdb) run

Thread 1 "a" hit Breakpoint 1, Area (t=...) at main.cc:14
warning: Source file is more recent than executable.
14              double a = t.sides[1];
(gdb) finish
Run till exit from #0  Area (t=...) at main.cc:14
0x0000000100401192 in main () at main.cc:25
25              std::cout << Area(t) << std::endl;
Value returned is $1 = -nan(0x8000000000000)
```

`finish` は `fin` と省略できます。

```gdb
(gdb) b Area
(gdb) r
Starting program: /d/msys2/a.exe
[New Thread 1904.0x30cc]
[New Thread 1904.0x2efc]
[New Thread 1904.0x12a8]
[New Thread 1904.0xb8c]
[New Thread 1904.0x2100]

Thread 1 "a" hit Breakpoint 1, Area (t=...) at main.cc:14
warning: Source file is more recent than executable.
14              double a = t.sides[1];
(gdb) fin
Run till exit from #0  Area (t=...) at main.cc:14
0x0000000100401192 in main () at main.cc:25
25              std::cout << Area(t) << std::endl;
Value returned is $1 = -nan(0x8000000000000)
```

<!-- TODO
## スタック
(gdb) backtrace
(gdb) up
(gdb) down
(gdb) frame 3

## 条件付きブレークポイント
(gdb) condition 2 x==0 # Add break condition x==0 for break point 2
(gdb) condition 2 # Clear break condition
(gdb) catch throw # catch point

## ウォッチポイント
(gdb) watch i==0  # watch point / break when i==0 becomes not satisfied

## その他便利なもの
(gdb) set print pretty
(gdb) set pagination off
(gdb) shell
-->
