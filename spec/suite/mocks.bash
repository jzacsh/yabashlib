#!/usr/bin/env bash

# Wraps bats' own `run` method so that you can modify $PATH _just_ during the
# runtime of your `run` method, and unset it afterwards.
#
# For context on this see https://github.com/bats-core/bats-core/issues/509
# and the specific manifestation of this bug as hit by _this_ repo as of
# 061bbcd354cf7 by inspecting:
#   - a) the MOCK env. variable set at bottom of test.sh
#   - b) the spec/suite/mocks.bash script that read that value
#   - c) in each spec/suite/*.bats test file:
#     - 1) the `load mocks` call atop the test
#     - 2) the uses of `MOCK_DATE` throughout the tests (setup and test runs)
#
# Unfortunately this is a temporary hack; this doesn't scale. To maintain use of
# this function:
# - every mock value (like MOCK_DATE) needs to be set here, and exported
# - can't realistically be cleaned up in teardown (otherwise it'd be even more
#   places to track manually synchronizing.
function run_with_mocks() {
  local orig_path="$PATH"
  export PATH="$SPEC_MOCKS:$PATH"
  MOCK_DATE="$(date)"
  run "$@"
  run_ret="$?"
  export PATH="$orig_path"
  return "$run_ret"
}
