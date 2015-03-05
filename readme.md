#Yet Another Bash Library: `yabashlib`

## Usage [![Build Status](https://travis-ci.org/jzacsh/yabashlib.png?branch=master)](https://travis-ci.org/jzacsh/yabashlib)
Just `source` from your own bash script, eg:
```bash
#!/usr/bin/env bash
#
# MyScript that does awesome things to $1 dir

source "files.sh" $@
source "logging.sh" $@
source "behavior.sh" 'MyScript'

# from  behavior.sh
trap dieSigInt SIGINT


myScriptCleanup() { some tear down stuff }


#
# ... some setup stuff
#


# from files.sh
isDirectoryEmpty "$1" && {
  # from logging.sh
  logWarning 'No work to do here!\n'
  myScriptCleanup
  exit
}


test -r '.myscript-config'; dieOnFail "$?" '.myscript-config not found'

```

## Contribute
```bash
$EDITOR ./src/*         # change all the things
$EDITOR ./spec/suite/*  # test all the things
./test.sh               # show your work
```
