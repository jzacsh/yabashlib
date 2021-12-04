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
  run strIsEmptyish ''
  [ "$status" -eq 0 ]
}

@test 'strIsEmptyish detects one or more spaces' {
  run strIsEmptyish ' '
  [ "$status" -eq 0 ]
  run strIsEmptyish '                  '
  [ "$status" -eq 0 ]
}

@test 'strIsEmptyish detects strange spaces like tabs' {
  run strIsEmptyish "$(echo -e '\t \n')"
  [ "$status" -eq 0 ]
  run strIsEmptyish "$(echo -e '\r\t\n\n')"
  [ "$status" -eq 0 ]
}

@test 'strStartsWith detects one is a non-strict subset and prefix of another' {
  run strStartsWith 'foobar' 'foo'
  [ "$status" -eq 0 ]
  run strStartsWith ' foobar' ' '
  [ "$status" -eq 0 ]
}
