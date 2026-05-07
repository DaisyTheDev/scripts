#!/bin/bash

if [ -f "$HOME/llvm.tar.zst" ]; then
  exit
fi

rm -rfd $HOME/llvm-inst
mkdir -p $HOME/llvm-inst
mkdir -p $HOME/llvm-inst/usr/bin
mkdir -p $HOME/llvm-inst/usr/sbin
mkdir -p $HOME/llvm-inst/usr/lib
mkdir -p $HOME/llvm-inst/usr/lib32
mkdir -p $HOME/llvm-inst/usr/lib64
ln -s usr/bin $HOME/llvm-inst/bin
ln -s usr/sbin $HOME/llvm-inst/sbin
ln -s usr/lib $HOME/llvm-inst/lib
ln -s usr/lib32 $HOME/llvm-inst/lib32
ln -s usr/lib64 $HOME/llvm-inst/lib64

LLVM_DIR="$HOME/llvm"

cd "$LLVM_DIR"

set -e

if [ ! -f ".stage1_done" ]; then
  cmake \
    -S llvm \
    -B build \
    -G Ninja \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DCMAKE_BUILD_TYPE=Release \
    -DLLVM_TARGETS_TO_BUILD=X86 \
    -DLLVM_INCLUDE_EXAMPLES=Off \
    -DLLVM_INCLUDE_TESTS=Off \
    -DLLVM_INCLUDE_BENCHMARKS=Off \
    -DLLVM_INCLUDE_DOCS=Off \
    -DLLVM_ENABLE_OCAMLDOC=Off \
    -DLLVM_ENABLE_BINDINGS=Off \
    -DLLVM_ENABLE_TELEMETRY=Off

  cd build
  ninja -j $(( $(nproc --all) / 2 ))

  cmake --build . --target install

  cd ..
  rm -rfd build
  touch .stage1_done
fi

cmake \
  -S llvm \
  -B build \
  -G Ninja \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;lldb" \
  -DLLVM_ENABLE_RUNTIMES="llvm-libgcc" \
  -DCMAKE_BUILD_TYPE=Release \
  -DLLVM_ENABLE_LTO=Full \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DLLVM_USE_LINKER=/usr/local/bin/ld.lld \
  -DCMAKE_C_COMPILER=/usr/local/bin/clang \
  -DCMAKE_CXX_COMPILER=/usr/local/bin/clang++ \
  -DLLVM_INSTALL_BINUTILS_SYMLINKS=On \
  -DLLVM_INSTALL_CCTOOLS_SYMLINKS=On \
  -DBUILD_SHARED_LIBS=On \
  -DLLVM_INCLUDE_EXAMPLES=Off \
  -DLLVM_INCLUDE_TESTS=Off \
  -DLLVM_INCLUDE_BENCHMARKS=Off \
  -DLLVM_INCLUDE_DOCS=Off \
  -DLLVM_ENABLE_OCAMLDOC=Off \
  -DLLVM_ENABLE_BINDINGS=Off \
  -DLLVM_ENABLE_TELEMETRY=Off \
  -DLLVM_LIBGCC_EXPLICIT_OPT_IN=Yes \
  -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=Off

cd build
ninja -j$(nproc --all)

cmake --install . --prefix=$HOME/llvm-inst/usr

cd $HOME/llvm-inst
rm -f ./bin
rm -f ./sbin
rm -f ./lib
rm -f ./lib32
rm -f ./lib64
find . -type d -empty -delete
tar pmcfv - . | zstd -22 --ultra > $HOME/llvm.tar.zst