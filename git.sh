#!/bin/bash

if [ -f "git.tar.zst" -a ! -f "git.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree git

cd git

export PATH=$(realpath ../local/bin):$PATH

make configure
./configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$(realpath ../git-inst)

cd ..
package_install git