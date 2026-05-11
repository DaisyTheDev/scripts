#!/bin/bash

if [ -f "sudo.tar.zst" -a ! -f "sudo.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree sudo

cd sudo

cargo install --path . --root ../sudo-inst

cd ..
chmod u+s ./sudo-inst/bin/sudo
chmod u+s ./sudo-inst/bin/su
package_install sudo