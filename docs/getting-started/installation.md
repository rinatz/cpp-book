# インストール

## コンパイラ

C++ のコンパイラは多くのベンダが開発しています。
代表的なものには次のようなものがあります。

| コンパイラ | Linux              | macOS              | Windows            |
|------------|:------------------:|:------------------:|:------------------:|
| GCC        | :white_check_mark: | :white_check_mark: | ️:white_check_mark: |
| Clang      | :white_check_mark: | :white_check_mark: | :warning:          |
| Visual C++ |                    |                    | :white_check_mark: |

GCC は Linux をメインに使用されるコンパイラですが、
Linux 以外の主要なプラットフォームでも使用することができ、
一番実績のあるコンパイラです。
Clang は近年注目されているコンパイラで、
今後は GCC に取って代わる可能性があるコンパイラです。

本書では Windows 版の GCC をインストールします。
GCC のインストールには msys2 というツールを使用します。
msys2 は Linux で使用できるコマンドの一部を Windows に移植したツールセットであり、
msys2 の中には GCC も含まれています。

### msys2 のインストール

下記の msys2 の公式ページにアクセスしてインストーラをダウンロードします。

```
https://www.msys2.org/
```

インストーラは `msys2-i386-yyyymmdd.exe, msys2-x86_64-yyyymmdd.exe` の
2 種類がありますが、前者が 32 ビット版で後者が 64 ビット版になります。
本書では 64 ビット版をもとに説明するので、64 ビット版をインストールしてください。

## IDE

C++ 用の IDE としては Visual Studio Code が人気です。
Visual Studio Code 自体はエディタなのですが、拡張機能を入れることで
C++ 向けに使用することもできます。

下記サイトより Visual Studio Code をインストールしてください。

```
https://code.visualstudio.com/
```

Visual Studio Code の拡張機能である `C/C++` もインストールします。
Visual Studio Code を起動した後、`Ctrl+Shift+X` を押すと
拡張機能のインストール画面に切り替わるので、
`C/C++` を検索してインストールしてください。
