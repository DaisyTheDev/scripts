#!/bin/bash

if [ -f "./su.tar.zst" ]; then
  exit
fi

rm -rfd ./su-inst
mkdir -p ./su-inst
mkdir -p ./su-inst/usr/bin

SUDO_DIR="./sudo"

cd "$SUDO_DIR"

set -e

cargo b -r
cp ./target/release/su ./su-inst/usr/bin/su
chmod u+s ./su-inst/usr/bin/su

cd ./su-inst
tar pmcfv - . | zstd -22 --ultra > ./su.tar.zst