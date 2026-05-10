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
cp ./target/release/su ../sudo-inst/usr/bin/su
cp ./target/release/visudo ../sudo-inst/usr/bin/visudo
chmod u+s ../sudo-inst/usr/bin/sudo
chmod u+s ../sudo-inst/usr/bin/su

cd ..
package_install sudo