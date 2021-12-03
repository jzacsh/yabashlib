#!/usr/bin/env bats

setup() {
  source "$SRCS/string.sh"
}

@test 'should trim right-most character of a string' {
  run strTrimRight '/some/abs/dir///' '/'
  echo "$status" > /tmp/jon
  [ "$status" -eq 0 ]
  [ "$output" = '/some/abs/dir' ]
}

@test 'should trim left-most character of a string' {
  run strTrimLeft '/////some/abs/dir///' '/'
  [ "$status" -eq 0 ]
  [ "$output" = 'some/abs/dir///' ]
}

@test 'strTrim trims surrounding itmes' {
  run strTrim '/////some/abs/dir///' '/'
  [ "$status" -eq 0 ]
  [ "$output" = 'some/abs/dir' ]
}

@test 'strTrim trims surrounding substrings larger than char' {
  run strTrim 'BOOKENDBOOKENDsome/abs/dirBOOKEND' 'BOOKEND'
  [ "$status" -eq 0 ]
  [ "$output" = 'some/abs/dir' ]
}

@test 'should reduce repeated characters to single occurrence' {
  run strStripRepeats '/////some//abs/dir///' '/'
  [ "$status" -eq 0 ]
  [ "$output" = '/some/abs/dir/' ]
}

@test 'strIsEmptyish detects zero-length input' {
  skip '`strIsEmptyish` test not written'
}

@test 'strIsEmptyish detects one or more spaces' {
  skip '`strIsEmptyish` test not written'
}

@test 'strIsEmptyish detects strange spaces like tabs' {
  skip '`strIsEmptyish` test not written'
}

@test 'strStartsWith detects one is a non-strict subset and prefix of another' {
  skip '`strStartsWith` test not written'
}
