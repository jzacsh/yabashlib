#!/usr/bin/env bash
if type yblib.behaviorReload >/dev/null 2>&1; then yblib.behaviorReload; fi
# state that needs reset for every caller (who will source us) should be above
# this guard.
[[ -z "${_yblib_guard_behavior:-}" ]] || return 0; _yblib_guard_behavior=1 # include guard

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/logging.sh"
# all state restting should happen here, including reload of things we include
# above
function yblib.behaviorReload() {
  yblib.loggingReload
}

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

# Whether there exists a binary in $PATH by the name of "$1".
#
# Note: you probably want haveCallable, as this function is more concerned with
# the implementation detail of what sort of callable "$1" actually is, which
# generally shouldn't be in the purview of your programming.
function haveBinary() {
  haveCallable "$1" || return 1
  # for relevant history and context for any implementation choices made here:
  #   https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then/85250#85250
  [[ "$(type -t "$1")" = file ]]
}

function requireBinary() {
  haveBinary "$1" || logfFatal \
    'Binary by the name of "%s" is a runtime dependency of this program\n' \
    "$1"
}

# Whether there exists some command that can be called by the name "$1".
function haveCallable() {
  # for relevant history and context for any implementation choices made here:
  #   https://unix.stackexchange.com/questions/85249/why-not-use-which-what-to-use-then/85250#85250
  command -v "$1" >/dev/null 2>&1
}

function requireCallable() {
  haveCallable "$1" || logfFatal \
    'Command by the name of "%s" is a runtime dependency of this program\n' \
    "$1"
}
