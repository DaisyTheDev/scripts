#!/bin/bash

set -e

$(dirname "$(realpath "$0")")/llvm.sh
$(dirname "$(realpath "$0")")/bash.sh
$(dirname "$(realpath "$0")")/binutils.sh
$(dirname "$(realpath "$0")")/coreutils.sh
$(dirname "$(realpath "$0")")/git.sh
$(dirname "$(realpath "$0")")/glibc.sh
$(dirname "$(realpath "$0")")/kwin.sh
$(dirname "$(realpath "$0")")/linux.sh
$(dirname "$(realpath "$0")")/ncursesw.sh
$(dirname "$(realpath "$0")")/plasma.sh
$(dirname "$(realpath "$0")")/sudo.sh
$(dirname "$(realpath "$0")")/tar.sh
$(dirname "$(realpath "$0")")/util.sh