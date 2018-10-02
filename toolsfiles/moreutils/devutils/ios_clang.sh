#!/bin/sh

echo todo
exit

XCODE=/Applications/Xcode.app/Contents/Developer
SIM=${XCODE}/Platforms/iPhoneSimulator.platform/Developer/SDKs/iPhoneSimulator.sdk

ios_clang=${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang 

app_dir=$1

[ -n "$app_dir" ] || { echo "usage: <app_dir> " ; exit 1; }

app=${app_dir%.*}

app_build="$app_dir"/"$app"
rm -f "$app_build"

${XCODE}/Toolchains/XcodeDefault.xctoolchain/usr/bin/clang \
    -x objective-c \
    -arch x86_64 \
    -std=gnu99 \
    -fobjc-arc \
    -isysroot ${SIM} \
    -fobjc-abi-version=2 \
		-fno-objc-arc \
    -mios-simulator-version-min=6.0 \
    -Xlinker -objc_abi_version -Xlinker 2 \
    -fobjc-link-runtime \
    -framework CoreGraphics -framework UIKit -framework Foundation \
    *.c -o "$app_build" 

if [ "$?" -eq 0 ] ; then
   xcrun simctl install booted "$app_dir" 
else
   echo "Err build failed"
   exit 1
fi
