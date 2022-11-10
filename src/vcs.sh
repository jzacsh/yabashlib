#!/bin/bash
#
# Utilities helpful when dealing with version control systems (VCS).
[[ -z "${_yblib_guard_vcs:-}" ]] || return 0; _yblib_guard_vcs=1 # include guard

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

# TODO finish porting (and deleting originals!) code originally from vcs_aliases.sh into yabashlib
# originals live here: https://gitlab.com/jzacsh/dotfiles/-/blob/0925fee64e1/bin/lib/vcs_aliases.sh
function __yblib.vcsGit_root() { git rev-parse --show-toplevel; }
function __yblib.vcsHg_root() { hg root; }
function __yblib.vcsIs_in_hg() {
  if __yblib.vcsis_in_git "$1"; then return 1; fi
  ( cd "$1"; hg root >/dev/null 2>&1; )
}

function __yblib.vcsis_in_git(){
  ( cd "$1"; git rev-parse --show-toplevel >/dev/null 2>&1; )
}

# Whether PWD (or $1 if provided) is a VCS repo.
function yblib.isVcsRepo() {
  ret=1
  if [[ "$#" -gt 0 ]]; then
    pushd "$1" >/dev/null || return 1
  fi

  if __yblib.vcsis_in_git; then
    ret=0
  elif __yblib.vcsIs_in_hg; then
    ret=0
  fi

  if [[ "$#" -gt 0 ]]; then
    popd >/dev/null
  fi
  return $ret
}

# Prints and `cd`s into root dir.
function yblib.vcsRoot() {
  local root_dir="$(
    if __yblib.vcsis_in_git; then
      __yblib.vcsGit_root
    elif __yblib.vcsIs_in_hg; then
      __yblib.vcsHg_root
    else
      printf '$PWD not a known VCS repo\n' >&2
      return 1
    fi
  )"

  # Print in case somene uses this function in a subshell, for an assignment
  echo "$root_dir"

  # CD in case someone uses this function interactively
  cd "$root_dir"
}
