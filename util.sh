#!/bin/bash

if [ -f "./util.tar.zst" ]; then
  exit
fi

rm -rfd ./util-inst
mkdir -p ./util-inst
mkdir -p ./util-inst/usr/bin
mkdir -p ./util-inst/usr/sbin
mkdir -p ./util-inst/usr/lib
mkdir -p ./util-inst/usr/lib32
mkdir -p ./util-inst/usr/lib64
ln -s usr/bin ./util-inst/bin
ln -s usr/sbin ./util-inst/sbin
ln -s usr/lib ./util-inst/lib
ln -s usr/lib32 ./util-inst/lib32
ln -s usr/lib64 ./util-inst/lib64

cd util

set -e

./autogen.sh
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ./configure --disable-kill --disable-more --disable-su
make -j$(nproc --all)
sudo make install DESTDIR=$(realpath ../util-inst)

cd ../util-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../util.tar.zst