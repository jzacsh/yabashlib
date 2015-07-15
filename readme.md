#Yet Another Bash Library: `yabashlib`
Some stuff I wrote when I was creating a needlessly complicated [dotfiles manager](https://dotfiles.github.io/) and installer, strictly in Bash. Sharing just this part of that adventure, so the next time I want moderately pleasant scripting behavior _(mostly in `logging.sh`)_, it will be here and tested.

## Usage [![Build Status](https://travis-ci.org/jzacsh/yabashlib.png?branch=master)](https://travis-ci.org/jzacsh/yabashlib)

### Installation
To easily use yabashlib methods, just symlink `yabashlib` repo from the
top-level of this directory, into somewhere in your path. eg:
```bash
ln -sv ~/src/yabasshlib/yabashlib ~/bin/
```
_(assuming you keep this repo cloned into `~/src/` and `~/bin/` is in your `$PATH`)_

### Short Version
Given "installation" (`$PATH`) step described above, just:
```bash
#!/usr/bin/env bash

source yabashlib

# your script here...
```

### Long Version

Alternatively, `source` individual libs from your own bash script, eg:
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
