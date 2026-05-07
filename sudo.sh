#!/bin/bash

if [ -f "$HOME/sudo.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/sudo-inst
mkdir -p $HOME/sudo-inst
mkdir -p $HOME/sudo-inst/usr/bin

SUDO_DIR="$HOME/sudo"

cd "$SUDO_DIR"

set -e

cargo b -r
cp ./target/release/sudo $HOME/sudo-inst/usr/bin/sudo
chmod u+s $HOME/sudo-inst/usr/bin/sudo

cd $HOME/sudo-inst
tar pmcfv - . | zstd -22 --ultra > $HOME/sudo.tar.zst