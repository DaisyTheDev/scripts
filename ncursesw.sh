#!/bin/bash

if [ -f "./ncursesw.tar.zst" ]; then
  exit
fi

rm -rf ./ncurses-inst
mkdir -p ./ncurses-inst
mkdir -p ./ncurses-inst/usr/bin
mkdir -p ./ncurses-inst/usr/sbin
mkdir -p ./ncurses-inst/usr/lib
mkdir -p ./ncurses-inst/usr/lib32
mkdir -p ./ncurses-inst/usr/lib64
ln -s usr/bin ./ncurses-inst/bin
ln -s usr/sbin ./ncurses-inst/sbin
ln -s usr/lib ./ncurses-inst/lib
ln -s usr/lib32 ./ncurses-inst/lib32
ln -s usr/lib64 ./ncurses-inst/lib64

cd ncurses

rm -rf build
mkdir build

set -e

cd build
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ../configure --prefix=/usr --enable-widec --with-shared
make -j$(nproc --all)
sudo make install DESTDIR=$(realpath ../../ncurses-inst)

cd ../../ncurses-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../ncursesw.tar.zst
cd ..
sudo rm -rf ncurses-inst