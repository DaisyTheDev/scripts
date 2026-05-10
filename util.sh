#!/bin/bash

if [ -f "util.tar.zst" -a ! -f "util.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree util

cd util

./autogen.sh
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld ./configure --disable-kill --disable-more --disable-su --disable-nologin
make -j$(nproc --all)
make install DESTDIR=$(realpath ../util-inst)

cd ../shadowutil

autoreconf -f --install .
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld ./configure --prefix=/usr --enable-man --without-su
make -j$(nproc --all)
make install DESTDIR=$(realpath ../util-inst)

cd ../binutils

if [ -d "build" ]; then
  rm -rf build
fi
mkdir build
cd build

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CXXLD=/usr/local/bin/ld.lld LDFLAGS="-latomic" ../configure --prefix=/usr --enable-lto
make -j$(nproc --all)
make install tooldir=/. DESTDIR=$(realpath ../../util-inst)

cd ../../coreutils

make -j$(nproc --all) install PROFILE=release PREFIX=/usr DESTDIR=$(realpath ../util-inst)

cd ..

package_install util