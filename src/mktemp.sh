#!/usr/bin/env bash
#
# Make human-readable temporary files; ie: mktemp, but for humans.

# state that needs reset for every caller (who will source us) should be above
# this guard.
[[ -z "${_yblib_guard_mktemp:-}" ]] || return 0; _yblib_guard_mktemp=1 # include guard

# TODO(https://github.com/bats-core/bats-core/issues/509) figure out the latest
# way to test while test-doubling bash builtins, then write tests for this file.

function __yblib.mkHumanTempTemplatePrefix() {
  date '+%Y%m%d-at-%s'
}

# $1=brief human-written slug to conceptually remind what this temp was about.
# $2=non-portable suffix
function __yblib.mkHumanTempTemplate() {
  local slug="$1" nonPortableSuffix="${2:-''}" sortablePrefix

  sortablePrefix="$(__yblib.mkHumanTempTemplatePrefix)" || return 1
  printf -- \
    '%s_%s_XXXXXXXX%s' \
    "$sortablePrefix" \
    "$slug" \
    "$nonPortableSuffix"
}

# `mktemp` with a default template that's human-readable, sortable, and whose
# age is immediately obvious at a glance.
#
# $1=brief human-written slug to conceptually remind what this temp was about.
# $2=optional non-portable suffix to tack on the end (like ".jpg").
#
# internal details: see __yblib.mkHumanTempTemplate
function yblib.mkHumanTemp() {
  local templ
  [[ "$#" -ge 1 && "$#" -le 2 ]] || {
    logfError 'usage: SLUG [NON_PORTABLE_SUFFIX]\n'
    return 1
  }

  templ="$(__yblib.mkHumanTempTemplate "$@")" || return 1
  mktemp --tmpdir=  "$templ"
}

# like yblib.mkHumanTemp but in $PWD
#
# $1=brief human-written slug to conceptually remind what this temp was about.
# $2=optional non-portable suffix to tack on the end (like ".jpg").
function yblib.mkHumanLocalTemp() { TMPDIR=. yblib.mkHumanTemp "$@"; }

# $1=brief human-written slug to conceptually remind what this temp was about.
function __yblib.mkHumanTempTemplateDir() { __yblib.mkHumanTempTemplate "$1" .d; }

# Annoying version of __yblib.mkHumanTempTemplateDir just for OSX (and maybe
# BSD?) users whose `mktemp` _requires_ XXXXXXX to be the last chunk of a
# template.
#
# $1=brief human-written slug to conceptually remind what this temp was about.
function __yblib.mkHumanTempTemplateDirPortable() { __yblib.mkHumanTempTemplate "$1"; }

# `mktemp -d` with a default template that's human-readable, sortable, and whose
# age is immediately obvious at a glance.
#
# $1=brief human-written slug to conceptually remind what this temp was about.
#
# internal details: see __yblib.mkHumanTempTemplateDir
function yblib.mkHumanTempDir() {
  local slug="$1" templ
  [[ "$#" -eq 1 ]] || {
    logfError 'usage: require SLUG as only arg\n'
    return 1
  }

  templ="$(__yblib.mkHumanTempTemplateDir "$slug")" || return 1
  mktemp --tmpdir=  --directory "$templ"
}

# More portable version of yblib.mkHumanTempDir
#
# $1=brief human-written slug to conceptually remind what this temp was about.
function yblib.mkHumanTempDirSafe() {
  local slug="$1" templ
  [[ "$#" -eq 1 ]] || {
    logfError 'usage: require SLUG as only arg\n'
    return 1
  }

  templ="$(__yblib.mkHumanTempTemplateDirPortable "$slug")" || return 1
  mktemp --tmpdir=  --directory "$templ"
}



# like yblib.mkHumanTempDir but in $PWD
#
# $1=brief human-written slug to conceptually remind what this temp was about.
function yblib.mkHumanLocalTempDir() { TMPDIR=. yblib.mkHumanTempDir "$@"; }
