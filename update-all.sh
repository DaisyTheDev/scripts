#!/bin/bash

if [ "$(id -u -r)" -ne "0" ]; then
  echo "Root is required (Detected updates need to be able to delete files that the builds make)"
  exit 1
fi

export SCRIPTS_DIR="$(realpath .)"

cd $HOME

git_update() {
  local repo_dir="./$1"
  local repo_url="$2"
  local tag_pattern="$3"
  local git_archive="./$1.git"
  local output_tar="$SCRIPTS_DIR/$1.tar.zst"
  local repo_name="$1"

  get_latest_tag() {
    git tag --sort=-version:refname | grep -E "$tag_pattern" | head -n1
  }

  if [ -z "$SKIP" ]; then
    local prev_dir=$(realpath .)
    if [ -d "$repo_dir" ]; then
      echo "Existing $repo_name directory found at $repo_dir, checking for updates..."
      cd "$repo_dir"
      git fetch --tags origin
      CURRENT_TAG=$(git describe --tags --exact-match HEAD 2>/dev/null || echo "")
      LATEST_TAG=$(get_latest_tag)

      if [ -z "$LATEST_TAG" ]; then
        echo "Error: Failed to retrieve latest $repo_name tag."
        exit 1
      fi

      echo "Current tag: ${CURRENT_TAG:-unknown}"
      echo "Latest available tag: $LATEST_TAG"

      if [ "$CURRENT_TAG" != "$LATEST_TAG" ]; then
        echo "Updating to latest tag: $LATEST_TAG"
        git clean -fdx
        git restore .
        git checkout "$LATEST_TAG"
        mv $output_tar $output_tar.old
      else
        echo "$repo_name is already at the latest tag: $LATEST_TAG"
      fi
    else
      echo "Cloning $repo_name repository..."
      git clone -n "$repo_url" "$repo_dir"
      cd "$repo_dir"
      LATEST_TAG=$(get_latest_tag)

      if [ -z "$LATEST_TAG" ]; then
        echo "Error: Failed to retrieve latest $repo_name tag."
        exit 1
      fi

      echo "Checking out latest tag: $LATEST_TAG"
      git checkout "$LATEST_TAG"
    fi
    cd $prev_dir
  fi
}

echo "Updating all repositories..."

git_update "bash"       "https://git.savannah.gnu.org/git/bash.git"                      '^bash-[0-9]+\.[0-9]+$'
git_update "binutils"   "git://sourceware.org/git/binutils-gdb.git"                      '^binutils-[0-9]+_[0-9]+$'
git_update "coreutils"  "https://github.com/uutils/coreutils.git"                        '^[0-9]+\.[0-9]+\.[0-9]+$'
git_update "git"        "git://git.kernel.org/pub/scm/git/git.git"                       '^v[0-9]+\.[0-9]+\.[0-9]+$'
git_update "glibc"      "https://sourceware.org/git/glibc.git"                           '^glibc-[0-9]+\.[0-9]+$'
git_update "kwin"       "https://github.com/KDE/kwin.git"                                '^v[0-9]+\.[0-9]+\.[0-9]+$'
git_update "linux"      "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git" '^v[0-9]+\.[0-9]+\.[0-9]+$'
git_update "llvm"       "https://github.com/llvm/llvm-project.git"                       '^llvmorg-[0-9]+\.[0-9]+\.[0-9]+$'
git_update "ncurses"    "https://github.com/mirror/ncurses.git"                          '^v[0-9]+\.[0-9]+$'
git_update "plasma"     "https://github.com/KDE/plasma-desktop.git"                      '^v[0-9]+\.[0-9]+\.[0-9]+$'
git_update "sudo"       "https://github.com/trifectatechfoundation/sudo-rs.git"          '^v[0-9]+\.[0-9]+\.[0-9]+$'
git_update "util"       "https://github.com/util-linux/util-linux.git"                   '^v[0-9]+\.[0-9]+$'
git_update "shadowutil" "https://github.com/shadow-maint/shadow.git"                     '^v[0-9]+\.[0-9]+(\.[0-9]+)?$'