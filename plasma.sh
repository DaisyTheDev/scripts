#!/bin/bash

if [ -f "./plasma.tar.zst" ]; then
  exit
fi

rm -rfd ./plasma-inst
mkdir -p ./plasma-inst
mkdir -p ./plasma-inst/usr/bin
mkdir -p ./plasma-inst/usr/sbin
mkdir -p ./plasma-inst/usr/lib
mkdir -p ./plasma-inst/usr/lib32
mkdir -p ./plasma-inst/usr/lib64
ln -s usr/bin ./plasma-inst/bin
ln -s usr/sbin ./plasma-inst/sbin
ln -s usr/lib ./plasma-inst/lib
ln -s usr/lib32 ./plasma-inst/lib32
ln -s usr/lib64 ./plasma-inst/lib64

cd plasma

set -e

cmake \
  -B build \
  -G Ninja \
  -DCMAKE_C_COMPILER=/usr/local/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_KCM_MOUSE_X11=Off \
  -DBUILD_KCM_TOUCHPAD_X11=Off \
  -DBUILD_TESTING=Off
cd build
ninja -j$(nproc --all)
sudo cmake --install . --prefix=../../plasma-inst/usr

cd ../../plasma-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../plasma.tar.zst