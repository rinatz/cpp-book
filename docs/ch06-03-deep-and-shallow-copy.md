# ディープコピーとシャローコピー

## ディープコピー
C++ のコピーは基本的にはディープコピーと呼ばれるものです。

ディープコピーは実体ごとコピーされるため、コピーした分のメモリ領域の確保が必要になります。
ディープコピーの場合、コピー先（or コピー元）のオブジェクトを編集しても、他方のオブジェクトには影響を及ぼしません。

```cpp
int x = 100;
int y = x; // x を y へディープコピー（図1）
y = 50; // y を 50 に書き換える（図2）
std::cout << x << std::endl; // x は100のまま
```

!!! info "図1"
    ![図1][deep_copy_a]

!!! info "図2"
    ![図1][deep_copy_b]


## シャローコピー

ポインタをコピーする場合はシャローコピーになります。

シャローコピーではポインタの向き先だけがコピーされ、実体はコピー元の領域のままなので、
ディープコピーのようなコピーした分のメモリの確保は起きません。

参照の場合も、ポインタと同様にシャローコピーになります。

```cpp
int* x = new int(100);
int* y = x; // x を y へシャローコピー（図3）
*y = 50; // y が指す先の値を 50 に書き換える（図4）
std::cout << *x << std::endl; // x が指す先の値も 50 になる
```

!!! info "図3"
    ![図3][shallow_copy_a]

!!! info "図4"
    ![図4][shallow_copy_b]

[deep_copy_a]: img/deep_copy_a.svg
[deep_copy_b]: img/deep_copy_b.svg
[shallow_copy_a]: img/shallow_copy_a.svg
[shallow_copy_b]: img/shallow_copy_b.svg