#!/bin/bash

if [ -f "$HOME/coreutils.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/coreutils-inst
mkdir -p $HOME/coreutils-inst
mkdir -p $HOME/coreutils-inst/usr/bin
mkdir -p $HOME/coreutils-inst/usr/sbin
mkdir -p $HOME/coreutils-inst/usr/lib
mkdir -p $HOME/coreutils-inst/usr/lib32
mkdir -p $HOME/coreutils-inst/usr/lib64
ln -s usr/bin $HOME/coreutils-inst/bin
ln -s usr/sbin $HOME/coreutils-inst/sbin
ln -s usr/lib $HOME/coreutils-inst/lib
ln -s usr/lib32 $HOME/coreutils-inst/lib32
ln -s usr/lib64 $HOME/coreutils-inst/lib64

COREUTILS_DIR="$HOME/coreutils"

cd "$COREUTILS_DIR"

set -e

make -j$(nproc --all) install PROFILE=release PREFIX=/usr DESTDIR=$HOME/coreutils-inst

cd $HOME/coreutils-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/coreutils.tar.zst