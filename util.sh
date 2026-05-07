#!/bin/bash

if [ -f "$HOME/util.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/util-inst
mkdir -p $HOME/util-inst
mkdir -p $HOME/util-inst/usr/bin
mkdir -p $HOME/util-inst/usr/sbin
mkdir -p $HOME/util-inst/usr/lib
mkdir -p $HOME/util-inst/usr/lib32
mkdir -p $HOME/util-inst/usr/lib64
ln -s usr/bin $HOME/util-inst/bin
ln -s usr/sbin $HOME/util-inst/sbin
ln -s usr/lib $HOME/util-inst/lib
ln -s usr/lib32 $HOME/util-inst/lib32
ln -s usr/lib64 $HOME/util-inst/lib64

set -e

cd $HOME/util
./autogen.sh
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ./configure --disable-kill --disable-more --disable-su
make -j$(nproc --all)
make install DESTDIR=$HOME/util-inst

cd $HOME/util-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/util.tar.zst