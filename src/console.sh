#!/usr/bin/env bash

function term_supports_color() {
  # 'colors' is the "capname" (see tput(1)) that outputs a numeric value from
  # the terminfo(5) database. See "numeric capabilities" listing of the terminfo
  # manpage.
  local tput_out; tput_out="$(tput colors 2>/dev/null)"
  (( $? == 0 )) && [[ "$tput_out" -gt 2 ]]
}
