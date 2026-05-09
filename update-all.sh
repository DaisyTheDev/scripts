#!/bin/bash

git_update() {
  local repo_dir="./$REPO_NAME"
  local repo_url="$REPO_URL"
  local tag_pattern="$TAG_PATTERN"
  local git_archive="./$REPO_NAME.git"
  local output_tar="./$REPO_NAME.tar.zst"
  local repo_name="$REPO_NAME"

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
        rm -f $output_tar
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

update_repo() {
  export REPO_NAME="$1"
  export REPO_URL="$2"
  export TAG_PATTERN="$3"
  git_update
}

echo "Updating all repositories..."

update_repo "bash" "https://git.savannah.gnu.org/git/bash.git" '^bash-[0-9]+\.[0-9]+$'
update_repo "binutils" "git://sourceware.org/git/binutils-gdb.git" '^binutils-[0-9]+_[0-9]+$'
update_repo "coreutils" "https://github.com/uutils/coreutils.git" '^[0-9]+\.[0-9]+\.[0-9]$'
update_repo "git" "git://git.kernel.org/pub/scm/git/git.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "glibc" "https://sourceware.org/git/glibc.git" '^glibc-[0-9]+\.[0-9]+$'
update_repo "kwin" "https://github.com/KDE/kwin.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "linux" "git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git" '^v[0-9]+\.[0-9]+\.[0-9]+$'
update_repo "llvm" "https://github.com/llvm/llvm-project.git" '^llvmorg-[0-9]+\.[0-9]+\.[0-9]$'
update_repo "ncurses" "https://github.com/mirror/ncurses.git" '^v[0-9]+\.[0-9]+$'
update_repo "plasma" "https://github.com/KDE/plasma-desktop.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "sudo" "https://github.com/trifectatechfoundation/sudo-rs.git" '^v[0-9]+\.[0-9]+\.[0-9]$'
update_repo "util" "https://github.com/util-linux/util-linux.git" '^v[0-9]+\.[0-9]+$'