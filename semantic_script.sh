# expected env vars: SEMANTIC_PATTERN, PR_TITLE, COMMITS_URL
exit_code=0

echo "COMMITS_HISTORY = ${{ inputs.COMMITS_HISTORY }}"
echo "CHECK_PR_TITLE_OR_ONE_COMMIT = ${{ inputs.CHECK_PR_TITLE_OR_ONE_COMMIT }}"

json=$( gh api --paginate $COMMITS_URL )
commits_count=$(echo $json | jq --raw-output '.[] | [.sha, (.commit.message | split("\n") | first)] | join(" ")' | wc -l)
check_pr_title=true

if [[ ${{ inputs.CHECK_PR_TITLE_OR_ONE_COMMIT }} -eq true ]]; then
  if (($commits_count == 1 )); then
    check_pr_title=false
    commits_to_check=1
  else
    commits_to_check=0
  fi
else
  commits_to_check=${{ inputs.COMMITS_HISTORY }}
fi

echo "Check pr title: $check_pr_title"
echo "Total commits count for PR: $commits_count"
echo "Commits to validate: $commits_to_check"

if [[ $check_pr_title -eq true ]]; then
  if [[ ! $PR_TITLE =~ $SEMANTIC_PATTERN ]]; then
    echo ::error::PR title not semantic: "$PR_TITLE"
    exit_code=1
  else
    echo PR title OK: "$PR_TITLE"
  fi
fi

if (( 0 != $commits_to_check )); then
  commits=$( echo $json | jq --raw-output '.[] | [.sha, (.commit.message | split("\n") | first)] | join(" ")' | tail -$commits_to_check )
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
fi

exit $exit_code
