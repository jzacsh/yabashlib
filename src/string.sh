#!/usr/bin/env bash

function strTrim() {
  local body="$1"
  local trim="$2"

  strTrimLeft "$(strTrimRight "$body" "$trim")" "$trim"
}

# $1=string to modify
# $2=string to trim
strTrimRight() (
  local body="$1"
  local trim="$2"

  shopt -s extglob
  echo -n "${body%%+($trim)}"
)

# $1=string to modify
# $2=string to trim
strTrimLeft() (
  local body="$1"
  local trim="$2"

  shopt -s extglob
  echo -n "${body##+($trim)}"
)


# $1=string to modify
# $2=string to strip
strStripRepeats() (
  local body="$1"
  local repeat="$2"

  shopt -s extglob
  echo -n "${body//+($repeat)/$repeat}"
)

# Whether string "$1" has non-empty/whitespace content.
function strIsContentful() { ! strIsEmptyish "$1"; }

# Whether string "$1" is either empty or practically empty (whitespace).
function strIsEmptyish() {
  local empty_regexp='^[[:space:]]*$'
  [[ -z "$1" || "$1" =~ $empty_regexp ]]
}

# Whether string "$1" (haystack) starts with string "$2" (needle).
function strStartsWith() {
  local haystack="$1" needle="$2"
  local needle_length="${#needle}"
  local haystack_subset="${haystack:0:$needle_length}"
  [[ "$haystack_subset" = "$needle" ]]
}

# Whether string "$1" (haystack) contains string "$2" (needle).
function strContains() {
  local haystack="$1" needle="$2"
  [[ "${#haystack}" -ge "${#needle}" ]] || return 1
  local haystack_without_needle
  haystack_without_needle="${haystack/$needle/}"
  [[ "$haystack_without_needle" != "$haystack" ]]
}

# Whether $1 is a non-negative integer - ie: either 0 or one of the natural
# numbers.
function strIsWholenumber() (
  # for character classes, see:
  # https://pubs.opengroup.org/onlinepubs/009696899/basedefs/xbd_chap07.html#tag_07_03_01
  local nonneg_naturals_regexp='^[[:digit:]]+$'
  [[ "$1" =~ $nonneg_naturals_regexp ]]
)

# Returns $1 repeated N times.
function strRepeatN() {
  local content="$1" multiplier="$2"
  strIsWholenumber "$multiplier" || return 1
  [[ "$multiplier" -gt 0 ]] || {
    echo
    return
  }

  local printf_overload_args
  printf_overload_args="$(seq --separator=' ' 1 "$multiplier")"

  local template
  # purposely do'nt quote $printf_overload_args
  printf -v template -- '-%.s' $printf_overload_args
  printf -- '%s\n' \
    "${template//-/$content}"
}
