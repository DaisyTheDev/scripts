#!/bin/bash

if [ "$(id -u -r)" -ne "0" ]; then
  echo "Root is required"
  exit 1
fi

cd $HOME

clean() {
  cd "$1"
  git clean -fdx
  cd ..
  rm -rf "$1-inst"
}

clean bash
clean binutils
clean coreutils
clean git
clean glibc
clean kwin
clean linux
clean llvm
clean ncurses
clean plasma
clean rustup
clean sudo
clean util
clean shadowutil