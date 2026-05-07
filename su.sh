#!/bin/bash

if [ -f "$HOME/su.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/su-inst
mkdir -p $HOME/su-inst
mkdir -p $HOME/su-inst/usr/bin

SUDO_DIR="$HOME/sudo"

cd "$SUDO_DIR"

set -e

cargo b -r
cp ./target/release/su $HOME/su-inst/usr/bin/su
chmod u+s $HOME/su-inst/usr/bin/su

cd $HOME/su-inst
tar pmcfv - . | zstd -22 --ultra > $HOME/su.tar.zst