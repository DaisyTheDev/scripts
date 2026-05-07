#!/bin/bash

if [ -f "$HOME/glibc.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/glibc-inst
mkdir -p $HOME/glibc-inst
mkdir -p $HOME/glibc-inst
mkdir -p $HOME/glibc-inst/usr/bin
mkdir -p $HOME/glibc-inst/usr/sbin
mkdir -p $HOME/glibc-inst/usr/lib
mkdir -p $HOME/glibc-inst/usr/lib32
mkdir -p $HOME/glibc-inst/usr/lib64
ln -s usr/bin $HOME/glibc-inst/bin
ln -s usr/sbin $HOME/glibc-inst/sbin
ln -s usr/lib $HOME/glibc-inst/lib
ln -s usr/lib32 $HOME/glibc-inst/lib32
ln -s usr/lib64 $HOME/glibc-inst/lib64

GLIBC_DIR="$HOME/glibc"

cd "$GLIBC_DIR"

rm -rf build
mkdir build
cd build

set -e

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ../configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=$HOME/glibc-inst

cd $HOME/glibc-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
rm -rf ./usr/share/info
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/glibc.tar.zst