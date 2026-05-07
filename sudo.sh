#!/bin/bash

if [ -f "./sudo.tar.zst" ]; then
  exit
fi

rm -rfd ./sudo-inst
mkdir -p ./sudo-inst
mkdir -p ./sudo-inst/usr/bin

SUDO_DIR="./sudo"

cd "$SUDO_DIR"

set -e

cargo b -r
cp ./target/release/sudo ./sudo-inst/usr/bin/sudo
chmod u+s ./sudo-inst/usr/bin/sudo

cd ./sudo-inst
tar pmcfv - . | zstd -22 --ultra > ./sudo.tar.zst