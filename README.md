使用build.sh编译

支持http2.0，支持ipv6，支持https

脚本使用mbedtls的原因是openssl打出的静态库过于庞大，使用mbedtls构建出的静态库大小大约是openssl的1/4

当然如果不需要http2.0，则可以使用darwin-ssl

修改版本：

    MBEDTLS="2.4.0"
    LIBCURL="7.51.0"
    NGHTTP2="1.14.0"

脚本最低支持ios为ios7，如果需要修改，请到相应目录下的shell脚本中修改。

相关链接：

[https://github.com/jasonacox/Build-OpenSSL-cURL.git](https://github.com/jasonacox/Build-OpenSSL-cURL.git)
[https://github.com/mingxinkejian/mbedtls-for-ios.git](https://github.com/mingxinkejian/mbedtls-for-ios.git)