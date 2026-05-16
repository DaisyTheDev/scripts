#!/bin/bash

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "bash.old" ]; then
  exit
fi

set -e

setup_root_tree bash

cd bash

export PATH=/usr/lib/ccache/bin:$(realpath ../local/bin):$PATH

./configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$(realpath ../bash-inst)

cd ..
package_install bash
rm -f bash.old