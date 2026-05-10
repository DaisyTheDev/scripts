#!/bin/bash

if [ -f "git.tar.zst" -a ! -f "git.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree git

cd git

make configure
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld ./configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=$(realpath ../git-inst)

cd ..
package_install git