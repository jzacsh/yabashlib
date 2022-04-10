#!/bin/bash
#
# Utilities helpful when dealing with version control systems (VCS).

# TODO add test coverage
function vcs_git_is_clean() (
  [[ "$#" -eq 0 ]] || {
    cd "$1" || logfFatal \
      'cannot inspect git status; failed to CD to\n\t"%s"\n' "$1"
    }
  [[ -z "$(git status --porcelain)" ]];
)

# TODO add test coverage
function vcs_git_is_dirty() (
  [[ "$#" -eq 0 ]] || {
    cd "$1" || logfFatal \
      'cannot inspect git status; failed to CD to\n\t"%s"\n' "$1"
  }
  ! vcs_git_is_clean "$@"
)
