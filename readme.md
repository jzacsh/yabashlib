#Yet Another Bash Library: `yabashlib`
Some stuff I wrote when I was creating a needlessly complicated [dotfiles
manager](https://dotfiles.github.io/) and installer, strictly in Bash. Sharing
just this part of that adventure, so the next time I want moderately pleasant
scripting behavior _(mostly in `logging.sh`)_, it will be here and tested.

## Usage [![Build Status][gitlab_ci_badge]][gitlab_ci_dash]

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
make test               # show your work
```

### Upgrading BATs

`./test.sh` has some inline documentation on this, but tl;dr is there's a
mocking bug in the latest upstream bats.

If you're testing that issue you can do so easily by:

1. `$EDITOR ./test.sh`
2. temporarily set `use_vendored_bats` to `0`
3. temporarily set `is_issue_509_resolved` to `1`
4. clear previous test caching of BATs itself: `make cleanbats`
5. re-run tests: `make test`  - this will now be affected by steps 2 and 3, and
   your test will run from a bleeding-edge download of bats-core upstream,
   (without properly refreshing the vendored copy, as one should when not
   testing, via `vendor/update.sh`).

[gitlab_ci_badge]: https://gitlab.com/jzacsh/yabashlib/badges/main/pipeline.svg
[gitlab_ci_dash]: https://gitlab.com/jzacsh/yabashlib/-/jobs
