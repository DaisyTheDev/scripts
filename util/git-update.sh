#!/bin/bash

git_update() {
  local repo_dir="$HOME/$REPO_NAME"
  local repo_url="$REPO_URL"
  local tag_pattern="$TAG_PATTERN"
  local git_archive="$HOME/$REPO_NAME.git"
  local output_tar="$HOME/$REPO_NAME.tar.zst"
  local repo_name="$REPO_NAME"

  get_latest_tag() {
    git tag --sort=-version:refname | grep -E "$tag_pattern" | head -n1
  }

  if [ -z "$SKIP" ]; then
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
  fi
}
