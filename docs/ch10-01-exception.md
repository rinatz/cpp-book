# 例外処理

<!-- TODO: デストラクタから例外を出さないことを記載

例外を throw して catch されるまでの間に
さらに例外を throw すると std::terminate が呼ばれる。

http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf

> 15.5.1  Thestd::terminate()function

例外発生時にもデストラクタが呼ばれるため、
デストラクタから外部へ例外を出すと上記に該当して std::terminate が呼ばれる。
-->
