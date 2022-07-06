#!/usr/bin/env bash

source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/behavior.sh"
source "$(dirname "$(readlink -f "${BASH_SOURCE[0]}")")/string.sh"

function yblib.isGnuLinux() {
  local unameOs gnuLinuxRegexp='linux'
  unameOs="$(uname --operating-system)" || return 1
  strIsContentful "$unameOs" || return 1
  [[ "$unameOs" = 'GNU/Linux' || "${unameOs,,}" =~ $gnuLinuxRegexp ]]
}

function yblib.getPackageSrc() {
  yblib.isGnuLinux || return 1 # not implemented for other OSes
  yblib.getGnulinuxPackageSrc "$@"
}

# Ensure we autocomplete to binaries
complete -A command yblib.getPackageSrc

function yblib.getGnulinuxPackageSrc() {
  local pkg="$1"
  { haveBinary "$pkg" && yblib.isGnuLinux; } || {
    printf 'fatal: yblib.getPackageSrc called for non-binary and/or non-GNU/Linux system\n' >&2
    return 1
  }
  local baseDistro; baseDistro="$(yblib.guessGnuLinuxDistroBase)"
  [[ -n "$baseDistro" ]] || return 1

  local pkgFile; pkgFile="$(command -v "$pkg")" || return 1
  case "$baseDistro" in
    arch)
      haveCallable pkgfile || return 1
      pkgfile "$pkgFile" || return 1
      ;;
    debian)
      haveCallable dpkg || return 1
      dpkg -S "$pkgFile" || return 1
      ;;
    *) return 1;; # distro not yet implemented
  esac
}

# Ensure we autocomplete to binaries
complete -A command yblib.getGnulinuxPackageSrc

# $1=key
function __yblib.releaseFileValue() {
  local key="$1"
  awk -F'=' '$1 == "'"$key"'" {print tolower($2)}'
}

function yblib.guessGnuLinuxDistroBase() {
  yblib.isGnuLinux || return 1

  # /etc/os-release specified by
  # https://www.freedesktop.org/software/systemd/man/os-release.html
  local osReleaseFile=/etc/os-release

  local distro; distro="$(yblib.guessGnuLinuxDistro)"
  [[ -f /etc/os-release ]] || {
    # We can't figure out the base, but we might be on a "base"ish distro anyway, so use
    # some heuristic to catch this
    [[ "$distro" = arch || "$distro" = debian ]] || return 1
    echo "$distro"
  }

  local like
  like="$(__yblib.releaseFileValue ID_LIKE < "$osReleaseFile")" || return 1
  { strIsContentful "$like" && [[ "$distro" != "$like" ]]; } || return 1

  # take only the first value in a space-separated list of values.
  echo "${like%% *}"
}

function yblib.guessGnuLinuxDistro() {
  yblib.isGnuLinux || return 1

  # /etc/os-release specified by
  # https://www.freedesktop.org/software/systemd/man/os-release.html
  if [[ -f /etc/os-release ]]; then
    __yblib.releaseFileValue ID < /etc/os-release
  elif [[ -f /etc/lsb-release ]]; then
    __yblib.releaseFileValue DISTRIB_ID < /etc/lsb-release
  elif [[ -f /etc/arch-release ]]; then
    echo arch
  elif [[ -f /etc/debian_version ]];then
    echo debian
  else
    return 1
  fi
}
