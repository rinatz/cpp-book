# CMake

[CMake] はコンパイラに依存しないビルド自動化ツールです。

[CMake]: https://ja.wikipedia.org/wiki/CMake

実際には CMake によってコンパイラに依存するビルド手順を生成し、
ビルドの実行はその手順を元に他のツールで行います。
たとえば CMake によって Makefile を生成して Make でビルドします。

## インストール

msys2 のターミナルを起動して下記コマンドを打ってインストールします。

```bash
$ pacman -S cmake
```

## ビルド実行

`cmake` は `CMakeLists.txt` という名前のファイルを読み込んで動作します。

`main.cc` をビルドして `a.exe` を生成する場合は
`CMakeLists.txt` というファイルを作成して次のように記述します。

```
cmake_minimum_required(VERSION 3.0)
project(sample)
add_executable(a main.cc)
```

この `CMakeLists.txt` ある状態で下記コマンドを実行すると `a.exe` がビルドされます。

```bash
$ cmake .
$ make
```

`cmake .` で `Makefile` を生成して `make` でビルドが行われます。

### out-of-source ビルド

ビルドによって生成されるファイルは
上記の方法だと `CMakeLists.txt` のあるディレクトリに配置されます。

一般に生成されるファイルはビルド用ディレクトリ配下とするのが望ましいです。
`cmake` で生成されるファイルをビルド用ディレクトリ配下にするには
次のようにビルド用ディレクトリ内で `cmake` (や `make`) を実行します。

```bash
$ mkdir -p build
$ cd build
$ cmake ..
$ make
```
