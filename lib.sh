#!/bin/bash

if [ "$(id -u -r)" -ne "0" ]; then
  echo "Root is required (or else debug info will leak the user's name)"
  exit 1
fi

export SCRIPTS_DIR="$(realpath .)"

cd $HOME

setup_root_tree() {
  local inst_dir="$1-inst"
  if [ -d "$inst_dir" ]; then
    rm -rf $inst_dir
  fi
  mkdir -p          $inst_dir
  mkdir -p          $inst_dir/boot
  mkdir -p          $inst_dir/etc
  mkdir -p          $inst_dir/opt
  mkdir -p          $inst_dir/run
  mkdir -p          $inst_dir/srv
  mkdir -p          $inst_dir/usr
  mkdir -p          $inst_dir/usr/bin
  mkdir -p          $inst_dir/usr/include
  mkdir -p          $inst_dir/usr/lib
  mkdir -p          $inst_dir/usr/lib32
  mkdir -p          $inst_dir/usr/lib64
  mkdir -p          $inst_dir/usr/libexec
  mkdir -p          $inst_dir/usr/sbin
  mkdir -p          $inst_dir/usr/share
  mkdir -p          $inst_dir/var
  ln -s usr/bin     $inst_dir/bin
  ln -s usr/lib     $inst_dir/lib
  ln -s usr/lib32   $inst_dir/lib32
  ln -s usr/lib64   $inst_dir/lib64
  ln -s usr/libexec $inst_dir/libexec
  ln -s usr/sbin    $inst_dir/sbin
}

remove_symlink() {
  if [ -h "$1/$2" ]; then
    rm -f "$1/$2"
  else
    if [ "$(ls -A "$1/$2")" ]; then
      mv "$1/$2"/* "$1/usr/$2"/
    fi
    rm -rf "$1/$2"
  fi
}

cleanup_root_tree() {
  local inst_dir="$1-inst"
  remove_symlink $inst_dir bin
  remove_symlink $inst_dir lib
  remove_symlink $inst_dir lib32
  remove_symlink $inst_dir lib64
  remove_symlink $inst_dir libexec
  remove_symlink $inst_dir sbin
}

package_install() {
  cleanup_root_tree "$1"
  cd "$1-inst"
  if [ -d "./usr/share/info" ]; then
    rm -rf ./usr/share/info
  fi
  find . -type d -empty -delete
  tar pmcf - . | zstd -22 --ultra > "$SCRIPTS_DIR/$1.tar.zst"
  cd ..
  rm -rf "$1-inst"
}