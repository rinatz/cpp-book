# シグナル

シグナルとはプログラム実行中に外部から要求を通知する仕組みです。
OS からのエラー通知などで使用されます。

`<csignal>` で定義されるシグナルには以下の6種類があります。

## SIGSEGV

無効なメモリアクセス (セグメンテーション違反) を行うと発生します。

```cpp
int* x = nullptr;

// nullptr に対するデリファレンスで SIGSEGV が発生
std::cout << *x << std::endl;
```

<!-- TODO: 以下を追加
SIGFPE
SIGTERM
SIGINT
SIGILL
SIGABRT
-->
