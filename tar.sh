#!/bin/bash

if [ -f "./tar.tar.zst" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree tar

if [ ! -f "tar.tar.xz" ]; then
  curl --output tar.tar.xz https://ftp.gnu.org/gnu/tar/tar-1.35.tar.xz
fi

if [ ! -f tar.tar.xz ]; then
  echo "Error: failed to download tar.tar.xz" >&2
  exit 1
fi

if [ -d "tar" ]; then
  rm -rf tar
fi

mkdir -p tar
cd tar
tar xf ../tar.tar.xz

cd "$(find . -maxdepth 1 -name 'tar*')"
CC=/usr/local/bin/clang CXX=/usr/local/bin/clang++ LD=/usr/local/bin/ld.lld ./configure --prefix=/usr
make -j$(nproc --all)
make install DESTDIR=$(realpath ../../tar-inst)

cd ../..
rm -f tar.tar.xz
package_install tar