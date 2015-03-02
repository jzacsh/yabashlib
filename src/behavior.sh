#!/usr/bin/env bash

dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$dir/logging.sh" $@

scriptName="$1"
setLogPrefixTo "$scriptName"

#see /usr/include/sysexits.h
BEHAVIOR_EXIT_ERROR=1   #general error
BEHAVIOR_EXIT_DIRTY=3   #caught sigint
BEHAVIOR_EXIT_USAGE=64  #command line usage error
BEHAVIOR_EXIT_DATAF=65  #data format error
BEHAVIOR_EXIT_NPERM=77  #permission denied
BEHAVIOR_EXIT_CONFG=78  #configuration error

# $1 = exitcode to die for
# .. = optional error message
dieOnFail() {
  local exited message
  exited=$1; shift
  (( exited )) || return 0

  (( $# )) &&
    message=$@ ||
    message="Required command exited: $exited"
  die $BEHAVIOR_EXIT_ERROR "$message"
}

dieSigInt() { die $BEHAVIOR_EXIT_DIRTY 'caught SIGINT'; }

# $1 = exitcode
# .. = error message
die() {
  local exitwith
  exitwith="$1"; shift

  logError $@ "\n\n[$scriptName exiting $exitwith]"

  exit "$exitwith"
}
