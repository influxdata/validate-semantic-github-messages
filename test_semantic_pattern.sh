#!/usr/bin/env bash

set -u -e -o pipefail

read -r semantic_pattern < semantic_pattern.txt

exit_code=0

echo checking PR and commit titles that should be OK

expect_ok=$( cat << EOF
fix!: foo
fix(foo)!: foo
chore: foo
chore(hello): foo
Revert "fix: certain this fix is correct!"
Merge remote-tracking branch 'origin/main' into alamb/update_df_101
Merge branch 'main' into foo
Merge branch 'main' of xyzpdq into foo
EOF
)

while read -r s; do
  if [[ ! $s =~ $semantic_pattern ]]; then
    echo got FAIL, expected OK: "$s"
    exit_code=1
  fi
done <<< "$expect_ok"

echo checking PR and commit titles that should FAIL

expect_fail=$( cat << EOF
more: foo
chore\(: foo
chore : foo
chore:
chore:
chore:foo
Chore: foo
Revert my thing
Merge this is not a legit merge
EOF
)

while read -r s; do
  if [[ $s =~ $semantic_pattern ]]; then
    echo got OK, expected FAIL: "$s"
    exit_code=1
  fi
done <<< "$expect_fail"

exit $exit_code
