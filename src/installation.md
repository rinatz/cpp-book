# インストール

C++ を使用するためにはコンパイラをインストールする必要があります。
コンパイラは複数のベンダによって開発されており、
代表的なものには次のようなものがあります。

| コンパイラ | 対応 OS               |
| ---------- | --------------------- |
| GCC        | Linux, MacOS, Windows |
| Clang      | MacOS, Windows        |
| Visual C++ | Windows               |

本サイトでは主要なプラットフォームで利用できる GCC を使って説明します。
C++ の開発は最も豊富にツールやライブラリが揃っている Linux で行うのが良いです。
Windows や MacOS の利用者でも Vagrant というツールを使えば
手軽に Linux 環境を構築できます。
そこで Vagrant を使って Linux の環境を整える方法を説明します。

## VirtualBox

[VirtualBox] はエミュレータの一種であり、Windows 上で Linux を動かすといったことが
できるツールです。
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

[Vagrantfile](Vagrantfile) を `Vagrantfile` という名前でローカル保存します。
次に端末から下記コマンドを実行します。

    $ cd (Vagrantfileを保存したパス)
    $ vagrant up
