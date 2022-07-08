#!/usr/bin/env bash

function term_is_tty_ssh() {
  [[ -n "${SSH_CLIENT:-}" ]] || [[ -n "${SSH_TTY:-}" ]] ||
    ( ps -o comm= -p "$PPID" | grep --quiet --extended-regexp '(sshd|*/sshd)'; )
}

function term_supports_color() {
  # 'colors' is the "capname" (see tput(1)) that outputs a numeric value from
  # the terminfo(5) database. See "numeric capabilities" listing of the terminfo
  # manpage.
  local tput_out; tput_out="$(tput colors 2>/dev/null)"
  (( $? == 0 )) && [[ "$tput_out" -gt 2 ]]
}

# Base internal logic used by term_confirm.
#
# $1=requires 'optin' or 'optout' to indicate what is required for prompt to
# succeed.
# $2=prompt
function __yabashlib__term_confirm() {
  local answer
  if [[ "$1" = optout ]]; then
    # This case: special-casing is the requirement that a user opt-out if they
    # don't want to proceed in the positive, otherwise we will proceed.
    read -p "$2 [Y/n] " answer

    if strIsEmptyish "$answer"; then
      return 0 # proceed
    fi
  else
    # This case: default is to require opt in if users want to proceed in the
    # positive, otherwise we'll not proceed.

    read -p "$2 [y/N] " answer
    if strIsEmptyish "$answer"; then
      return 1 # do not proceed
    fi
  fi
  [[ "${answer,,}" = y || "${answer,,}" = yes ]]
}

function term_confirm_optin() {
  __yabashlib__term_confirm optin "$@"
}

function term_confirm_optout() {
  __yabashlib__term_confirm optout "$@"
}

function term_confirm() {
  term_confirm_optin "$@"
}

# Copies some original command($1)'s bash completion to and runs it for a new
# command ($2).
#
# $1=original command you're copying for
# $2=destination command
function yblib.cloneCompletion() {
  local orig="$1" dest="$2"
  yblib.haveCompletion "$orig" || return 1

  local completion
  completion="$(complete -p "$orig")"

  local cmd_line="${completion% "$orig"}"

  # purposely don't quote so that we can get word-splitting on what's currently
  # just a single long string
  #
  # WARNING this is vulnerable to all the problems of word-splitting: we don't
  # know if one of the args was actually a two-part arg separated with a quoted
  # space. This example hasn't been tested for this functoin.
  $cmd_line "$dest"
}

# $1 the program for which we should determine if completion exists
#
# TODO make heuristic here better; somehow gradle on nixos defies our
# implementation.
#   Problem: somehow nixos gradle-completion doesn't run until _after_ I
#   try to complete against gradle; that is:
#   - 1) complete -p gradle  # no output; just error
#   - 2) gradle[TAB]         # magically working
#   - 3) complete -p gradle  # outputs gradle-completion binding
function yblib.haveCompletion() { complete -p "$1" >/dev/null 2>&1; }
