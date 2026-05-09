#!/bin/bash

if [ -f "./ncursesw.tar.zst" ]; then
  exit
fi

rm -rf ./ncursesw-inst
mkdir -p ./ncursesw-inst
mkdir -p ./ncursesw-inst/usr/bin
mkdir -p ./ncursesw-inst/usr/sbin
mkdir -p ./ncursesw-inst/usr/lib
mkdir -p ./ncursesw-inst/usr/lib32
mkdir -p ./ncursesw-inst/usr/lib64
ln -s usr/bin ./ncursesw-inst/bin
ln -s usr/sbin ./ncursesw-inst/sbin
ln -s usr/lib ./ncursesw-inst/lib
ln -s usr/lib32 ./ncursesw-inst/lib32
ln -s usr/lib64 ./ncursesw-inst/lib64

cd ncurses

rm -rf build
mkdir build

set -e

cd build
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ../configure --prefix=/usr --enable-widec --with-shared --without-debug --without-tests --without-ada
make -j$(nproc --all)
sudo make install DESTDIR=$(realpath ../../ncursesw-inst)

cd ../../ncursesw-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../ncursesw.tar.zst
cd ..
sudo rm -rf ncursesw-inst