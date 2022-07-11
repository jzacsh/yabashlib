#!/usr/bin/env bats

load fixture
load mocks

setup() {
  MOCK_DATE="$(date)"
  export NO_COLOR=1
}

teardown() {
  unset MOCK_DATE
}


@test 'should set log prefix' {
  source "$SRCS/behavior.sh"
  setLogPrefixTo fooBarTool
  run logInfo "testing123"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::INFO\][[:space:]]*testing123$ ]]
}


@test 'should die with ERROR log' {
  source "$SRCS/behavior.sh"
  testMsg='foobar test'
  run die 99 "$testMsg"
  [ "$status" -eq 99 ]
  [[ "${lines[0]}" =~ ^\[yblib::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ $testMsg ]]
}


@test 'should die on previous error' {
  source "$SRCS/behavior.sh"
  [ 1 -eq 2 ] && echo  # noop
  run dieOnFail 89
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" =~ ^\[yblib::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ 'Required command exited: 89' ]]
}


@test 'should die on previous error with default message' {
  source "$SRCS/behavior.sh"
  testMsg='foobar test'

  [ 1 -eq 2 ] && echo  # noop
  run dieOnFail 39 "$testMsg"
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" =~ ^\[yblib::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ $testMsg ]]
}

@test 'should die less than Bash v4' {
  source "$SRCS/behavior.sh"
  skip 'figure out how to force/mock bash3; `shopt -s compat32` non-starter'
  run dieWithoutBash4
  [ "$status" -ne 0 ]
  [ "$output" = "Bash v.4 or greater is required to run this script, found $" ]
}

@test 'should pass with Bash v4 or higher' {
  source "$SRCS/behavior.sh"
  skip 'figure out how to force/mock bash3; `shopt -s compat32` non-starter'
  run dieWithoutBash4
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
