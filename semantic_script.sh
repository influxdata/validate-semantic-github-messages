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
    echo ::error::$commit_hash_short not semantic: "$commit_title"
    exit_code=1
  else
    echo $commit_hash_short OK: "$commit_title"
  fi
done <<< $commits

if [ $exit_code -ne 0 ]; then
  echo
  echo "This repository uses semantic commit messages"
  echo "check out https://www.conventionalcommits.org/ for more information"
  echo "and rewrite any rejected commit messages to pass CI - thanks!"
  echo
fi

exit $exit_code
