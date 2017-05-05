# インストール

C++ を使用するためにはコンパイラをインストールする必要があります。
コンパイラは複数のベンダによって開発されており、
代表的なものには次のようなものがあります。

| コンパイラ | Linux | MacOS | Windows |
| ---------- |:-----:|:-----:|:-------:|
| GCC        | o     | o     | o       |
| Clang      | o     | o     | x       |
| Visual C++ | x     | x     | x       |

本サイトでは主要なプラットフォームで利用できる GCC を使って説明します。
C++ の開発は最も豊富にツールやライブラリが揃っている Linux で行うのが良いです。
Windows や MacOS の利用者でも Vagrant というツールを使えば
手軽に Linux 環境を構築できます。
そこで Vagrant を使って Linux の環境を整える方法を説明します。

## VirtualBox

[VirtualBox] はエミュレータの一種であり、
Windows 上で Linux を動かすといったことができるツールです。
VirtualBox のようにある OS 上で別の OS をエミュレートする仕組みを
**仮想マシン** といいます。
Vagrant は VirtualBox を必要としているためまずは下記から VirtualBox を
インストールして下さい。

https://www.virtualbox.org/

[VirtualBox]: https://www.virtualbox.org/

## Vagrant

[Vagrant] はコマンドラインで VirtualBox を操作するためのツールです。
実は VirtualBox さえあれば Linux 環境は構築できるのですが、
Vagrant を使えば構築がかなり楽になります。
Vagrant も下記からインストールして下さい。

https://www.vagrantup.com/

[Vagrant]: https://www.vagrantup.com/

## Linux の構築

適当なディレクトリで下記コマンドを実行して下さい。

    $ vagrant init boxcutter/ubuntu1404-desktop

そうすると `Vagrantfile` というファイルが生成されます。
これは Linux 環境を構築するための設定ファイルになります。
続けて次のコマンドを実行すると仮想マシンが起動します。

    $ vagrant up

## 日本語化の設定

上述のコマンドで起動した仮想マシン内の Linux は
UI が英語になっているため、日本語化してあげましょう。

**注意**

    下記の作業は仮想マシン内の Linux で行って下さい。

### 1. 日本語化パッケージのインストール

まずは下記コマンドを実行します。

    $ wget -q https://www.ubuntulinux.jp/ubuntu-ja-archive-keyring.gpg -O- | sudo apt-key add -
    $ wget -q https://www.ubuntulinux.jp/ubuntu-jp-ppa-keyring.gpg -O- | sudo apt-key add -
    $ sudo wget https://www.ubuntulinux.jp/sources.list.d/trusty.list -O /etc/apt/sources.list.d/ubuntu-ja.list
    $ sudo apt-get update
    $ sudo apt-get install -y ubuntu-defaults-ja

### 2. 日本語化

右上の歯車のアイコンから

`System settings... > Language Support`

とたどります。
ダイアログが表示されるので `install` を選択し、言語パッケージをインストールします。
パスワードを聞かれたら

    vagrant

と入力します。
終わったら、`Language` タブで `日本語` をドラッグして一番上に持っていき
`Apply System-Wide` を押します。
`Regional Formats` タブでも日本語を選択し `Apply System-Wide` を押します。

再ログインすれば日本語化されています。
再ログイン時にログインパスワードが必要になるので

    vagrant

と入力して下さい。

### 3. キーボードの設定

デスクトップ右上のキーボードのアイコンから `設定` を選択し 入力メソッド の項目に

1. キーボード - 日本語 - 日本語（かな 86）
1. Mozc

という入力メソッドがこの順に並ぶように設定してください。 
英語キーボードは削除していいです。

## 開発ツールのインストール

GCC を始めとした開発ツールをインストールします。
仮想マシン内の Linux で下記コマンドを実行します。

    $ apt-get install -y build-essential

以上で開発環境が整いました。
