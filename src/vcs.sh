#!/bin/bash
#
# Utilities helpful when dealing with version control systems (VCS).

# TODO add test coverage
function vcs_git_is_clean() { [[ -z "$(git status --porcelain)" ]]; }

# TODO add test coverage
function vcs_git_is_dirty() { ! vcs_git_is_clean; }
