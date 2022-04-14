#!/usr/bin/env bash

set -u -e -o pipefail

exit_code=0

export SEMANTIC_PATTERN="^fodder.+"
export PR_TITLE="fodder for thought"
export commits=$( cat << EOF
7549ea2feb3be862fdbb30f50a03af8359224f44 fodder for cannon
8e2d158a371dce493335ca313a913bfbb8048bba fodder for change
EOF
)

echo checking script conditions that should be OK

if ! bash semantic_script.sh > /dev/null; then
  exit_code=1
  echo expected OK, got failure
fi

SEMANTIC_PATTERN="^emptiness.+"

echo checking script conditions that should fail

if bash semantic_script.sh > /dev/null; then
  exit_code=1
  echo expected failure, got OK
fi

exit $exit_code
