# スマートポインタ

## リソースの所有権

ポインタはコピー可能なため、ポインタが指す先のリソースを複数のオブジェクトから参照することが可能です。

```cpp
int main() {
    int* a = new int(100);
    int* b = a; // b からも a と同じリソースを参照できるようにする。

    // a と b のどちらを delete するべきか？
    return 0;
}
```

動的確保したリソースを扱う場合、
誤って `delete` を忘れたり、同じリソースを複数回 `delete` したりすることを防ぐために、
どの変数がリソースの所有権（リソースを参照する権利と開放する権利）を持つのかをプログラマが細心の注意を払ってコードを書く必要があります。

このようなポインタを扱う上での危険性や負担を下げるために、 C++ ではスマートポインタという仕組みが存在します。

スマートポインタは `<memory>` ヘッダにて提供されています。

## std::shared_ptr

`std::shared_ptr` は動的確保したリソースの所有権を共有することができるスマートポインタです。
内部で所有権を持つオブジェクトの一覧を管理し、所有者がいなくなった時に自動的に `delete` する仕組みを有しています。

`std::shared_ptr` オブジェクトを生成するには、 `std::make_shared` を利用します。

```cpp
#include <iostream>
#include <memory>

int main() {
    std::shared_ptr<int> x = std::make_shared<int>(100); // int* x = new int(100); の代わり
                                                         // 所有者は1人。
    {
        std::shared_ptr<int> y = x; // 通常のポインタ同様、コピーすることで所有権が共有される
                                    // 所有者が2人に増える。
        std::cout << *y << std::endl;
    } // y が破棄されて所有者が1人になる。

    std::cout << *x << std::endl;

    return 0;
} // 所有者が0人になるので、 x のデストラクタで自動的に delete が行われる。
```

## std::unique_ptr

`std::unique_ptr` は、 `std::shared_ptr` と違い、コピーが出来ません。
そのため、確保したリソースの所有者が常に1人になります。

```cpp
#include <iostream>
#include <memory>

int main() {
    std::unique_ptr<int> x(new int(100));
    // std::unique_ptr<int> y = x; // コピー出来ない。コンパイルエラー。

    std::cout << *x << std::endl;

    return 0;
} // x が所有しているリソースが解放される。
```

所有権の共有はできませんが、`std::move` を使うことで所有権の移動は出来ます。このことで `std::shared_ptr` よりも軽快に動作します。

```cpp
#include <iostream>
#include <memory>

int main() {
    std::unique_ptr<int> x(new int(100));
    std::unique_ptr<int> y(std::move(x)); // ムーブは出来るため、所有権の移動は可能。
                                          // 所有権を移動したため、x は何も所有していない。

    std::cout << *y << std::endl;

    return 0;
} // y が所有しているリソースが解放される。
```

## std::auto_ptr

`std::auto_ptr` は C++11 では非推奨となっており C++17 では削除されているため使用しないでください。

詳細は [std::auto_ptr - cppreference.com][cppreference_auto_ptr] を参照してください。

[cppreference_auto_ptr]: https://ja.cppreference.com/w/cpp/memory/auto_ptr


## std::weak_ptr

`std::weak_ptr` は普段使うことは有りませんが、 `std::shared_ptr` を使う時に循環参照するような場合で `std::shared_ptr` のリソースの所有権を持つことなく、
そのリソースを監視する（弱参照）ことが出来るスマートポインタとして `std::weak_ptr` があります。
`lock()` を使うことで、監視している `std::shared_ptr` のリソースが有効な場合、
監視先とリソースを共有する `std::shared_ptr` が取得できます。

```cpp
#include <iostream>
#include <memory>

int main() {
    std::shared_ptr<int> sp = std::make_shared<int>(246);
    std::weak_ptr<int> wp = sp; // sp を監視対象として wp に登録する

    std::shared_ptr<int> sp2 = wp.lock(); // 有効な場合は sp とリソースを共有する sp2 が作られる
    if (sp2) {
        std::cout << *sp2 << std::endl;
    } else {
        std::cout << "リソースは解放済み" << std::endl;
    }

    return 0;
}
```
