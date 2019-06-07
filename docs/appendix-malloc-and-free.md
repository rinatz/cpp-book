# malloc/free

C言語のライブラリに用意されている関数 `malloc/free` を利用して、ヒープにメモリを動的に確保/解放することも出来ます。

## malloc

ヒープにメモリを動的に確保する場合は `malloc` を利用します。

```cpp
#include <cstdlib>

int* p1 = (int*)malloc(sizeof(int));      // (型名*)malloc(確保する領域のサイズ)
int* p2 = (int*)malloc(sizeof(int) * 5);  // int[5] の領域を確保する場合
```

## free

ヒープに動的に確保したメモリを解放する場合は `free` を利用します。

```cpp
#include <cstdlib>

int* p = (int*)malloc(sizeof(int) * 5);

free(p);  // メモリの解放
```

`malloc` を利用して確保したメモリの解放を忘れるとメモリリークになります。 `malloc` と `free` は必ずセットで使いましょう。

## new/deleteとの違い

`new/delete` と違い、 `malloc/free` で生成されたオブジェクトはコンストラクタ・デストラクタの呼び出しが行われません。
プログラムが予期せぬ動作をする原因になることがあるので、基本的に `new/delete` を使用するようにしましょう。

```cpp tab="サンプルコード"
#include <cstdlib>

class MyClass {
 public:
    MyClass() {
      std::cout << "MyClass' constructor is called." << std::endl;
    }
    ~MyClass() {
      std::cout << "MyClass' destructor is called." << std::endl;
    }
};

int main() {
    std::cout << "---new/delete---" << std::endl;

    MyClass* mc1 = new MyClass();
    delete mc1;

    std::cout << "---malloc/free---" << std::endl;

    MyClass* mc2 = (MyClass*)malloc(sizeof(MyClass));
    free(mc2);

    return 0;
}

```

```tab="実行結果"
---new/delete---
MyClass' constructor is called.
MyClass' destructor is called.
---malloc/free---

```