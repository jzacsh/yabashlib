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

@test 'strStartsWith detects negative cases' {
  run strStartsWith '$foobar' 'foo'
  [ "$status" -ne 0 ]
}

@test 'strStartsWith is robust against chars that would look like regexp syntax' {
  run strStartsWith '$foobar' '$'
  [ "$status" -eq 0 ]
}

@test 'strStartsWith handles too-small haystack' {
  run strStartsWith '$f' '$foo'
  [ "$status" -eq 1 ]
}

@test 'strEndsWith detects one is a non-strict subset and prefix of another' {
  run strEndsWith 'foobar' 'bar'
  [ "$status" -eq 0 ]
  run strEndsWith 'foobar ' ' '
  [ "$status" -eq 0 ]
}

@test 'strEndsWith detects negative cases' {
  run strEndsWith 'foobar$' 'bar'
  [ "$status" -ne 0 ]
}

@test 'strEndsWith is robust against chars that would look like regexp syntax' {
  run strEndsWith 'foobar$' '$'
  [ "$status" -eq 0 ]
}

@test 'strEndsWith handles too-small haystack' {
  run strEndsWith '$' '$foo'
  [ "$status" -eq 1 ]
}

@test 'strContains detects haystack is a superset of needle' {
  run strContains 'foobar' 'oba'
  [ "$status" -eq 0 ]

  run strContains 'fo$obar' '$'
  [ "$status" -eq 0 ]
}

@test 'strContains detects negative cases' {
  run strContains 'foo' 'baz'
  [ "$status" -ne 0 ]

  run strContains 'fo$o' 'baz'
  [ "$status" -ne 0 ]
}

@test 'strIsWholenumber detects non negative numbers' {
  run strIsWholenumber 10
  [ "$status" -eq 0 ]

  run strIsWholenumber 3824
  [ "$status" -eq 0 ]

  run strIsWholenumber 0
  [ "$status" -eq 0 ]
}

@test 'strIsWholenumber handles negative cases' {
  run strIsWholenumber '1 2'
  [ "$status" -ne 0 ]

  run strIsWholenumber 1.2
  [ "$status" -ne 0 ]

  run strIsWholenumber -10
  [ "$status" -ne 0 ]

  run strIsWholenumber foo
  [ "$status" -ne 0 ]

  run strIsWholenumber 'fo$o'
  [ "$status" -ne 0 ]

  run strIsWholenumber '  '
  [ "$status" -ne 0 ]
}

@test 'strRepeatN repeats the first arg number of times given by second arg' {
  run strRepeatN foo 0
  [ "$status" -eq 0 ]
  [ "$output" = '' ]

  run strRepeatN foo 1
  [ "$status" -eq 0 ]
  [ "$output" = 'foo' ]

  run strRepeatN foo 8
  [ "$status" -eq 0 ]
  [ "$output" = 'foofoofoofoofoofoofoofoo' ]
}

@test 'strJoin concats strings together with a given delim' {
  run yblib.strJoin . foo bar baz
  [ "$status" -eq 0 ]
  [ "$output" = 'foo.bar.baz' ]

  run yblib.strJoin '|' foo bar
  [ "$status" -eq 0 ]
  [ "$output" = 'foo|bar' ]

  run yblib.strJoin ':' foo bar baz thing
  [ "$status" -eq 0 ]
  [ "$output" = 'foo:bar:baz:thing' ]

  run yblib.strJoin ' ' some spaces here
  [ "$status" -eq 0 ]
  [ "$output" = 'some spaces here' ]
}

@test 'strJoin does not break with edge cases' {
  # edge case: single-item list
  run yblib.strJoin '|' foo
  [ "$status" -eq 0 ]
  [ "$output" = 'foo' ]

  # edge case: zero-item list
  run yblib.strJoin '|'
  [ "$status" -eq 0 ]
  [ "$output" = '' ]
}
