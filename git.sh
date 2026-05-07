#!/bin/bash

if [ -f "./git.tar.zst" ]; then
  exit
fi

rm -rfd ./git-inst
mkdir -p ./git-inst
mkdir -p ./git-inst/usr/bin
mkdir -p ./git-inst/usr/sbin
mkdir -p ./git-inst/usr/lib
mkdir -p ./git-inst/usr/lib32
mkdir -p ./git-inst/usr/lib64
ln -s usr/bin ./git-inst/bin
ln -s usr/sbin ./git-inst/sbin
ln -s usr/lib ./git-inst/lib
ln -s usr/lib32 ./git-inst/lib32
ln -s usr/lib64 ./git-inst/lib64

cd git

set -e

make configure
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ./configure --prefix=/usr
make -j$(nproc --all)
sudo make install DESTDIR=$(realpath ../git-inst)

cd ../git-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../git.tar.zst