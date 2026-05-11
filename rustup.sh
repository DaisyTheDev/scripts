#!/bin/bash

if [ -f "rustup.tar.zst" -a ! -f "rustup.tar.zst.old" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree rustup

cd rustup

export PATH=$(realpath ../local/bin):$PATH

cargo install --path . --root ../rustup-inst

cd ..
package_install rustup