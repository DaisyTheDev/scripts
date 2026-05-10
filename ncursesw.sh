#!/bin/bash

if [ -f "ncursesw.tar.zst" -a ! -f "ncursesw.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree ncursesw

cd ncurses

if [ -d "build" ]; then
  rm -rf build
fi
mkdir build

cd build
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld ../configure --prefix=/usr --enable-widec --with-shared --without-debug --without-tests --without-ada
make -j$(nproc --all)
make install DESTDIR=$(realpath ../../ncursesw-inst)

cd ../..
package_install ncursesw