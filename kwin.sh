#!/bin/bash

if [ -f "$HOME/kwin.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/kwin-inst
mkdir -p $HOME/kwin-inst
mkdir -p $HOME/kwin-inst/usr/bin
mkdir -p $HOME/kwin-inst/usr/sbin
mkdir -p $HOME/kwin-inst/usr/lib
mkdir -p $HOME/kwin-inst/usr/lib32
mkdir -p $HOME/kwin-inst/usr/lib64
ln -s usr/bin $HOME/kwin-inst/bin
ln -s usr/sbin $HOME/kwin-inst/sbin
ln -s usr/lib $HOME/kwin-inst/lib
ln -s usr/lib32 $HOME/kwin-inst/lib32
ln -s usr/lib64 $HOME/kwin-inst/lib64

KWIN_DIR="$HOME/kwin"

cd "$KWIN_DIR"

set -e

cmake \
  -B build \
  -G Ninja \
  -DCMAKE_C_COMPILER=/usr/local/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_TESTING=Off
cd build
ninja -j$(nproc --all)
cmake --install . --prefix=$HOME/kwin-inst/usr

cd $HOME/kwin-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/kwin.tar.zst