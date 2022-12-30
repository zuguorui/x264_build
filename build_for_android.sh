#!/bin/bash

SOURCE_PATH=/Users/zuguorui/work_space/x264

API=26
NDK=/Users/zuguorui/Library/Android/sdk/ndk/21.4.7075529
HOST_TAG=darwin-x86_64
TOOLCHAIN=$NDK/toolchains/llvm/prebuilt/$HOST_TAG
SYSROOT=$TOOLCHAIN/sysroot

INSTALL_PATH="$(pwd)/android"


rm -r $INSTALL_PATH

cd $SOURCE_PATH

function build_android_arm
{
echo ">>>>>>>>>>>>>>>>>>>>>> build for android $CPU <<<<<<<<<<<<<<<<<<<<<<"

make clean

./configure \
--prefix="$INSTALL_PATH/$CPU" \
--host=$HOST \
--enable-shared \
--disable-static \
--disable-cli \
--disable-asm \
--enable-pic \
--extra-cflags="$CFLAGS" \
--prefix="$INSTALL_PATH/$CPU" \
--sysroot="$SYSROOT" \
--cross-prefix="$CROSS_PREFIX"

make -j8

HEADER_PATH=$INSTALL_PATH/$CPU/include
mkdir -p $HEADER_PATH

LIB_PATH=$INSTALL_PATH/$CPU/lib
mkdir -p $LIB_PATH

mv x264_config.h $HEADER_PATH
cp x264.h $HEADER_PATH

mv libx264.so $LIB_PATH
mv x264.pc $LIB_PATH

# make install
echo ">>>>>>>>>>>>> building for android $CPU completed <<<<<<<<<<<<<<<<<<<"
}

# armv7
CPU=armv7-a
HOST=arm-linux
CROSS_PREFIX=$TOOLCHAIN/bin/arm-linux-androideabi-
CFLAGS="-march=$CPU -O2 -mfloat-abi=softfp -mfpu=neon -fPIC"
export CC=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang
export CXX=$TOOLCHAIN/bin/armv7a-linux-androideabi$API-clang++
build_android_arm

# armv8
CPU=armv8-a
HOST=arm-linux
CROSS_PREFIX=$TOOLCHAIN/bin/aarch64-linux-android-
CFLAGS="-march=$CPU -O2 -fPIC"
export CC=$TOOLCHAIN/bin/aarch64-linux-android$API-clang
export CXX=$TOOLCHAIN/bin/aarch64-linux-android$API-clang++
build_android_arm


