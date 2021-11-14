#!/usr/bin/env bats

load fixture
load mocks

setup() {
  source "$SRCS/behavior.sh" fooBarTool
}


@test 'should set log prefix' {
  run logInfo "testing123"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::INFO\][[:space:]]*testing123$ ]]
}


@test 'should die with ERROR log' {
  testMsg='foobar test'
  run_with_mocks die 99 "$testMsg"
  [ "$status" -eq 99 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ $testMsg ]]
  [[ "${lines[2]}" =~ ^\[fooBarTool\ exiting\ 99\]$ ]]
}


@test 'should die on previous error' {
  [ 1 -eq 2 ] && echo  # noop
  run_with_mocks dieOnFail 89
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ 'Required command exited: 89' ]]
  [[ "${lines[2]}" =~ ^\[fooBarTool\ exiting\ 1\]$ ]]
}


@test 'should die on previous error with default message' {
  testMsg='foobar test'

  [ 1 -eq 2 ] && echo  # noop
  run_with_mocks dieOnFail 39 "$testMsg"
  [ "$status" -eq 1 ]
  [[ "${lines[0]}" =~ ^\[fooBarTool::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ $testMsg ]]
  [[ "${lines[2]}" =~ ^\[fooBarTool\ exiting\ 1\]$ ]]
}

@test 'should die less than Bash v4' {
  skip 'figure out how to force/mock bash3; `shopt -s compat32` non-starter'
  run dieWithoutBash4
  [ "$status" -ne 0 ]
  [ "$output" = "Bash v.4 or greater is required to run this script, found $" ]
}

@test 'should pass with Bash v4 or higher' {
  skip 'figure out how to force/mock bash3; `shopt -s compat32` non-starter'
  run dieWithoutBash4
  [ "$status" -eq 0 ]
  [ -z "$output" ]
}
