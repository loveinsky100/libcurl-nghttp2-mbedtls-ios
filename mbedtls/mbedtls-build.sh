#!/bin/bash

#  Automatic build script for mbedtls
#  for iPhoneOS and iPhoneSimulator
#
#  Created by Felix Schulze on 08.04.11.
#  Copyright 2010 Felix Schulze. All rights reserved.
#  modify this script by mingtingjian on 2015_08_06
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#  http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.
#
###########################################################################
#  Change values here
#

if [ -z $1 ]; then
	VERSION="2.4.0"
else
	VERSION="$1"
fi

SDKVERSION=`xcrun -sdk iphoneos --show-sdk-version`
IOS_MIN_SDK_VERSION="7.0"
#
###########################################################################
#
# Don't change anything here
CURRENTPATH=`pwd`
ARCHS="i386 x86_64 armv7 armv7s arm64"
DEVELOPER=`xcode-select -print-path`

##########
set -e
if [ ! -e mbedtls-${VERSION}-gpl.tgz ]; then
echo "Downloading mbedtls-${VERSION}-gpl.tgz"
curl -O https://tls.mbed.org/download/start/mbedtls-${VERSION}-gpl.tgz
else
echo "Using mbedtls-${VERSION}-gpl.tgz"
fi

mkdir -p bin
mkdir -p lib
mkdir -p src

for ARCH in ${ARCHS}
do
if [[ "${ARCH}" == "i386" || "${ARCH}" == "x86_64" ]];
then
PLATFORM="iPhoneSimulator"
else
PLATFORM="iPhoneOS"
fi

tar zxvf mbedtls-${VERSION}-gpl.tgz -C src
cd src/mbedtls-${VERSION}/library

echo "Building mbedtls for ${PLATFORM} ${SDKVERSION} ${ARCH}"

echo "Patching Makefile..."
sed -i.bak '4d' ${CURRENTPATH}/src/mbedtls-${VERSION}/library/Makefile

echo "Please stand by..."

export DEVROOT="${DEVELOPER}/Platforms/${PLATFORM}.platform/Developer"
export SDKROOT="${DEVROOT}/SDKs/${PLATFORM}${SDKVERSION}.sdk"
export BUILD_TOOLS="${DEVELOPER}"
export CC="${BUILD_TOOLS}/usr/bin/gcc -arch ${ARCH}"

export LDFLAGS="-arch ${ARCH} -pipe -no-cpp-precomp -isysroot ${SDKROOT}"
export CFLAGS="-arch ${ARCH} -pipe -no-cpp-precomp -isysroot ${SDKROOT} -miphoneos-version-min=${IOS_MIN_SDK_VERSION} -I${CURRENTPATH}/src/mbedtls-${VERSION}/include"

make

cp libmbedcrypto.a ${CURRENTPATH}/bin/libmbedcrypto-${ARCH}.a
cp libmbedx509.a ${CURRENTPATH}/bin/libmbedx509-${ARCH}.a
cp libmbedtls.a ${CURRENTPATH}/bin/libmbedtls-${ARCH}.a
cp -R ${CURRENTPATH}/src/mbedtls-${VERSION}/include ${CURRENTPATH}
cp ${CURRENTPATH}/src/mbedtls-${VERSION}/LICENSE ${CURRENTPATH}/include/mbedtls/LICENSE
cd ${CURRENTPATH}
rm -rf src/mbedtls-${VERSION}

done
lipo -create ${CURRENTPATH}"/bin/libmbedtls-i386.a" ${CURRENTPATH}"/bin/libmbedtls-x86_64.a" ${CURRENTPATH}"/bin/libmbedtls-armv7.a" ${CURRENTPATH}"/bin/libmbedtls-armv7s.a" ${CURRENTPATH}"/bin/libmbedtls-arm64.a" -output ${CURRENTPATH}"/lib/libmbedtls.a"
lipo -create ${CURRENTPATH}"/bin/libmbedcrypto-i386.a" ${CURRENTPATH}"/bin/libmbedcrypto-x86_64.a" ${CURRENTPATH}"/bin/libmbedcrypto-armv7.a" ${CURRENTPATH}"/bin/libmbedcrypto-armv7s.a" ${CURRENTPATH}"/bin/libmbedcrypto-arm64.a" -output ${CURRENTPATH}"/lib/libmbedcrypto.a"
lipo -create ${CURRENTPATH}"/bin/libmbedx509-i386.a" ${CURRENTPATH}"/bin/libmbedx509-x86_64.a" ${CURRENTPATH}"/bin/libmbedx509-armv7.a" ${CURRENTPATH}"/bin/libmbedx509-armv7s.a" ${CURRENTPATH}"/bin/libmbedx509-arm64.a" -output ${CURRENTPATH}"/lib/libmbedx509.a"


echo "Build library..."



echo "Building done."