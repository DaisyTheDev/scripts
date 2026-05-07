#!/bin/bash

if [ -f "./btrfs-progs.tar.zst" ]; then
  exit
fi

rm -rfd ./btrfs-progs-inst
mkdir -p ./btrfs-progs-inst
mkdir -p ./btrfs-progs-inst/usr/bin
mkdir -p ./btrfs-progs-inst/usr/sbin
mkdir -p ./btrfs-progs-inst/usr/lib
mkdir -p ./btrfs-progs-inst/usr/lib32
mkdir -p ./btrfs-progs-inst/usr/lib64
ln -s usr/bin ./btrfs-progs-inst/bin
ln -s usr/sbin ./btrfs-progs-inst/sbin
ln -s usr/lib ./btrfs-progs-inst/lib
ln -s usr/lib32 ./btrfs-progs-inst/lib32
ln -s usr/lib64 ./btrfs-progs-inst/lib64

BTRFS_PROGS_DIR="./btrfs-progs"

cd "$BTRFS_PROGS_DIR"

set -e

./autogen.sh

cd ./btrfs-progs-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > ./btrfs-progs.tar.zst