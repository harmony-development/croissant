![logo](assets/logo256.png)

# Croissant

A sweet mobile and desktop client for Harmony written in Flutter.

Original icon made by [Freepick](https://www.flaticon.com/authors/freepik) from [www.flaticon.com](www.flaticon.com)

## Building for Linux

`flutter build linux` is broken (at least on my machine), the following command can be used to build:

```sh
$ flutter build linux && (cd build/linux/x64/release && ninja)
```