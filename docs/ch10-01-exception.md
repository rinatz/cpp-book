# 例外処理

例外処理とはプログラム実行中にエラーが発生した場合に、
後続の処理を行うのをやめてエラー発生時用の処理を行うための機能です。

例外処理においてエラーを表すもの例外といいます。
例外処理は次の2つの段階で構成されます。

1. エラーが発生する箇所で例外を送出し、後続の処理を行うのをやめる
1. 送出された例外を捕捉し、エラー発生時用の処理を行う

正の整数を表す `std::string` を `int` に変換する処理において、
無効な文字があった場合に変換処理をやめてエラーメッセージを出力するには
次のようにします。

```cpp hl_lines="2 18 19 23 24 25 26"
std::string str = "123XY56";
try {
    int num = 0;
    for (const auto s : str) {
        num *= 10;
        switch (s) {
            case '0':  num += 0;  break;
            case '1':  num += 1;  break;
            case '2':  num += 2;  break;
            case '3':  num += 3;  break;
            case '4':  num += 4;  break;
            case '5':  num += 5;  break;
            case '6':  num += 6;  break;
            case '7':  num += 7;  break;
            case '8':  num += 8;  break;
            case '9':  num += 9;  break;
            default:
                // コンストラクタの引数でエラーメッセージを設定
                throw std::runtime_error("数値ではない文字が入っています");
        }
    }
    std::cout << num << std::endl;  // 問題なく変換できた場合には変換後の値を出力
} catch (const std::runtime_error& e) {
    // what() でエラーメッセージを取得
    std::cout << e.what() << std::endl;
}
```

例外の送出は `throw` で行います。

この例では数値ではない文字がある場合にエラーとして
例外 `std::runtime_error` を送出し、
残っている文字の変換処理は行わずにエラー発生時用の処理を行います。

`try` ブロック内で送出した例外は `catch` ブロックで捕捉します。

この例では例外 `std::runtime_error` が送出された場合に
参照 `e` で受けて `e.what()` でエラーメッセージを取得して出力します。

## 関数から例外を送出

関数内で捕捉されない場合、
捕捉されるまで関数の呼び出し元を順に辿っていきます。

正の整数を表す `std::string` を `int` に変換する処理を関数化し、
無効な文字があった場合に関数から例外を送出するには次のようにします。

```cpp hl_lines="17"
int StringToInt(const std::string& str) {
    int num = 0;
    for (const auto s : str) {
        num *= 10;
        switch (s) {
            case '0':  num += 0;  break;
            case '1':  num += 1;  break;
            case '2':  num += 2;  break;
            case '3':  num += 3;  break;
            case '4':  num += 4;  break;
            case '5':  num += 5;  break;
            case '6':  num += 6;  break;
            case '7':  num += 7;  break;
            case '8':  num += 8;  break;
            case '9':  num += 9;  break;
            default:
                throw std::runtime_error("数値ではない文字が入っています");
        }
    }
}
```

この関数内では例外を捕捉しないため `try` ブロックがありません。

呼び出し元で捕捉するためには次のようにします。

```cpp hl_lines="2 3 5"
std::string str = "123XY56";
try {
    auto num = StringToInt(str);
    std::cout << num << std::endl;
} catch (const std::runtime_error& e) {
    std::cout << e.what() << std::endl;
}
```

例外を送出するのは呼び出す関数の内部であるため、
この `try` ブロックには `throw` がありません。

## 送出された例外が捕捉されない場合

送出された例外が捕捉されない場合、
[std::terminate][cpprefjp_terminate] が呼び出されてプログラムが異常終了します。

[cpprefjp_terminate]: https://cpprefjp.github.io/reference/exception/terminate.html

```cpp hl_lines="2"
int main() {
    std::string str = "123XY56";
    auto num = StringToInt(str);
    std::cout << num << std::endl;
    return 0;
}
```

実行結果は次のようになります。

```txt
$ ./a.out
terminate called after throwing an instance of 'std::runtime_error'
  what():  数値ではない文字が入っています
Aborted (core dumped)
```

<!-- TODO: デストラクタから例外を出さないことを記載

例外を throw して catch されるまでの間に
さらに例外を throw すると std::terminate が呼ばれる。

http://www.open-std.org/jtc1/sc22/wg21/docs/papers/2012/n3337.pdf

> 15.5.1  Thestd::terminate()function

例外発生時にもデストラクタが呼ばれるため、
デストラクタから外部へ例外を出すと上記に該当して std::terminate が呼ばれる。
-->

<!-- TODO: throwがC++17で削除されていることへの言及
https://cpprefjp.github.io/lang/cpp17/remove_deprecated_exception_specifications.html
-->
