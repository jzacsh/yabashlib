anything in this directory is basically not my code, except `./update.sh`.

code here is vendored with the help of `git subtree` command.

To keep track of what's vendored here, update `./update.sh` every time you add a
new vendored subtree.

To add a new vendored subtree run something like this:
```sh
git subtree add --squash \
  --message 'YOUR_MESSAGE_HERE_MENTIONING_THE_REPO_URL' \
  --prefix vendor/$YOUR_SUBPATH $GIT_REPO_URL ${GIT_REF:-master}
```

And then just go add another `update_repo_ref` line to the bottom of `update.sh`
with similar parameters to what you used above.
