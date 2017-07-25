#!/bin/bash
echo "Cleaning Build-OpenSSL-cURL"
rm -rf curl/curl-* curl/include curl/lib 
rm -rf nghttp2/Mac nghttp2/iOS nghttp2/tvOS nghttp2/lib
rm -rf cares/c-ares-* cares/lib cares/include
