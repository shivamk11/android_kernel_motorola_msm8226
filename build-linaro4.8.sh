#!/bin/bash
TOOLCHAIN="/home/shivam/development/toolchains/linaro-4.8-generic/bin/arm-gnueabi"
MODULES_DIR="/home/shivam/development/modules"
ZIMAGE="/home/shivam/development/android_kernel_mototola_msm8226/arch/arm/boot/zImage-dtb"
KERNEL_DIR="/home/shivam/development/android_kernel_mototola_msm8226"
BUILD_START=$(date +"%s")
if [ -a $ZIMAGE ];
then
rm $ZIMAGE
rm $MODULES_DIR/*
fi
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN- phantom_defconfig
make ARCH=arm CROSS_COMPILE=$TOOLCHAIN- -j8
if [ -a $ZIMAGE ];
then
echo "Copying modules"
rm $MODULES_DIR/*
find . -name '*.ko' -exec cp {} $MODULES_DIR/ \;
cd $MODULES_DIR
echo "Stripping modules for size"
$TOOLCHAIN-strip --strip-unneeded *.ko
cd $KERNEL_DIR
BUILD_END=$(date +"%s")
DIFF=$(($BUILD_END - $BUILD_START))
echo "Build completed in $(($DIFF / 60)) minute(s) and $(($DIFF % 60)) seconds."
else
echo "Compilation failed! Fix the errors!"
fi
