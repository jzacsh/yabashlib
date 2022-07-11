#!/usr/bin/env bats

load fixture
load mocks

setup() {
  source "$SRCS/logging.sh"
  MOCK_DATE="$(date)"

  # Ensure we can get simple $lines comparisons
  export NO_COLOR=1
  # TODO figure out how to write legible BATS tests against $lines array that
  # allow for color evaluation, then add some lightweight test coverage of color
  # enablement.
}

teardown() {
  unset MOCK_DATE
}


@test 'should include timestamp in ERROR level' {
  setLogPrefixTo 'logtests'
  run logError "testing123"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[logtests::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ testing123 ]]
}


@test 'should default to INFO level logging' {
  setLogPrefixTo 'logtests'
  run logInfo "foobar"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[logtests::INFO\][[:space:]]*foobar$ ]]


  run logDebug "foobar"
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -eq 0 ]

  setMaxLogLevelToDebug

  run logDebug "foobar"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ foobar$ ]]
}


@test 'should set default log prefix' {
  source "$SRCS/logging.sh" # API for getting fresh log prefix
  testMsg='testing234'
  testPref='hippo'

  setMaxLogLevelToDebug

  run logDebug "$testMsg"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[yblib::DEBUGGING\][[:space:]]*$testMsg$ ]]

  run logInfo "$testMsg"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[yblib::INFO\][[:space:]]*$testMsg$ ]]

  run logWarning "$testMsg"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[yblib::WARNING\][[:space:]]*$testMsg$ ]]

  run logError "$testMsg"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[yblib::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [[ "${lines[1]}" =~ ^$testMsg$ ]]
}


@test 'should insert app name in prefix' {
  setLogPrefixTo 'logtests'
  testMsg='testing234'

  testPref='hippo'
  setLogPrefixTo "$testPref"
  run logInfo "$testMsg"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[$testPref::INFO\][[:space:]]*$testMsg ]]

  testPref='squirrel'
  setLogPrefixTo "$testPref"
  run logInfo "$testMsg"
  [ "$status" -eq 0 ]
  [[ "${lines[0]}" =~ ^\[$testPref::INFO\][[:space:]]*$testMsg ]]
}


@test 'should silence lower log levels' {
  setLogPrefixTo 'logtests'
  setMaxLogLevelToInfo
  run logDebug "foo"
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -eq 0 ]

  setMaxLogLevelToWarning
  run logInfo "foo"
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -eq 0 ]

  setMaxLogLevelToError
  run logWarning "foo"
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -eq 0 ]


  run logError "foo"
  [ "$status" -eq 0 ]
  [ "${#lines[*]}" -gt 0 ]
}


@test 'should allow disabling log headers at all levels ' {
  setLogPrefixTo 'logtests'
  setMaxLogLevelToDebug

  disableLogHeaders

  run logDebug 'my debug log'
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my debug log' ]

  run logfDebug 'my %s log\n' printf-debug
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my printf-debug log' ]

  run logInfo 'my info log'
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my info log' ]

  run logfInfo 'my %s log\n' printf-info
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my printf-info log' ]

  run logWarning 'my warning log'
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my warning log' ]

  run logfWarning 'my %s log\n' printf-warning
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my printf-warning log' ]

  run logError 'my error log'
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my error log' ]

  run logfError 'my %s log\n' printf-error
  [ "$status" -eq 0 ]
  [ "${#lines[@]}" -eq 1 ]
  [ "${lines[0]}" = 'my printf-error log' ]
}


@test 'should error-exit via logfFatal' {
  setLogPrefixTo 'logtests'
  run logfFatal 'my %s log\n' printf-fatal
  [ "$status" -ne 0 ]
  [ "${#lines[@]}" -eq 2 ]
  [[ "${lines[0]}" =~ ^\[logtests::ERROR\][[:space:]]*$MOCK_DATE$ ]]
  [ "${lines[1]}" = 'my printf-fatal log' ]
}

@test 'should exclude color in non TTY output' {
  skip 'see: github.com/sstephenson/bats/issues/43'
}
