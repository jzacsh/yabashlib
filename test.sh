#!/usr/bin/env bash

baseDir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
specDir="$baseDir/spec"
specSuite="$specDir/suite"
batsDir="$specDir/.bats"
batsBld="$batsDir/local"
batsExec="$batsBld/bin/bats"

# TODO turn this variable on once the tests are passing
# blocked by https://github.com/bats-core/bats-core/issues/509
declare -r is_issue_509_resolved=0
if (( is_issue_509_resolved )); then
  declare -r bats_upstream_repo=https://github.com/bats-core/bats-core
else
  declare -r bats_upstream_repo=https://github.com/sstephenson/bats.git
fi

# TODO turn this on once sstephenson/bats.git si vendored.
declare -r use_vendored_bats=0
if (( use_vendored_bats )); then
  src_dir="$baseDir/vendor/bats-core"
else
  src_dir="$batsDir/src"
fi

# Ensure bats unit testing framework is in place
[ ! -x "$batsExec" ] && {
  exec 4>/dev/null
  [[ "$@" =~ --tap ]] && safefd=4 || safefd=2

  {
    echo 'Could not find local bats installation, installing now...' >&$safefd
    [ -d "$batsDir" ] && rmdir "$batsDir"
    {
      [ ! -d "$batsDir" ] || exit 3

      if (( use_vendored_bats )); then
        echo -e '\tutilizing vendored bats...' >&$safefd
      else
        echo -e '\tutilizing fresh upstream code from '$bats_upstream_repo'...' >&$safefd
        git clone --quiet "$bats_upstream_repo" "$src_dir" &&
          mkdir "$batsBld"
      fi
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
