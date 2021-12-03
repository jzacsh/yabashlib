#!/usr/bin/env bash

# TODO if-def wrap the entirety of all yabashlib souceable scripts

dir="$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")"
source "$dir/logging.sh"

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

  logError "$@"

  exit "$exitwith"
}

dieWithoutBash4() {
  (( BASH_VERSINFO[0] >= 4 )) && return 0

  local msg="Bash v.4 or greater is required to run this script, found %s\n"
  printf "$msg" "$BASH_VERSINFO[0]"
  exit "$BEHAVIOR_EXIT_ERROR"
}
