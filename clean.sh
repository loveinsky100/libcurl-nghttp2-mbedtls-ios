#!/bin/bash
echo "Cleaning Build-OpenSSL-cURL"
rm -rf curl/curl-* curl/include curl/lib 
rm -rf nghttp2/Mac nghttp2/iOS nghttp2/tvOS nghttp2/lib nghttp2/nghttp2-*.tar.gz
rm -rf cares/c-ares-* cares/lib cares/include
rm -rf mbedtls/bin mbedtls/include mbedtls/lib mbedtls/src mbedtls/mbedtls-*.tar.gz
