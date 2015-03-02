#!/usr/bin/env bats

load fixture
load mocks

setup() {
  source "$SRCS/behavior.sh" fooBarTool
  setLogPrefixTo fooBarTool
  MOCK_DATE="$(date)"
}

teardown() {
  unset MOCK_DATE
}


@test 'should set log prefix' {
  run logInfo "testing123"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::INFO\][[:space:]]*testing123$ ]]
}


@test 'should die with ERROR log' {
  testMsg='foobar test'
  run die 99 "$testMsg"
  [ "$status" -eq 99 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ $testMsg ]]
  [[ "${lines[2]}" =~ ^\[fooBarTool\ exiting\ 99\]$ ]]
}


@test 'should die on previous error' {
  [ 1 -eq 2 ] && echo  # noop
  run dieOnFail 89
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ 'Required command exited: 89' ]]
  [[ "${lines[2]}" =~ ^\[fooBarTool\ exiting\ 1\]$ ]]
}


@test 'should die on previous error with default message' {
  testMsg='foobar test'

  [ 1 -eq 2 ] && echo  # noop
  run dieOnFail 39 "$testMsg"
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ $testMsg ]]
  [[ "${lines[2]}" =~ ^\[fooBarTool\ exiting\ 1\]$ ]]
}
