#!/usr/bin/env bats

setup() {
  source "$SRCS/string.sh"
}

@test 'should trim right-most character of a string' {
  run stringTrimRight '/some/abs/dir///' '/' 
  echo "$status" > /tmp/jon
  [ "$status" -eq 0 ]
  [ "$output" = '/some/abs/dir' ]
}

@test 'should trim left-most character of a string' {
  run stringTrimLeft '/////some/abs/dir///' '/' 
  [ "$status" -eq 0 ]
  [ "$output" = 'some/abs/dir///' ]
}

@test 'should reduce repeated characters to single occurrence' {
  run reduceRepeats '/////some//abs/dir///' '/' 
  [ "$status" -eq 0 ]
  [ "$output" = '/some/abs/dir/' ]
}
