# validate-semantic-github-messages
Simple GitHub workflow that checks for [conventional commit messages](https://www.conventionalcommits.org/en/v1.0.0/).
Implemented in Bash, with unit tests.
Intended for use in all InfluxData repositories.

To test:
```console
./test_semantic_script.sh
./test_semantic_pattern.sh
```

To use this workflow in your repo, create file `.github/workflows/semantic.yml`:
```yaml
---
name: "Semantic PR and Commit Messages"

on:
  pull_request:
    types: [opened, reopened, synchronize, edited]

jobs:
  semantic:
    uses: influxdata/validate-semantic-github-messages/.github/workflows/semantic.yml@main
    # optional; 250 is default and max
    with:
      # optional, default is 250, max is 250, min is 0
      COMMITS_HISTORY: 1
      # optional, default is false, when false no behavior change. 
      # When true:
      #   If there is one commit, only validate its commit message (and not the PR title). 
      #   Else validate PR title only (and skip commit messages).  
      # This takes precedence over COMMITS_HISTORY.
      CHECK_PR_TITLE_OR_ONE_COMMIT: false
```
