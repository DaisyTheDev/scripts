#!/bin/bash

if [ -f "./glibc.tar.zst" ]; then
  exit
fi

rm -rfd ./glibc-inst
mkdir -p ./glibc-inst
mkdir -p ./glibc-inst/usr/bin
mkdir -p ./glibc-inst/usr/sbin
mkdir -p ./glibc-inst/usr/lib
mkdir -p ./glibc-inst/usr/lib32
mkdir -p ./glibc-inst/usr/lib64
ln -s usr/bin ./glibc-inst/bin
ln -s usr/sbin ./glibc-inst/sbin
ln -s usr/lib ./glibc-inst/lib
ln -s usr/lib32 ./glibc-inst/lib32
ln -s usr/lib64 ./glibc-inst/lib64

GLIBC_DIR="./glibc"

cd "$GLIBC_DIR"

rm -rf build
mkdir build
cd build

set -e

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ../configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=./glibc-inst

cd ./glibc-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
rm -rf ./usr/share/info
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ./glibc.tar.zst