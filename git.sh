#!/bin/bash

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "git.old" ]; then
  exit
fi

set -e

setup_root_tree git

cd git

export PATH=/usr/lib/ccache/bin:$(realpath ../local/bin):$PATH

make configure
./configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$(realpath ../git-inst)

cd ..
package_install git
rm -f git.old