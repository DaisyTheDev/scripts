#!/bin/bash

if [ -f "./bash.tar.zst" ]; then
  exit
fi

rm -rfd ./bash-inst
mkdir -p ./bash-inst
mkdir -p ./bash-inst/usr/bin
mkdir -p ./bash-inst/usr/sbin
mkdir -p ./bash-inst/usr/lib
mkdir -p ./bash-inst/usr/lib32
mkdir -p ./bash-inst/usr/lib64
ln -s usr/bin ./bash-inst/bin
ln -s usr/sbin ./bash-inst/sbin
ln -s usr/lib ./bash-inst/lib
ln -s usr/lib32 ./bash-inst/lib32
ln -s usr/lib64 ./bash-inst/lib64

BASH_DIR="./bash"

cd "$BASH_DIR"

set -e

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ./configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=./bash-inst

cd ./bash-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
rm -rf ./usr/share/info
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ./bash.tar.zst