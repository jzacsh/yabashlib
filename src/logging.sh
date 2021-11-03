#!/usr/bin/env bash
#
# Small set of generic Bash logging utilities that aim to stay project
# agnostic.

# $1 = optionally set 'your_prefix'
setLogPrefixTo() {
  if (( $# == 1 )); then
    STAMP_PREFIX_="${1}::"
  else
    setLogPrefixTo 'logging'
  fi
}

setMaxLogLevelToDebug() { LOG_MODE_=$LOG_LVL_DEBUG_; }
logDebug() { logAs_ $LOG_LVL_DEBUG_ $@; }

setMaxLogLevelToInfo() { LOG_MODE_=$LOG_LVL_INFO_; }
logInfo() { logAs_ $LOG_LVL_INFO_ $@; }

setMaxLogLevelToWarning() { LOG_MODE_=$LOG_LVL_WARNING_; }
logWarning() { logAs_ $LOG_LVL_WARNING_ $@; }

setMaxLogLevelToError() { LOG_MODE_=$LOG_LVL_ERROR_; }
logError() { logAs_ $LOG_LVL_ERROR_ $@; }

disableLogHeaders() { LOG_HEADERS_=0; }
enableLogHeaders() { LOG_HEADERS_=1; }

# end public API #####################################


col_end_='\033[0m'  # end cap
col_blk_='\e[0;30m'
col_red_='\e[1;31m'
col_grn_='\e[1;32m'
col_ylw_='\e[1;33m'
col_blu_='\e[1;34m'
col_wht_='\e[0;37m'

LOG_LVL_DEBUG_=1
LOG_LVL_INFO_=2
LOG_LVL_WARNING_=3
LOG_LVL_ERROR_=4
LOG_MODE_=$LOG_LVL_INFO_
LOG_HEADERS_=1

# $1 = LOG_LVL_*
# .. = error message
logAs_() {
  local lvl
  lvl=$1; shift
  (( lvl < LOG_MODE_ )) && return  # We're ignoring log_lvl, "$1"

  fd=$(getLogLvlFileDescriptor_ lvl)

  printLogHeader_ $lvl $fd
  echo -e $@ >&$fd
}


# $1 = LOG_LVL_*
getLogLvlFileDescriptor_() {
  (( $1 >= LOG_LVL_ERROR_ )) && printf 2 || printf 1
}


# $1 = LOG_LVL_*
# $2 = file descriptor to output to
printLogHeader_() {
  local log_lvl fd color keyword
  log_lvl=$1
  fd=$2

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

  printStamp_ $color $fd "${STAMP_PREFIX_}${keyword}"
  if (( log_lvl >= LOG_LVL_ERROR_ ));then
    echo -e "\t$(date --rfc-3339=seconds)" >&$fd
  fi
}


# $1 = col_* (aside from than col_end_)
# $2 = file descriptor to output to
# .. = text to highlight
printStamp_() {
  local color fd
  color=$1; fd=$2;
  shift; shift;

  if [[ -t $fd ]];then
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
