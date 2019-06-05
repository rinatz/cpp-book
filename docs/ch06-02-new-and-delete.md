# new/delete

## new

ヒープにメモリを動的に確保する場合は `new` 演算子を利用します。

```cpp
int* p1 = new int(100);  // p1 は new で確保されたメモリ領域を指すポインタ
int* p2 = new int[5];    // 配列の場合は [] を付ける
```

## delete

ヒープに動的に確保したメモリを解放する場合は `delete` 演算子を利用します。

```cpp
int* p1 = new int(100);
int* p2 = new int[5];

delete p1;    // new によって確保されたメモリを delete で解放
delete[] p2;  // 配列の場合は [] を付ける
```

`new` を利用して確保したメモリの解放を忘れるとメモリリークになります。 `new` と `delete` は必ずセットで使いましょう。

!!! Error ""
    ```cpp
    void Function() {
        int* p = new int[100000];

        // delete せずに Function() が終了すると…
    }   // int[100000] 分のメモリが解放されないままになる。
    ```