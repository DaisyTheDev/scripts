#!/bin/bash

if [ -f "./su.tar.zst" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree su

cd sudo

cargo b -r
cp ./target/release/su ../su-inst/usr/bin/su
chmod u+s ../su-inst/usr/bin/su

cd ..
package_install su