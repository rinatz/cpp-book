# デストラクタ

オブジェクトを破棄する際に呼び出されるメンバ関数をデストラクタといいます。
デストラクタはリソースの解放を行うために使用します。

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

## デストラクタを書かない

下に紹介するRAIIのためを除いてデストラクタを書く機会はありません。
なぜならばRAII技法が使われたリソース管理クラスをデータメンバに持つだけでそれらのデストラクタが自動的に呼び出されるからです。

デストラクタを定義( `= default` 指定も含む)した場合、ムーブコンストラクタ/代入演算子が自動定義されなくなり、またコピーコンストラクタ/代入演算子は自動生成されるものの非推奨(=使ってはいけない)になるので、残りの特殊メンバ関数もすべて定義するようにしましょう。

## デストラクタから例外を投げてはいけない

C++11からはデストラクタは暗黙のうちに `noexcept` 指定されます。したがってデストラクタから例外を投げてはいけません。詳しくは[例外の解説](ch10-01-exceptions.md)を参照してください。

## RAII(Resource Acquisition Is Initialization)

プログラムを書く時につきまとうのがリソースの管理です。リソースとは例えばメモリーや、ファイルポインタ、ハンドルなどが該当します。

クラス変数の寿命が尽きた時にデストラクタが呼ばれるという性質を利用して、リソースの割り当てと開放を紐付けて管理する技法があります。これをRAIIといいます。

もっとも頻繁に接するリソースであるメモリーについては[ガベージコレクション]による解決を試みる言語もありますが、その場合メモリー以外のリソースの管理に困ります。

[ガベージコレクション]: https://ja.wikipedia.org/wiki/ガベージコレクション

デストラクタを持たずに RAII を実現できる言語もありますが、一般に何らかの明示的な処理を必要とします。たとえば Python の `with` 文、C#の `using` 文などが該当します。

RAII技法を実装するクラスを作るときにはただ一つのリソースのみを管理するクラスを作ります。なぜならばコンストラクタで例外が発生したときデストラクタは呼ばれず、リソースの開放漏れが発生するからです

```cpp
// 複数のリソースを管理しようとしている→×
class inferior {
public:
    inferior() {
        data1_ = new int();
        data2_ = new int();//このnewに失敗するとdata1_は開放されない
    }
    ~inferior() noexcept {
        delete data1_;
        delete data2_;
    }
private:
    int* data1_;
    int* data2_;
};
// ただひとつのリソースを管理する
class resource {
public:
    resource() {
        data_ = new int();//このnewに失敗しても開放するべきものはない
    }
    ~resource() noexcept {
        delete data_;
    }
private:
    int* data_;
}
// RAII技法が使われただひとつのリソースを管理するクラスを複数メンバー変数として持つ→○
class good {
    resource data1_;
    resource data2_;
}
```

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
