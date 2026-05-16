#!/bin/bash

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "rustup.old" ]; then
  exit
fi

set -e

setup_root_tree rustup

cd rustup

export PATH=/usr/lib/ccache/bin:$(realpath ../local/bin):$PATH

cargo install --path . --root ../rustup-inst

cd ..
package_install rustup
rm -f rustup.old