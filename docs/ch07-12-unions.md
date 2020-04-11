# 共用体

共用体は 1 つのポインタを複数の変数で共有できる仕組みのことです。

```cpp
union Data {
    int int_value;
    char char_value[4];
};
```

上記の定義は構造体とよく似ていますが、`int_value` と `char_value` のポインタは同じになっており、片方の変数に代入すればもう片方の変数も値が変化します。

```cpp
Data data;
data.int_value = 65535;
data.char_value;    // {-1, -1, 0, 0}
```

上記の例だと `int_value` に代入したことで `char_value` の値も変化しています。

共用体は [reinterpret_cast] の代替として使うことができるので、こちらの説明も合わせて参考にしてください。

[reinterpret_cast]:../ch08-01-cpp-casts/#reinterpret_cast
