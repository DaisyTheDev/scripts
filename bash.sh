#!/bin/bash

if [ -f "bash.tar.zst" -a ! -f "bash.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree bash

cd bash

export PATH=$(realpath ../local/bin):$PATH

./configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$(realpath ../bash-inst)

cd ..
package_install bash