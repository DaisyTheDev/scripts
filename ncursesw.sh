#!/bin/bash

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "ncurses.old" ]; then
  exit
fi

set -e

setup_root_tree ncursesw

cd ncurses

export PATH=/usr/lib/ccache/bin:$(realpath ../local/bin):$PATH

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
rm -f ncurses.old