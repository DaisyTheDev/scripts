#!/bin/bash

if [ -f "./llvm.tar.zst" ]; then
  exit
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

set -e

setup_root_tree llvm

cd llvm

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
  # gcc can be a memory hog at times. use half the cores to half the memory
  ninja -j $(( $(nproc --all) / 2 ))

  cmake --build . --target install

  cd ..
  rm -rf build
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

cmake --install . --prefix=../../llvm-inst/usr

cd ../..
package_install llvm