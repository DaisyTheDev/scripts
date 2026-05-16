#!/bin/bash

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "glibc.old" ]; then
  exit
fi

set -e

setup_root_tree glibc

cd glibc

export PATH=/usr/lib/ccache/bin:$(realpath ../local/bin):$PATH

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
rm -f glibc.old