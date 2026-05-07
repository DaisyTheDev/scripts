#!/bin/bash

if [ -f "./binutils.tar.zst" ]; then
  exit
fi

rm -rfd ./binutils-inst
mkdir -p ./binutils-inst
mkdir -p ./binutils-inst/usr/bin
mkdir -p ./binutils-inst/usr/sbin
mkdir -p ./binutils-inst/usr/lib
mkdir -p ./binutils-inst/usr/lib32
mkdir -p ./binutils-inst/usr/lib64
ln -s usr/bin ./binutils-inst/bin
ln -s usr/sbin ./binutils-inst/sbin
ln -s usr/lib ./binutils-inst/lib
ln -s usr/lib32 ./binutils-inst/lib32
ln -s usr/lib64 ./binutils-inst/lib64

cd binutils

rm -rf build
mkdir build
cd build

set -e

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CXXLD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" LDFLAGS="-latomic" ../configure --prefix=/usr --enable-lto
make -j$(nproc --all)
sudo make install DESTDIR=$(realpath ../../binutils-inst)

cd ../../binutils-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../binutils.tar.zst