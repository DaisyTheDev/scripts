#!/bin/bash

if [ -f "$HOME/ncursesw.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/ncurses-inst
mkdir -p $HOME/ncurses-inst
mkdir -p $HOME/ncurses-inst/usr/bin
mkdir -p $HOME/ncurses-inst/usr/sbin
mkdir -p $HOME/ncurses-inst/usr/lib
mkdir -p $HOME/ncurses-inst/usr/lib32
mkdir -p $HOME/ncurses-inst/usr/lib64
ln -s usr/bin $HOME/ncurses-inst/bin
ln -s usr/sbin $HOME/ncurses-inst/sbin
ln -s usr/lib $HOME/ncurses-inst/lib
ln -s usr/lib32 $HOME/ncurses-inst/lib32
ln -s usr/lib64 $HOME/ncurses-inst/lib64

NCURSES_DIR="$HOME/ncurses"

cd "$NCURSES_DIR"

set -e

if [ -d "build" ]; then
  rm -rfd build
fi
mkdir build
cd build
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ../configure --prefix=/usr --enable-widec --with-shared
make -j$(nproc --all)
make install DESTDIR=$HOME/ncurses-inst

cd $HOME/ncurses-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/ncursesw.tar.zst