#!/bin/bash

if [ -f "$HOME/git.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/git-inst
mkdir -p $HOME/git-inst
mkdir -p $HOME/git-inst/usr/bin
mkdir -p $HOME/git-inst/usr/sbin
mkdir -p $HOME/git-inst/usr/lib
mkdir -p $HOME/git-inst/usr/lib32
mkdir -p $HOME/git-inst/usr/lib64
ln -s usr/bin $HOME/git-inst/bin
ln -s usr/sbin $HOME/git-inst/sbin
ln -s usr/lib $HOME/git-inst/lib
ln -s usr/lib32 $HOME/git-inst/lib32
ln -s usr/lib64 $HOME/git-inst/lib64

GIT_DIR="$HOME/git"

cd "$GIT_DIR"

set -e

make configure
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ./configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=$HOME/git-inst

cd $HOME/git-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/git.tar.zst