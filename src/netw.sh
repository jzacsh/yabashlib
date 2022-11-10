#!/usr/bin/env bash

[[ -z "${_yblib_guard_netw:-}" ]] || return 0; _yblib_guard_netw=1 # include guard

# Whether you're likely currently connected to the wider internet.
#
# $1=optional indicates a duration to timeout testing network activity. See
# DURATION of timeout(1) doc for acceptable syntax.
#
# TODO: there must be something more standard/robust than hackily pinging
# things? eg: systemctl status networking-online; or... does Gnome expose
# whatever it uses to detect wifi capture portals?
function yblib.netwIsLikelyOnline() {
  local highly_available_dns=8.8.8.8 # google's DNS
  local timeout_sec="${1:-.6s}"

  timeout "$timeout_sec" \
    ping -W 1 \
    -c 1 \
    "$highly_available_dns" >/dev/null 2>&1
}
