#!/bin/bash

if [ -f "./su.tar.zst" ]; then
  exit
fi

rm -rf ./su-inst
mkdir -p ./su-inst
mkdir -p ./su-inst/usr/bin

cd sudo

set -e

cargo b -r
sudo cp ./target/release/su ../su-inst/usr/bin/su
sudo chmod u+s ../su-inst/usr/bin/su

cd ../su-inst
tar pmcfv - . | zstd -22 --ultra > ../su.tar.zst
cd ..
sudo rm -rf su-inst