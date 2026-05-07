#!/bin/bash

if [ -f "$HOME/plasma.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/plasma-inst
mkdir -p $HOME/plasma-inst
mkdir -p $HOME/plasma-inst/usr/bin
mkdir -p $HOME/plasma-inst/usr/sbin
mkdir -p $HOME/plasma-inst/usr/lib
mkdir -p $HOME/plasma-inst/usr/lib32
mkdir -p $HOME/plasma-inst/usr/lib64
ln -s usr/bin $HOME/plasma-inst/bin
ln -s usr/sbin $HOME/plasma-inst/sbin
ln -s usr/lib $HOME/plasma-inst/lib
ln -s usr/lib32 $HOME/plasma-inst/lib32
ln -s usr/lib64 $HOME/plasma-inst/lib64

PLASMA_DIR="$HOME/plasma"

cd "$PLASMA_DIR"

set -e

cmake \
  -B build \
  -G Ninja \
  -DCMAKE_C_COMPILER=/usr/local/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_KCM_MOUSE_X11=Off \
  -DBUILD_KCM_TOUCHPAD_X11=Off \
  -DBUILD_TESTING=Off
cd build
ninja -j$(nproc --all)
cmake --install . --prefix=$HOME/plasma-inst/usr

cd $HOME/plasma-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/plasma.tar.zst