# 宣言と定義

関数や変数は、宣言と定義をすることが出来ます。
宣言と定義は、区別して扱われます。

## 宣言

宣言は、型の情報や名前などのシンボルの概要を示すことです。

次のような関数があったとします。

```cpp
void HelloWorld() {
    std::cout << "Hello World!" << std::endl;
}
```

この関数の宣言は次のように書きます。

```cpp
void HelloWorld();
```

関数の `{}` の前に書いてある返り値の型・関数名・引数リストを書くだけで宣言できます。
関数の宣言は、プロトタイプ宣言と呼ばれることもあります。

宣言は重複しても問題ありません。

```cpp
void HelloWorld();  // 宣言
void HelloWorld();  // 重複してもOK
```

??? tip "変数の宣言"
    関数と違い、変数の宣言をする場合は `extern` 指定子を付与する必要があります。

    ```cpp
    extern int x;  // 宣言
    extern int x;  // 重複してもOK
    ```

    `extern` 指定子の詳細については [記憶域クラス指定子 - cppreference.com][cppreference-storage_duration] を参照してください。

[cppreference-storage_duration]: https://ja.cppreference.com/w/cpp/language/storage_duration

## 定義

定義は、シンボルの詳細を示すことです。
定義があることで、そのシンボルが具体的にどういうものなのか分かります。
定義をした場合は、合わせて宣言が行われたことにもなります。

関数の場合は、実装そのものが定義としてみなされます。

```cpp
// 関数の定義。宣言も兼ねている。
void HelloWorld() {
    std::cout << "Hello World!" << std::endl;
}
```

変数の場合は、次のように書くだけで定義がされます。

```cpp
int x;  // 変数の定義。宣言も兼ねている。
int x = 100;  // 定義をしつつ初期化。宣言も兼ねている。
```

定義は重複が許されません。
定義されたシンボルを利用する側が、どれを使えば良いのか判別できなくなるため、リンク時にエラーとなります。

```cpp
int x;
int x;  // 重複のためエラー

void HelloWorld() {
    std::cout << "Hello World!" << std::endl;
}

void HelloWorld() {  // 重複のためエラー
    std::cout << "Hello World!!!!!!" << std::endl;
}
```

宣言されたシンボルを利用するコードがある場合、定義が必要になります。
宣言のみだと、その関数や変数が具体的にどのようなものなのか分からないためです。

```cpp
void HelloWorld();  // 宣言

int main() {
    HelloWorld();  // 定義が見つからないためエラー

    return 0;
}
```