#!/bin/bash

if [ -f "$HOME/bash.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/bash-inst
mkdir -p $HOME/bash-inst
mkdir -p $HOME/bash-inst/usr/bin
mkdir -p $HOME/bash-inst/usr/sbin
mkdir -p $HOME/bash-inst/usr/lib
mkdir -p $HOME/bash-inst/usr/lib32
mkdir -p $HOME/bash-inst/usr/lib64
ln -s usr/bin $HOME/bash-inst/bin
ln -s usr/sbin $HOME/bash-inst/sbin
ln -s usr/lib $HOME/bash-inst/lib
ln -s usr/lib32 $HOME/bash-inst/lib32
ln -s usr/lib64 $HOME/bash-inst/lib64

BASH_DIR="$HOME/bash"

cd "$BASH_DIR"

set -e

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ./configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=$HOME/bash-inst

cd $HOME/bash-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
rm -rf ./usr/share/info
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/bash.tar.zst