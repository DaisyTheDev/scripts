#!/bin/bash

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "sudo.old" ]; then
  exit
fi

set -e

setup_root_tree sudo

cd sudo

cargo install --path . --root ../sudo-inst

cd ..
chmod u+s ./sudo-inst/bin/sudo
chmod u+s ./sudo-inst/bin/su
package_install sudo
rm -f sudo.old