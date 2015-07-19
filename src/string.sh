#!/usr/bin/env bash

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
