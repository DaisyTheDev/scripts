#!/bin/bash

if [ -f "$HOME/binutils.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/binutils-inst
mkdir -p $HOME/binutils-inst
mkdir -p $HOME/binutils-inst/usr/bin
mkdir -p $HOME/binutils-inst/usr/sbin
mkdir -p $HOME/binutils-inst/usr/lib
mkdir -p $HOME/binutils-inst/usr/lib32
mkdir -p $HOME/binutils-inst/usr/lib64
ln -s usr/bin $HOME/binutils-inst/bin
ln -s usr/sbin $HOME/binutils-inst/sbin
ln -s usr/lib $HOME/binutils-inst/lib
ln -s usr/lib32 $HOME/binutils-inst/lib32
ln -s usr/lib64 $HOME/binutils-inst/lib64

BINUTILS_DIR="$HOME/binutils"

cd "$BINUTILS_DIR"

rm -rf build
mkdir build
cd build

set -e

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" LDFLAGS="-latomic" ../configure --prefix=/usr --enable-lto
make -j$(nproc --all)

cd $HOME/binutils-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/binutils.tar.zst