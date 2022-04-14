# expected env vars: SEMANTIC_PATTERN, PR_TITLE, commits
exit_code=0

if [[ ! $PR_TITLE =~ $SEMANTIC_PATTERN ]]; then
  echo ::error::PR title not semantic: "$PR_TITLE"
  exit_code=1
else
  echo PR title OK: "$PR_TITLE"
fi

while read -r commit; do
  commit_title=${commit:41}
  commit_hash_short=${commit:0:7}

  if [[ ! $commit_title =~ $SEMANTIC_PATTERN ]]; then
    echo ::error::Commit title $commit_hash_short not semantic: "$commit_title"
    exit_code=1
  else
    echo Commit title $commit_hash_short OK: "$commit_title"
  fi
done <<< $commits

exit $exit_code
