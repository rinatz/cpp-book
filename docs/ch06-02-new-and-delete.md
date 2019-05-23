# new/delete

## new

<!-- MEMO: newの場合はfree storeに確保される. mallocの場合はheap -->

ヒープにメモリを動的に確保する場合は `new` 演算子を利用します。

```cpp
Class* p1 = new Class();  // p1 は new で確保されたメモリ領域を指すポインタ
Class* p2 = new Class[5]; // 配列の場合は [] を付ける
```

## delete

ヒープに動的に確保したメモリを開放する場合は `delete` 演算子を利用します。

```cpp
Class* p1 = new Class();
Class* p2 = new Class[5];

delete p1;   // new によって確保されたメモリを delete で解放
delete[] p2; // 配列の場合は [] を付ける
```

`new` を利用して確保したメモリの解放を忘れるとメモリリークになります。 `new` と `delete` は必ずセットで使いましょう。

!!! Error ""
    ```cpp
    int main() {
        int* p = new int[100000];
        return 0;
    } // int[100000] 分のメモリが開放されないままになる。
    ```

<!-- MEMO: コンストラクタ呼び出しの話とかはmalloc/free側に書く -->