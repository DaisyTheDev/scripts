#!/bin/bash

if [ -f "./coreutils.tar.zst" ]; then
  exit
fi

rm -rf ./coreutils-inst
mkdir -p ./coreutils-inst
mkdir -p ./coreutils-inst/usr/bin
mkdir -p ./coreutils-inst/usr/sbin
mkdir -p ./coreutils-inst/usr/lib
mkdir -p ./coreutils-inst/usr/lib32
mkdir -p ./coreutils-inst/usr/lib64
ln -s usr/bin ./coreutils-inst/bin
ln -s usr/sbin ./coreutils-inst/sbin
ln -s usr/lib ./coreutils-inst/lib
ln -s usr/lib32 ./coreutils-inst/lib32
ln -s usr/lib64 ./coreutils-inst/lib64

cd coreutils

set -e

sudo make -j$(nproc --all) install PROFILE=release PREFIX=/usr DESTDIR=$(realpath ../coreutils-inst)

cd ../coreutils-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
sudo find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ../coreutils.tar.zst
cd ..
sudo rm -rf coreutils-inst