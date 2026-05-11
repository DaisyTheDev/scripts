#!/bin/bash

if [ -f "plasma.tar.zst" -a ! -f "plasma.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree plasma

cd plasma

export PATH=$(realpath ../local/bin):$PATH

cmake \
  -B build \
  -G Ninja \
  -DCMAKE_C_COMPILER=$HOME/local/bin/clang \
  -DCMAKE_CXX_COMPILER=$HOME/local/bin/clang++ \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DBUILD_KCM_MOUSE_X11=Off \
  -DBUILD_KCM_TOUCHPAD_X11=Off \
  -DBUILD_TESTING=Off
cd build
ninja -j$(nproc)
cmake --install . --prefix=../../plasma-inst/usr

cd ../..
package_install plasma