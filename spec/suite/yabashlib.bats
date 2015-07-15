#!/usr/bin/env bats

load fixture
load mocks

#setup() { }
# teardown() { }

assertNonExistent() {
  run type "$1"
  [ "$status" -ne 0 ]
}

@test 'should not allow execution as a script' {
  run "$SRCS/../yabashlib"
  [ "$status" -ne 0 ]

  # ensure some explanation was provided:
  [ -n "$output" ]
}

@test 'should source all of library, including behavior' {
  assertNonExistent die
  assertNonExistent dieOnFail

  source "$SRCS/../yabashlib"

  type die
  type dieOnFail
}

@test 'should source all of library, including files' {
  assertNonExistent isFileAnOnlyChild
  assertNonExistent isDirectoryEmpty
  assertNonExistent isDirectoryParentOfFile
  assertNonExistent getRelativeFromHome
  assertNonExistent getFirstChildOfHome

  source "$SRCS/../yabashlib"

  type isFileAnOnlyChild
  type isDirectoryEmpty
  type isDirectoryParentOfFile
  type getRelativeFromHome
  type getFirstChildOfHome
}

@test 'should source all of library, including logging' {
  assertNonExistent setLogPrefixTo
  assertNonExistent setMaxLogLevelToDebug
  assertNonExistent logDebug
  assertNonExistent setMaxLogLevelToInfo
  assertNonExistent logInfo
  assertNonExistent setMaxLogLevelToWarning
  assertNonExistent logWarning
  assertNonExistent setMaxLogLevelToError
  assertNonExistent logError

  source "$SRCS/../yabashlib"

  type setLogPrefixTo
  type setMaxLogLevelToDebug
  type logDebug
  type setMaxLogLevelToInfo
  type logInfo
  type setMaxLogLevelToWarning
  type logWarning
  type setMaxLogLevelToError
  type logError
}

@test 'should work if symlinked from elsewhere' {
  skip 'tedious `mktemp -d && ... && ln -sv` test should go here'
}
