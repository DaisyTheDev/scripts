#!/bin/bash

if [ -f "glibc.tar.zst" -a ! -f "glibc.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree glibc

cd glibc

export PATH=$(realpath ../local/bin):$PATH

if [ -d "build" ]; then
  rm -rf build
fi
mkdir build
cd build

../configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$(realpath ../../glibc-inst)

cd ../..
package_install glibc