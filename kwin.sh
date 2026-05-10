#!/bin/bash

if [ -f "kwin.tar.zst" -a ! -f "kwin.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree kwin

cd kwin

cmake \
  -B build \
  -G Ninja \
  -DCMAKE_C_COMPILER=/usr/local/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_TESTING=Off
cd build
ninja -j$(nproc --all)
cmake --install . --prefix=../../kwin-inst/usr

cd ../..
package_install kwin