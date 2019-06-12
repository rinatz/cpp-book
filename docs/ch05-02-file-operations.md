# ファイル操作

`<fstream>` に用意されているクラスを使うことでファイルの操作が出来ます。

## ファイル読み込み

ファイルを読み込む場合は `std::ifstream` を使います。
`<string>` に用意されている `std::getline` で1行ずつ読み込むことが出来ます。

```cpp tab="main.cc"
#include <fstream>
#include <iostream>
#include <string>

int main() {
    std::ifstream file("file.txt");  // 読み込むファイルのパスを指定
    std::string line;

    while (std::getline(file, line)) {  // 1行ずつ読み込む
        std::cout << line << std::endl;
    }

    return 0;
}
```

```tab="file.txt"
Good friend, for Jesus' sake forbear,
To dig the dust enclosed here.
Blest be the man that spares these stones,
And cursed be he that moves my bones.
```

```tab="実行結果"
Good friend, for Jesus' sake forbear,
To dig the dust enclosed here.
Blest be the man that spares these stones,
And cursed be he that moves my bones.
```

## ファイル書き出し

ファイルへ書き出す場合は `std::ofstream` を使います。

```cpp tab="main.cc"
#include <fstream>
#include <iostream>
#include <string>
#include <vector>

int main() {
    std::ofstream file("fruits.txt");  // 書き出すファイルのパスを指定
    std::vector<std::string> fruits = { "apple", "strawberry", "pear", "grape" };

    for (const auto fruit : fruits) {
        file << fruit << std::endl;  // 書き出し
    }

    return 0;
}
```

```tab="プログラム実行後のfruits.txt"
apple
strawberry
pear
grape

```

書き出す前に、既に同名のファイルが存在していた場合、中身は上書きされます。
上書きせずに追記する場合は、コンストラクタの引数に `std::ios::app` を追加します。

```cpp tab="main.cc" hl_lines="6"
#include <fstream>
#include <iostream>
#include <string>

int main() {
    std::ofstream file("file.txt", std::ios::app);
    std::string quotation("--- William Shakespeare's Epitaph");

    file << std::endl << quotation;

    return 0;
}
```

```tab="プログラム実行前のfile.txt"
Good friend, for Jesus' sake forbear,
To dig the dust enclosed here.
Blest be the man that spares these stones,
And cursed be he that moves my bones.
```

```tab="プログラム実行後のfile.txt"
Good friend, for Jesus' sake forbear,
To dig the dust enclosed here.
Blest be the man that spares these stones,
And cursed be he that moves my bones.
--- William Shakespeare's Epitaph
```