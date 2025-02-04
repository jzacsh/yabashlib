#!/usr/bin/env bash
#
# Small set of generic Bash logging utilities that aim to stay project
# agnostic.

if type yblib.loggingReload >/dev/null 2>&1; then yblib.loggingReload; fi
# state that needs reset for every caller (who will source us) should be above
# this guard.
[[ -z "${_yblib_guard_logging:-}" ]] || return 0; _yblib_guard_logging=1 # include guard

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/console.sh"
# all state restting should happen here, including reload of things we include
# above
# TODO add this pattern to _every_ yblib file and call the includes' reloads
# appropriately.
function yblib.loggingReload() {
  setLogPrefixTo
  # TODO call yblib.consoleReload
}

# $1 = optionally set 'your_prefix'
setLogPrefixTo() {
  if (( $# == 1 )); then
    STAMP_PREFIX_="$1"
  else
    unset STAMP_PREFIX_
  fi
}

getLogPrefix() {
  local prefix; prefix="${STAMP_PREFIX_:-}"
  if [[ -z "$prefix" ]]; then
    echo yblib
  else
    echo "$prefix"
  fi
}

setMaxLogLevelToDebug() { LOG_MODE_=$LOG_LVL_DEBUG_; }
logDebug() { logAs_ $LOG_LVL_DEBUG_ $@; }
logfDebug() { logfAs_ "$LOG_LVL_DEBUG_" "$@"; }

setMaxLogLevelToInfo() { LOG_MODE_=$LOG_LVL_INFO_; }
logInfo() { logAs_ $LOG_LVL_INFO_ $@; }
logfInfo() { logfAs_ "$LOG_LVL_INFO_" "$@"; }

setMaxLogLevelToWarning() { LOG_MODE_=$LOG_LVL_WARNING_; }
logWarning() { logAs_ $LOG_LVL_WARNING_ $@; }
logfWarning() { logfAs_ "$LOG_LVL_WARNING_" "$@"; }

setMaxLogLevelToError() { LOG_MODE_=$LOG_LVL_ERROR_; }
logError() { logAs_ $LOG_LVL_ERROR_ $@; }
logfError() { logfAs_ "$LOG_LVL_ERROR_" "$@"; }

# Logs to stderr per logfError and exits non-zero.
logfFatal() { logfError "$@"; exit 2; }

disableLogHeaders() { LOG_HEADERS_=0; }
enableLogHeaders() { LOG_HEADERS_=1; }

# end public API #####################################

LOG_LVL_DEBUG_=1
LOG_LVL_INFO_=2
LOG_LVL_WARNING_=3
LOG_LVL_ERROR_=4
LOG_MODE_=$LOG_LVL_INFO_
LOG_HEADERS_=1

# Logger wrapping `echo` builtin.
#
# $1 = LOG_LVL_*
# .. = error message
#
# See log[f]* variant of functions that take variable arguments (the printf
# equivalent).
logAs_() {
  logHeader_ "$1" || return 0; shift
  echo -e "$@" >&$fd
}

# Logger wrapping `printf` builtin.
#
# $1 = LOG_LVL_*
# .. = error message
#
# For the variant of functions just wrapping echo (single argument), see those
# functions named without `log...` instead of `logf...` (eg. `logInfo` as
# opposed to `logfInfo`).
logfAs_() {
  logHeader_ "$1" || return 0; shift
  local fmt="$1"; shift
  printf "$fmt" "$@" >&$fd
}

# Returns success if logging should continue (and thus a header was logged),
# false otherwise.
#
# $1=level, indicated by one of the `LOG_LVL_*_` local variables.
logHeader_() {
  local lvl="$1"
  (( lvl >= LOG_MODE_ )) || return 1

  fd="$(getLogLvlFileDescriptor_ lvl)"

  printLogHeader_ "$lvl" "$fd"
}


# $1 = LOG_LVL_*
getLogLvlFileDescriptor_() {
  (( $1 >= LOG_LVL_ERROR_ )) && printf 2 || printf 1
}


# $1 = LOG_LVL_*
# $2 = file descriptor to output to
printLogHeader_() {
  local log_lvl fd color keyword
  log_lvl="$1"
  fd="$2"

  local col_red_='\e[1;31m' col_grn_='\e[1;32m'
  local col_ylw_='\e[1;33m' col_blu_='\e[1;34m'

  (( LOG_HEADERS_ )) || return 0

  case "$log_lvl" in
    $LOG_LVL_DEBUG_)
      color=$col_blu_
      keyword='DEBUGGING';;
    $LOG_LVL_INFO_)
      color=$col_grn_
      keyword='INFO';;
    $LOG_LVL_WARNING_)
      color=$col_ylw_
      keyword='WARNING';;
    $LOG_LVL_ERROR_)
      color=$col_red_
      keyword='ERROR';;
  esac

  printStamp_ $color $fd "$(getLogPrefix)::${keyword}"
  if (( log_lvl >= LOG_LVL_ERROR_ ));then
    echo -e "\t$(date --rfc-3339=seconds)" >&$fd
  fi
}


# $1 = col_* (aside from than col_end_)
# $2 = file descriptor to output to
# .. = text to highlight
printStamp_() {
  local color fd
  local col_end_='\033[0m'  # end cap
  color=$1; fd=$2;
  shift; shift;

  if yblib.hasColor $fd;then
    echo -ne "${color}[$@]${col_end_}\t" >&$fd
  else
    echo -ne "[$@]\t" >&$fd
  fi
}

logLevelArg="${1/--log_level=/}"
case "${logLevelArg,,}" in
  'debug')
    setMaxLogLevelToDebug;;
  'warning')
    setMaxLogLevelToWarning;;
  'error')
    setMaxLogLevelToError;;

  *)
    setMaxLogLevelToInfo;;
esac
