#!/bin/bash

if [ -f "glibc.tar.zst" -a ! -f "glibc.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree glibc

cd glibc

if [ -d "build" ]; then
  rm -rf build
fi
mkdir build
cd build

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld ../configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=$(realpath ../../glibc-inst)

cd ../..
package_install glibc