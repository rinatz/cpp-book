# 範囲 for

## コンテナ

イテレータを使用できるコンテナでは、
コンテナのループを次のように書くことができます。

```cpp
std::vector<int> x = {0, 1, 2, 3, 4};

for (const auto e : x) {
    std::cout << e << std::endl;
}
```

以下のように書いた場合と同じ挙動になります。

```cpp
std::vector<int> x = {0, 1, 2, 3, 4};

for (auto it = x.begin(); it != x.end(); ++it) {
    std::cout << *it << std::endl;
}
```

## 配列

配列のサイズを確定できる箇所では、
配列のループを次のように書くことができます。

```cpp
int x[] = {0, 1, 2, 3, 4};

for (auto e : x) {
    std::cout << e << std::endl;
}
```

以下のように書いた場合と同じ挙動になります。

```cpp
int x[] = {0, 1, 2, 3, 4};

for (int i = 0; i < 5; ++i) {
    std::cout << x[i] << std::endl;
}
```
