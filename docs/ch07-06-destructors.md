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

```
1
10
DynamicArray::~DynamicArray() is called.
BasicArray::~BasicArray() is called.
```

デストラクタの実行順序は、必ず次の順序になります。

1. 派生クラスのデストラクタ
1. 基底クラスのデストラクタ

## 仮想デストラクタ

アップキャストして基底クラスのポインタで扱う場合、
基底クラスのデストラクタだけが呼び出されて
派生クラスのデストラクタは呼び出されなくなります。

!!! failure "destructor_non_virtual.cc"
    ```cpp hl_lines="6 7 8 23 24 25 26 37" linenums="1"
    #include <iostream>
    #include <memory>

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
        std::unique_ptr<BasicArray> b(new DynamicArray(5, 1));
        std::cout << b->Get(2) << std::endl;
        b->Set(2, 10);
        std::cout << b->Get(2) << std::endl;

        return 0;
    }
    ```

この例では
派生クラス `DynamicArray` をアップキャストして
基底クラス `BasicArray` のスマートポインタで扱っています。

実行結果は以下のようになります。

```
1
10
BasicArray::~BasicArray() is called.
```

`DynamicArray` のデストラクタが呼ばれておらずメモリリークが発生してしまいます。

このような問題を防ぐために、
基底クラスのデストラクタは仮想関数にします。
派生クラスではデストラクタをオーバーロードすることになるため
`override` をつけます。

!!! example "destructor_virtual.cc"
    ```cpp hl_lines="6 23" linenums="1"
    #include <iostream>
    #include <memory>

    class BasicArray {
     public:
        virtual ~BasicArray() {
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

        ~DynamicArray() override {
            std::cout << "DynamicArray::~DynamicArray() is called." << std::endl;
            delete[] data_;
        }

        void Set(int index, int value) { data_[index] = value; }

        int Get(int index) const { return data_[index]; }

     private:
        int* data_;
    };

    int main() {
        std::unique_ptr<BasicArray> b(new DynamicArray(5, 1));
        std::cout << b->Get(2) << std::endl;
        b->Set(2, 10);
        std::cout << b->Get(2) << std::endl;

        return 0;
    }
    ```

実行結果は以下のようになります。

```
1
10
DynamicArray::~DynamicArray() is called.
BasicArray::~BasicArray() is called.
```

<!-- STLコンテナの説明を事前に行う or 記述を修正する -->
!!! failure "STLコンテナクラスの継承"
    STLコンテナクラスのデストラクタは仮想関数になっていません。
    そのためSTLコンテナを継承したクラスを
    STLコンテナにアップキャストして使用してはいけません。
