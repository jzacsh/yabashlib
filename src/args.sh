#!/bin/bash
#
# Common CLI logic having to do with argument parsing, but less sophisticated
# then getopts.

# TODO add unit tests
# $@ = args to check
function is_help_like() {
  local regexp='^-?-?h(elp)?$'
  [[ "${1,,}" =~ $regexp ]]
}
