#!/bin/bash

if [ "$(id -u -r)" -ne "0" ]; then
  echo "Root is required (or else debug info will leak the user's name)"
  exit 1
fi

export SCRIPTS_DIR="$(realpath .)"
export CC="clang"
export HOSTCC="clang++"
export CXX="clang++"
export HOSTCXX="clang++"
export LD="ld.lld"
export HOSTLD="ld.lld"
export CCLD="ld.lld"
export HOSTCCLD="ld.lld"
export CXXLD="ld.lld"
export HOSTCXXLD="ld.lld"

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
    cp -a "$1/$2/." "$1/usr/$2/"
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
  rm -rf ./usr/share/info
  find . -type d -empty -delete
  tar pmcf - . | zstd -10 > "$SCRIPTS_DIR/$1.tar.zst"
  local owner="$(stat -c '%u' "$SCRIPTS_DIR")"
  chown "$owner:$owner" "$SCRIPTS_DIR/$1.tar.zst"
  rm -f "$SCRIPTS_DIR/$1.tar.zst.old"
  cd ..
  rm -rf "$1-inst"
}