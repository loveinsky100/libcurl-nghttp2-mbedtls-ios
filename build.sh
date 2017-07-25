#!/bin/bash

# This script builds openssl+libcurl libraries for the Mac, iOS and tvOS 
#
# Jason Cox, @jasonacox
#   https://github.com/jasonacox/Build-OpenSSL-cURL
#

########################################
# EDIT this section to Select Versions #
########################################

MBEDTLS="2.4.0"
LIBCURL="7.51.0"
NGHTTP2="1.14.0"
CARES="1.8.0"

########################################

# HTTP2 Support?
NOHTTP2="/tmp/no-http2"
rm -f $NOHTTP2

usage ()
{
        echo "usage: $0 [-disable-http2]"
        exit 127
}

if [ "$1" == "-h" ]; then
        usage
fi

echo
echo "Building mbedtls"
cd mbedtls 
./mbedtls-build.sh "$MBEDTLS"
# echo "using darwinssl now"
cd ..

echo
echo "Building c-ares"
cd cares 
./build-c-ares.sh "$CARES"
# echo "using darwinssl now"
cd ..

if [ "$1" == "-disable-http2" ]; then
	touch "$NOHTTP2"
	NGHTTP2="NONE"	
else 
	echo
	echo "Building nghttp2 for HTTP2 support"
	cd nghttp2
	./nghttp2-build.sh "$NGHTTP2"
	cd ..
fi

echo
echo "Building Curl"
cd curl
./libcurl-build.sh "$LIBCURL"
cd ..

echo 
echo "Libraries..."
echo
echo "mbedtls [$MBEDTLS]"
xcrun -sdk iphoneos lipo -info mbedtls/lib/*.a
echo
echo "nghttp2 (rename to libnghttp2.a) [$NGHTTP2]"
xcrun -sdk iphoneos lipo -info nghttp2/lib/*.a
echo
echo "libcurl (rename to libcurl.a) [$LIBCURL]"
xcrun -sdk iphoneos lipo -info curl/lib/*.a

echo
ARCHIVE="archive/libcurl-$LIBCURL-openssl-$OPENSSL-nghttp2-$NGHTTP2"
echo "Creating archive in $ARCHIVE..."
mkdir -p "$ARCHIVE"
cp curl/lib/*.a $ARCHIVE
cp mbedtls/lib/*.a $ARCHIVE
cp nghttp2/lib/*.a $ARCHIVE
echo "Archiving Mac binaries for curl and openssl..."
mv /tmp/curl $ARCHIVE
mv /tmp/openssl $ARCHIVE
$ARCHIVE/curl -V

rm -f $NOHTTP2
