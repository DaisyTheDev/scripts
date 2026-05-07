#!/bin/bash

if [ -f "$HOME/btrfs-progs.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/btrfs-progs-inst
mkdir -p $HOME/btrfs-progs-inst
mkdir -p $HOME/btrfs-progs-inst/usr/bin
mkdir -p $HOME/btrfs-progs-inst/usr/sbin
mkdir -p $HOME/btrfs-progs-inst/usr/lib
mkdir -p $HOME/btrfs-progs-inst/usr/lib32
mkdir -p $HOME/btrfs-progs-inst/usr/lib64
ln -s usr/bin $HOME/btrfs-progs-inst/bin
ln -s usr/sbin $HOME/btrfs-progs-inst/sbin
ln -s usr/lib $HOME/btrfs-progs-inst/lib
ln -s usr/lib32 $HOME/btrfs-progs-inst/lib32
ln -s usr/lib64 $HOME/btrfs-progs-inst/lib64

BTRFS_PROGS_DIR="$HOME/btrfs-progs"

cd "$BTRFS_PROGS_DIR"

set -e

./autogen.sh

cd $HOME/btrfs-progs-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/btrfs-progs.tar.zst