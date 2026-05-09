#!/bin/bash

if [ -f "./sudo.tar.zst" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree sudo

cd sudo

cargo b -r
cp ./target/release/sudo ../sudo-inst/usr/bin/sudo
chmod u+s ../sudo-inst/usr/bin/sudo

cd ..
package_install sudo