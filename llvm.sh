#!/bin/bash

if [ -z "$(which ccache)" ]; then
  echo "Please install ccache. It will save you hours of your life."
  exit 1
fi

source "$(dirname "$(realpath "$0")")/lib.sh"

if [ ! -f "llvm.old" ]; then
  exit
fi

set -e

setup_root_tree llvm

cd llvm
if [ ! -f ".stage1_done" ]; then
  rm -rf ../local
  cmake \
    -S llvm \
    -B build \
    -G Ninja \
    -DCMAKE_BUILD_TYPE=Release \
    -DCMAKE_INSTALL_PREFIX=$(realpath ../local) \
    -DCMAKE_C_COMPILER=gcc \
    -DCMAKE_CXX_COMPILER=g++ \
    -DLLVM_ENABLE_PROJECTS="clang;lld" \
    -DLLVM_ENABLE_RUNTIMES="compiler-rt" \
    -DLLVM_BUILD_LLVM_DYLIB=On \
    -DLLVM_LINK_LLVM_DYLIB=On \
    -DLLVM_OPTIMIZED_TABLEGEN=On \
    -DLLVM_INSTALL_BINUTILS_SYMLINKS=On \
    -DLLVM_INSTALL_CCTOOLS_SYMLINKS=On \
    -DLLVM_INCLUDE_EXAMPLES=Off \
    -DLLVM_INCLUDE_TESTS=Off \
    -DLLVM_INCLUDE_BENCHMARKS=Off \
    -DLLVM_INCLUDE_DOCS=Off \
    -DLLVM_ENABLE_OCAMLDOC=Off \
    -DLLVM_ENABLE_BINDINGS=Off \
    -DLLVM_ENABLE_TELEMETRY=Off \
    -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=Off \
    -DLLVM_ENABLE_FFI=On \
    -DCLANG_DEFAULT_LINKER=lld \
    -DCLANG_DEFAULT_RTLIB=compiler-rt \
    -DCLANG_DEFAULT_UNWINDLIB=libunwind \
    -DCLANG_LINK_CLANG_DYLIB=On

  cd build
  # gcc can be a memory hog at times
  ninja -j $(( n = $(nproc) / 2, n > 0 ? n : 1 ))

  cmake --build . --target install

  cd ..
  rm -rf build
  touch .stage1_done
fi

export PATH=/usr/lib/ccache/bin:$(realpath ../local/bin):$PATH

cmake \
  -S llvm \
  -B build \
  -G Ninja \
  -DCMAKE_BUILD_TYPE=Release \
  -DCMAKE_INSTALL_PREFIX=/usr \
  -DCMAKE_C_COMPILER=clang \
  -DCMAKE_CXX_COMPILER=clang++ \
  -DCMAKE_C_COMPILER_AR=$(realpath ../local/bin/llvm-ar) \
  -DCMAKE_C_COMPILER_RANLIB=$(realpath ../local/bin/llvm-ranlib) \
  -DCMAKE_C_COMPILER_CLANG_SCAN_DEPS=$(realpath ../local/bin/clang-scan-deps) \
  -DCMAKE_CXX_COMPILER_AR=$(realpath ../local/bin/llvm-ar) \
  -DCMAKE_CXX_COMPILER_RANLIB=$(realpath ../local/bin/llvm-ranlib) \
  -DCMAKE_CXX_COMPILER_CLANG_SCAN_DEPS=$(realpath ../local/bin/clang-scan-deps) \
  -DCMAKE_ASM_COMPILER_AR=$(realpath ../local/bin/llvm-ar) \
  -DCMAKE_ASM_COMPILER_RANLIB=$(realpath ../local/bin/llvm-ranlib) \
  -DCMAKE_ASM_COMPILER_CLANG_SCAN_DEPS=$(realpath ../local/bin/clang-scan-deps) \
  -DLLVM_ENABLE_PROJECTS="clang;clang-tools-extra;lld;lldb" \
  -DLLVM_ENABLE_RUNTIMES="compiler-rt" \
  -DLLVM_USE_LINKER=$(realpath -s ../local/bin/ld.lld) \
  -DLLVM_AS=$(realpath ../local/bin/llvm-as) \
  -DLLVM_LINK=$(realpath ../local/bin/llvm-link) \
  -DLLVM_NM=$(realpath ../local/bin/llvm-nm) \
  -DLLVM_READOBJ=$(realpath ../local/bin/llvm-readobj) \
  -DOPT=$(realpath ../local/bin/opt) \
  -DLLVM_ENABLE_LTO=Thin \
  -DLLVM_BUILD_LLVM_DYLIB=On \
  -DLLVM_LINK_LLVM_DYLIB=On \
  -DLLVM_OPTIMIZED_TABLEGEN=On \
  -DLLVM_INSTALL_BINUTILS_SYMLINKS=On \
  -DLLVM_INSTALL_CCTOOLS_SYMLINKS=On \
  -DLLVM_INSTALL_TOOLCHAIN_ONLY=On \
  -DLLVM_INCLUDE_EXAMPLES=Off \
  -DLLVM_INCLUDE_TESTS=Off \
  -DLLVM_INCLUDE_BENCHMARKS=Off \
  -DLLVM_INCLUDE_DOCS=Off \
  -DLLVM_ENABLE_OCAMLDOC=Off \
  -DLLVM_ENABLE_BINDINGS=Off \
  -DLLVM_ENABLE_TELEMETRY=Off \
  -DLLVM_ENABLE_PER_TARGET_RUNTIME_DIR=Off \
  -DLLVM_ENABLE_FFI=On \
  -DCLANG_DEFAULT_LINKER=lld \
  -DCLANG_DEFAULT_RTLIB=compiler-rt \
  -DCLANG_DEFAULT_UNWINDLIB=libunwind \
  -DCLANG_LINK_CLANG_DYLIB=On

cd build
ninja -j$(nproc)

cmake --install . --prefix=../../llvm-inst

cd ../..
package_install llvm
rm -f llvm.old