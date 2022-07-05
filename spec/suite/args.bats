#!/usr/bin/env bats

load fixture
load mocks

setup() {
  source "$SRCS/args.sh"
}

# teardown() { }

@test 'is_help_like detects "-h"' {
  run is_help_like '-h'
  [[ "$status" -eq 0 ]]
}

@test 'is_help_like detects "--h"' {
  run is_help_like '--h'
  [[ "$status" -eq 0 ]]
}

@test 'is_help_like detects "--help"' {
  run is_help_like '--help'
  [[ "$status" -eq 0 ]]
}

@test 'is_help_like detects "-help"' {
  run is_help_like '-help'
  [[ "$status" -eq 0 ]]
}

@test 'is_help_like detects "help"' {
  run is_help_like 'help'
  [[ "$status" -eq 0 ]]
}

@test 'is_help_like detects "h"' {
  run is_help_like 'h'
  [[ "$status" -eq 0 ]]
}

@test 'is_help_like rejects non-help strings' {
  run is_help_like 'halp'
  [[ "$status" -ne 0 ]]

  run is_help_like 'g'
  [[ "$status" -ne 0 ]]

  run is_help_like ''
  [[ "$status" -ne 0 ]]
}

@test 'array_has_empty catches empty strings' {
  run array_has_empty '' bar ''
  echo "$output"
  [[ "$status" -eq 0 ]]

  run array_has_empty boop bar '' bop
  [[ "$status" -eq 0 ]]
}

@test 'array_has_empty catches absence of empty values' {
  run array_has_empty foo bar baz
  [[ "$status" -ne 0 ]]

  run array_has_empty foo
  [[ "$status" -ne 0 ]]

  run array_has_empty ' foo'
  [[ "$status" -ne 0 ]]

  run array_has_empty .
  [[ "$status" -ne 0 ]]
}
