#!/bin/bash

if [ -f "ncursesw.tar.zst" -a ! -f "ncursesw.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree ncursesw

cd ncurses

export PATH=$(realpath ../local/bin):$PATH

if [ -d "build" ]; then
  rm -rf build
fi
mkdir build

cd build
../configure --prefix=/usr --enable-widec --with-shared --without-debug --without-tests --without-ada
make -j$(nproc)
make install DESTDIR=$(realpath ../../ncursesw-inst)

cd ../..
package_install ncursesw