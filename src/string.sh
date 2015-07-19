#!/usr/bin/env bash

# $1=string to modify
# $2=string to trim
stringTrimRight() (
  local body="$1"
  local trim="$2"

  shopt -s extglob
  echo -n "${body%%+($trim)}"
)

# $1=string to modify
# $2=string to trim
stringTrimLeft() (
  local body="$1"
  local trim="$2"

  shopt -s extglob
  echo -n "${body##+($trim)}"
)


# $1=string to modify
# $2=string to reduce
reduceRepeats() (
  local body="$1"
  local repeat="$2"

  shopt -s extglob
  echo -n "${body//+($2)/$2}"
)
