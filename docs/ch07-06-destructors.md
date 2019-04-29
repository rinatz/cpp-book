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

    void Set(int index, int value) {
        data_[index] = value;
    }

    int Get(int index) const {
        return data_[index];
    }

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

```cpp hl_lines="10 24 25 26 27"
class DynamicArray {
 public:
    DynamicArray(int size, int initial_value) {
        data_ = new int[size];
        for (auto i = 0; i < size; ++i) {
            data_[i] = initial_value;
        }
    }

    ~DynamicArray();

    void Set(int index, int value) {
        data_[index] = value;
    }

    int Get(int index) const {
        return data_[index];
    }

 private:
    int* data_;
};

DynamicArray::~DynamicArray() {
    std::cout << "DynamicArray::~DynamicArray() is called." << std::endl;
    delete[] data_;
}
```

## 継承

派生クラスのデストラクタは基底クラスのデストラクタを暗黙的に呼び出します。

!!! example "destructor_inheritance.cc"
    ```cpp hl_lines="5 6 7 22 23 24 25" linenums="1"
    #include <iostream>

    class BasicArray {
     public:
        ~BasicArray() {
            std::cout << "BasicArray::~BasicArray() is called." << std::endl;
        }

        virtual void Set(int index, int value) = 0;
        virtual int Get(int index) const = 0;
    };

    class DynamicArray : public BasicArray {
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

実行結果は以下のようになります。

```txt
1
10
DynamicArray::~DynamicArray() is called.
BasicArray::~BasicArray() is called.
```

デストラクタの実行順序は、必ず次の順序になります。

1. 派生クラスのデストラクタ
1. 基底クラスのデストラクタ

<!-- TODO: デストラクタをvirtualにする理由を記載 -->

<!-- TODO: デストラクタから例外を出さないことを記載

例外を throw して catch されるまでの間に
さらに例外を throw すると std::terminate が呼ばれる。

http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf

> 15.5.1  Thestd::terminate()function

例外発生時にもデストラクタが呼ばれるため、
デストラクタから外部へ例外を出すと上記に該当して std::terminate が呼ばれる。
-->
