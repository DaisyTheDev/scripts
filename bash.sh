#!/bin/bash

if [ -f "bash.tar.zst" -a ! -f "bash.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree bash

cd bash

CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld ./configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=$(realpath ../bash-inst)

cd ..
package_install bash