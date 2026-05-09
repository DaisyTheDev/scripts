#!/bin/bash

if [ -f "./coreutils.tar.zst" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree coreutils

cd coreutils

make -j$(nproc --all) install PROFILE=release PREFIX=/usr DESTDIR=$(realpath ../coreutils-inst)

cd ..
package_install coreutils