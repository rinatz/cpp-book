# new/delete

## new

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