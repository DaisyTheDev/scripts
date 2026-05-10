#!/bin/bash

if [ -f "util.tar.zst" -a ! -f "util.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree util

cd util

./autogen.sh
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld CFLAGS="-g0 -O2" CPPFLAGS="-g0 -O2" ./configure --disable-kill --disable-more --disable-su
make -j$(nproc --all)
make install DESTDIR=$(realpath ../util-inst)

cd ..
package_install util