#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "$SCRIPT_DIR/git-update.sh"

update_repo() {
    local repo_name="$1"
    local repo_url="$2"
    local tag_pattern="$3"

    export REPO_URL="$repo_url"
    export TAG_PATTERN="$tag_pattern"
    export REPO_NAME="$repo_name"

    echo "========================================"
    echo "Updating $repo_name..."
    echo "========================================"
    git_update
}

echo "Updating all repositories..."

update_repo "bash" "https://git.savannah.gnu.org/git/bash.git" '^bash-[0-9]+\.[0-9]+$'
update_repo "binutils" "git://sourceware.org/git/binutils-gdb.git" '^binutils-[0-9]+_[0-9]+$'
update_repo "btrfs-progs" "https://github.com/kdave/btrfs-progs" '^v[0-9]+\.[0-9]+$'
update_repo "coreutils" "https://github.com/uutils/coreutils.git" '^[0-9]+\.[0-9]+\.[0-9]$'
update_repo "git" "git://git.kernel.org/pub/scm/git/git.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "glibc" "https://sourceware.org/git/glibc.git" '^glibc-[0-9]+\.[0-9]+$'
update_repo "kwin" "https://github.com/KDE/kwin.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "linux" "git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git" '^v[0-9]+\.[0-9]+$'
update_repo "llvm" "https://github.com/llvm/llvm-project.git" '^llvmorg-[0-9]+\.[0-9]+\.[0-9]$'
update_repo "ncurses" "https://github.com/mirror/ncurses.git" '^v[0-9]+\.[0-9]+$'
update_repo "plasma" "https://github.com/KDE/plasma-desktop.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "sudo" "https://github.com/trifectatechfoundation/sudo-rs.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "util" "https://github.com/util-linux/util-linux.git" '^v[0-9]+\.[0-9]+$'

echo "========================================"
echo "All repositories updated successfully!"
echo "========================================"
