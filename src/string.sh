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

# Whether string "$1" is either empty or practically empty (whitespace).
function strIsEmptyish() {
  local empty_regexp='^[[:space:]]*$'
  [[ -z "$1" || "$1" =~ $empty_regexp ]]
}

# Whether string "$1" starts with string "$2"
function strStartsWith() {
  local haystack="$1" start_substr="$2"
  local substr_regexp='^'"$start_substr"
  [[  "$haystack" =~ $substr_regexp ]]
}
