#!/usr/bin/env bash

# $1 = file to check for siblings of
isFileAnOnlyChild() {
  local parentDir numChildren
  parentDir="$(readlink -f "$(dirname "$1")")"
  numChildren=$(find "$parentDir" | wc -l)

  # 2 lines, one for each of: $parentDir and $1
  [ "$numChildren" -eq 2 ]
}

# $1 = file to check for emptiness of
isNonemptyFile() { [[ -n "$1" && -s "$1" && -f "$1" ]]; }

# $1 = directory to check for emptiness of
isNonemptyDir() {
  [[ -n "$1" && -d "$1" ]] || return 1
  ! isDirectoryEmpty "$1"
}

# $1 = directory to check is empty
isDirectoryEmpty() {
  [[ "$(find "$1")" = "$1" ]]
}

# eg:
#  returns  true: isDirectoryParentOfFile /foo/bar /foo/bar/baz
#  returns false: isDirectoryParentOfFile /foo/bar /foo/doop
#
# NOTE: will return false if either file doesn't exist.
#
# $1 = directory to determine if is parent
# $2 = file to determine as child
isDirectoryParentOfFile() {
  local supposed_ancestor supposed_descendent
  supposed_ancestor="$(readlink -f "$1")"
  supposed_descendent="$(readlink -f "$2")"
  local descendent_regexp='^'"$supposed_ancestor"
  [[ "$supposed_descendent" =~ $descendent_regexp ]] &&
    [[ "$supposed_descendent" != $descendent_regexp ]]
}

# $1 = path to return the relative version of
getRelativeFromHome() {
  printf '%s' "${1/$HOME\//}"
}

# $1 = A path to retrieve the first child of, when relative to HOME
# eg: $HOME/foo/bar will return "foo"
getFirstChildOfHome() {
  local relativeScaffold firstChild _
  IFS=/ read -r firstChild _ <<< "$(getRelativeFromHome "$1")"
  printf '%s' "$firstChild"
}

# TODO add tests
is_same_content() ( diff "$1" "$2" >/dev/null 2>&1; )

# TODO add tests
is_same_file() ( [[ "$(readlink --canonicalize "$1")" = "$(readlink --canonicalize "$2")" ]]; )

# Lists the files that would normally be listed by bash (eg: if you have a for
# loop over a path glob).
function listBashGlob() { compgen -G "$1"; }

function isFilledBashGlob() { listBashGlob "$@" > /dev/null 2>&1; }
