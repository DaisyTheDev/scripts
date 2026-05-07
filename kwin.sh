#!/bin/bash

if [ -f "./kwin.tar.zst" ]; then
  exit
fi

rm -rfd ./kwin-inst
mkdir -p ./kwin-inst
mkdir -p ./kwin-inst/usr/bin
mkdir -p ./kwin-inst/usr/sbin
mkdir -p ./kwin-inst/usr/lib
mkdir -p ./kwin-inst/usr/lib32
mkdir -p ./kwin-inst/usr/lib64
ln -s usr/bin ./kwin-inst/bin
ln -s usr/sbin ./kwin-inst/sbin
ln -s usr/lib ./kwin-inst/lib
ln -s usr/lib32 ./kwin-inst/lib32
ln -s usr/lib64 ./kwin-inst/lib64

cd kwin

set -e

cmake \
  -B build \
  -G Ninja \
  -DCMAKE_C_COMPILER=/usr/local/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_TESTING=Off
cd build
ninja -j$(nproc --all)
sudo cmake --install . --prefix=../../kwin-inst/usr

cd ../../kwin-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../kwin.tar.zst