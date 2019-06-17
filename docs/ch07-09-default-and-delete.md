# default/delete

以下のメンバ関数は暗黙的に定義されることがある特別なメンバ関数です。

- デフォルトコンストラクタ
- コピーコンストラクタ
- コピー代入演算子
- ムーブコンストラクタ
- ムーブ代入演算子
- デストラクタ

これらに対する指定として `default` 指定と `delete` 指定があります。

## default 指定

暗黙的に定義される特別なメンバ関数に `= default` をつけることで、
暗黙的に定義されるものと同じものを明示的に定義できます。

```cpp hl_lines="8"
class Square {
 public:
    explicit Square(int size) : size_(size) {}

    // デフォルトコンストラクタ以外のコンストラクタが存在するので
    // デフォルトコンストラクタの暗黙的な定義は行われない。
    // デフォルトコンストラクタを使用するために default 指定で明示的に定義
    Square() = default;

    int Area() const {
        return size_ * size_;
    }

 private:
    int size_;
};

int main() {
    Square s1;
    Square s2(10);

    return 0;
}
```

## delete 指定

暗黙的に定義される特別なメンバ関数に `= delete` をつけることで、
暗黙的に定義される特別なメンバ関数の削除を指定します。

```cpp hl_lines="7 8"
class NonCopyable {
 public:
    NonCopyable() = default;

    // 暗黙的に定義されるコピーコンストラクタとコピー代入演算子を
    // 削除することでコピー禁止クラスを実現できる
    NonCopyable(const NonCopyable&) = delete;
    NonCopyable& operator=(const NonCopyable&) = delete;
};
```
