#!/bin/bash
#
# Common CLI logic having to do with argument parsing, but less sophisticated
# then getopts.
# shellcheck source=/dev/null
[[ -z "${_yblib_guard_args:-}" ]] || return 0; _yblib_guard_args=1 # include guard

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/string.sh"


# $1 = arg to check
function is_help_like() {
  local regexp='^-?-?h(elp)?$'
  [[ "${1,,}" =~ $regexp ]]
}

# Whether any argument in an array of given arguments is empty.
function array_has_empty() {
  for arg in "$@";do
    if strIsEmptyish "$arg"; then
      return 0
    fi
  done
  return 1
}
