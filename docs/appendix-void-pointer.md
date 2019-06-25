# void ポインタ

型をもたないポインタを使う場合に void ポインタを使用します。
あらゆるポインタは void ポインタにすることができますが、
型が必要な場合に安全でないキャストが必要となります。

## 型の非公開

void ポインタを使用すると
型を公開せずにオブジェクトを扱うことができます。

```cpp tab="integer.h"
#ifndef INTEGER_H_
#define INTEGER_H_

void* integer_create(int v);
int integer_get(const void* instance);
void integer_destroy(void* instance);

#endif  // INTEGER_H_
```

```cpp tab="integer.cc"
#include "integer.h"

namespace {

class Integer {
 public:
    explicit Integer(int x) : x_(x) {}

    int Get() const {
        return x_;
    }

 private:
    int x_;
};

}  // namespace

void* integer_create(int v) {
    return new Integer(v);
}

int integer_get(const void* instance) {
    return reinterpret_cast<const Integer*>(instance)->Get();
}

void integer_destroy(void* instance) {
    delete reinterpret_cast<Integer*>(instance);
}
```

```cpp tab="main.cc"
#include <iostream>

#include "integer.h"

int main() {
    void* obj = integer_create(5);
    std::cout << integer_get(obj) << std::endl;
    integer_destroy(obj);
    obj = nullptr;

    return 0;
}
```

この例では `Integer` クラスを公開せずに void ポインタとして扱っています。

### static_cast によるキャスト

void ポインタはポインタの一種ですが、
`reinterpret_cast` ではなく `static_cast` でもキャストできます。

```cpp
int integer_get(const void* const instance) {
    return static_cast<const Integer* const>(instance)->Get();
}

void integer_destroy(void* instance) {
    delete static_cast<Integer*>(instance);
}
```

## C における型非依存の処理

C にはテンプレートがないため、
型に依存しない処理を行う場合にも void ポインタが使用されます。

たとえば、任意の型の配列をソートする
C の [qsort] は次のように使用します。

```cpp
#include <stdlib.h>

int cmp_int(const void *a, const void *b) {
    int a_val = *(const int *)a;
    int b_val = *(const int *)b;

    if (a_val < b_val) {
        return -1;
    }
    if (a_val > b_val) {
        return 1;
    }
    return 0;
}

int main() {
    int x[5] = {1, 5, 2, 4, 3};
    qsort(x, 5, sizeof(int), cmp_int);

    return 0;
}
```

[qsort]: https://ja.cppreference.com/w/cpp/algorithm/qsort

C++ ではこの用途で void ポインタを使用せずテンプレートを使用してください。
