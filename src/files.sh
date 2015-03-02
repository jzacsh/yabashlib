#!/usr/bin/env bash

dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"

# $1 = file to check for siblings of
isFileAnOnlyChild() {
  local parentDir numChildren
  parentDir="$(readlink -f "$(dirname "$1")")"
  numChildren=$(find "$parentDir" | wc -l)

  # 2 lines, one for each of: $parentDir and $1
  [ "$numChildren" -eq 2 ]
}

# $1 = directory to check is empty
isDirectoryEmpty() {
  [ "$(find "$1")" = "$1" ]
}

# $1 = directory to determine if is parent
# $2 = file to determine as child
isDirectoryParentOfFile() {
  [[ "$(readlink -f "$2")" =~ "^$(readlink -f "$1")" ]]
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
