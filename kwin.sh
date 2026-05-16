#!/bin/bash

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "kwin.old" ]; then
  exit
fi

set -e

setup_root_tree kwin

cd kwin

export PATH=/usr/lib/ccache/bin:$(realpath ../local/bin):$PATH

cmake \
  -B build \
  -G Ninja \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_TESTING=Off
cd build
ninja -j$(nproc)
cmake --install . --prefix=../../kwin-inst/usr

cd ../..
package_install kwin
rm -f kwin.old