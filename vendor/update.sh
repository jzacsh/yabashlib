#!/usr/bin/env bash

set -eou pipefail

cd "$(git rev-parse --show-toplevel)" || exit 1

function update_repo_ref() (
  local subpath="$1" remote="$2" ref="$3"
  set -x
  git subtree pull --squash \
    --message 'updating vendored subtree of '"$remote" \
    --prefix "$subpath" "$remote" "$ref"
)

update_repo_ref \
  vendor/bats \
  https://github.com/sstephenson/bats \
  master

update_repo_ref \
  vendor/bats-core \
  https://github.com/bats-core/bats-core \
  master
