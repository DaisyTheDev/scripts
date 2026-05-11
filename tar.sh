#!/bin/bash

if [ -f "tar.tar.zst" -a ! -f "tar.tar.zst.old" ]; then
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

export PATH=$(realpath ../local/bin):$PATH

tar xf ../tar.tar.xz

cd "$(find . -maxdepth 1 -name 'tar*')"
FORCE_UNSAFE_CONFIGURE=1 ./configure --prefix=/usr
make -j$(nproc)
make install DESTDIR=$(realpath ../../tar-inst)

cd ../..
rm -f tar.tar.xz
package_install tar