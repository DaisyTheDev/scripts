#!/bin/bash

if [ -f "binutils.tar.zst" -a ! -f "binutils.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree binutils

cd binutils

if [ -d "build" ]; then
  rm -rf build
fi
mkdir build
cd build

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CXXLD=/usr/local/bin/ld.lld LDFLAGS="-latomic" ../configure --prefix=/usr --enable-lto
make -j$(nproc --all)
make install tooldir=$(realpath ../../binutils-inst)/usr DESTDIR=$(realpath ../../binutils-inst)

cd ../..
package_install binutils