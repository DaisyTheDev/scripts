#!/bin/bash

if [ -f "./sudo.tar.zst" ]; then
  exit
fi

rm -rf ./sudo-inst
mkdir -p ./sudo-inst
mkdir -p ./sudo-inst/usr/bin

cd sudo

set -e

cargo b -r
sudo cp ./target/release/sudo ../sudo-inst/usr/bin/sudo
sudo chmod u+s ../sudo-inst/usr/bin/sudo

cd ../sudo-inst
tar pmcfv - . | zstd -22 --ultra > ../sudo.tar.zst
cd ..
sudo rm -rf sudo-inst