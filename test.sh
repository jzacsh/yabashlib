#!/usr/bin/env bash

baseDir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
specDir="$baseDir/spec"
specSuite="$specDir/suite"
batsDir="$specDir/.bats"
batsBld="$batsDir/local"
batsExec="$batsBld/bin/bats"

# Ensure bats unit testing framework is in place
[ ! -x "$batsExec" ] && {
  src_dir="$batsDir/src"

  exec 4>/dev/null
  [[ "$@" =~ --tap ]] && safefd=4 || safefd=2

  {
    echo 'Could not find local bats installation, installing now...' >&$safefd
    [ -d "$batsDir" ] && rmdir "$batsDir"
    {
      [ ! -d "$batsDir" ] &&
        git clone --quiet https://github.com/sstephenson/bats.git "$src_dir" &&
        mkdir "$batsBld" &&
        "$src_dir/install.sh" "$batsBld" &&
        [ -x "$batsExec" ]
    } >&$safefd

    [ -d "$batsDir" ] || {
      echo 'Failed to automatically install bats test framework' >&2
      exit 1
    }
  } || {
    echo 'ERROR: Failed to find or install bats testing framework' >&2
    exit 1
  }
}


# Default to pointing at spec/suite/ if it doesn't look like there are file
# args intended for bats to read directly
bats_target="$specSuite"
for (( i = 1; i <= $#; ++i  ));do
  [ -r ${!i} ] && {
    unset bats_target
    break
  }
done


# Execute all bats unit tests
SRCS="$baseDir/src" \
  SPEC="$specDir" \
  SPEC_SUITE="$specDir" \
  SPEC_SUITE="$specDir/suite" \
  SPEC_MOCKS="$specDir/mocks" \
  "$batsExec" $@ $bats_target
