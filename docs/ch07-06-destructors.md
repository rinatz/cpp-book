# デストラクタ

オブジェクトを破棄する際に呼び出されるメンバ関数をデストラクタといいます。
デストラクタはリソースの開放を行うために使用します。

`~` にクラス名をつけた名前で戻り値がない関数がデストラクタになります。
デストラクタは引数をもちません。

```cpp hl_lines="12 13 14 15"
#include <iostream>

class DynamicArray {
 public:
    DynamicArray(int size, int initial_value) {
        data_ = new int[size];
        for (auto i = 0; i < size; ++i) {
            data_[i] = initial_value;
        }
    }

    ~DynamicArray() {
        std::cout << "DynamicArray::~DynamicArray() is called." << std::endl;
        delete[] data_;
    }

    void Set(int index, int value) { data_[index] = value; }

    int Get(int index) const { return data_[index]; }

 private:
    int* data_;
};

int main() {
    DynamicArray d(5, 1);
    std::cout << d.Get(2) << std::endl;
    d.Set(2, 10);
    std::cout << d.Get(2) << std::endl;

    return 0;
}
```

明示的に定義しない場合、
コンパイラが暗黙的にデストラクタを定義します。

## クラス宣言とは別に定義

クラス宣言とは別にデストラクタを定義するには次のようにします。

```cpp hl_lines="10 20 21 22 23"
class DynamicArray {
 public:
    DynamicArray(int size, int initial_value) {
        data_ = new int[size];
        for (auto i = 0; i < size; ++i) {
            data_[i] = initial_value;
        }
    }

    ~DynamicArray();

    void Set(int index, int value) { data_[index] = value; }

    int Get(int index) const { return data_[index]; }

 private:
    int* data_;
};

DynamicArray::~DynamicArray() {
    std::cout << "DynamicArray::~DynamicArray() is called." << std::endl;
    delete[] data_;
}
```

<!-- TODO: デストラクタをvirtualにする理由を記載 -->

<!-- TODO: デストラクタから例外を出さないことを記載

例外を throw して catch されるまでの間に
さらに例外を throw すると std::terminate が呼ばれる。

http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf

> 15.5.1  Thestd::terminate()function

例外発生時にもデストラクタが呼ばれるため、
デストラクタから外部へ例外を出すと上記に該当して std::terminate が呼ばれる。
-->
