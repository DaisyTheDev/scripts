#!/bin/bash

if [ -f "util.tar.zst" -a ! -f "util.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree util

cd util

export PATH=$(realpath ../local/bin):$PATH

./autogen.sh
./configure --disable-kill --disable-more --disable-su --disable-nologin
make -j$(nproc)
make install DESTDIR=$(realpath ../util-inst)

cd ../shadowutil

autoreconf -f --install .
./configure --prefix=/usr --enable-man --without-su
make -j$(nproc)
make install DESTDIR=$(realpath ../util-inst)

cd ../binutils

if [ -d "build" ]; then
  rm -rf build
fi
mkdir build
cd build

LDFLAGS="-latomic -Wl,--undefined-version" ../configure --prefix=/usr --enable-lto
make -j$(nproc)
make install tooldir=/. DESTDIR=$(realpath ../../util-inst)

cd ../../coreutils

make -j$(nproc) install PROFILE=release PREFIX=/usr DESTDIR=$(realpath ../util-inst)

cd ..

package_install util