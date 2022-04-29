# expected env vars: SEMANTIC_PATTERN, PR_TITLE, COMMITS_URL
exit_code=0

# When running the check against its own repo, the inputs will be blank, so
# in this case set them.  This will never happen when called as a reusable workflow.
commits_history=250
if [[ "" != "${{ inputs.COMMITS_HISTORY }}" ]]; then 
  commits_history=${{ inputs.COMMITS_HISTORY }}
fi

tg_style=false
if [[ "" != "${{ inputs.CHECK_PR_TITLE_OR_ONE_COMMIT }}" ]]; then
  tg_style=${{ inputs.CHECK_PR_TITLE_OR_ONE_COMMIT }}
fi
  
echo "COMMITS_HISTORY = $commits_history"
echo "CHECK_PR_TITLE_OR_ONE_COMMIT = $tg_style"

json=$( gh api --paginate $COMMITS_URL )
commits_count=$(echo $json | jq --raw-output '.[] | [.sha, (.commit.message | split("\n") | first)] | join(" ")' | wc -l)
check_pr_title=true

if [[ tg_style == true ]]; then
  if (($commits_count == 1 )); then
    check_pr_title=false
    commits_to_check=1
  else
    commits_to_check=0
  fi
else
  commits_to_check=$commits_history
fi

echo "Check pr title: $check_pr_title"
echo "Total commits count for PR: $commits_count"
echo "Commits to validate: $commits_to_check"

if [[ $check_pr_title == true ]]; then
  if [[ ! $PR_TITLE =~ $SEMANTIC_PATTERN ]]; then
    echo ::error::PR title not semantic: "$PR_TITLE"
    exit_code=1
  else
    echo PR title OK: "$PR_TITLE"
  fi
fi

if [[ 0 != $commits_to_check ]]; then
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
