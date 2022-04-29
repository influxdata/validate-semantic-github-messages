# validate-semantic-github-messages
Simple GitHub workflow that checks for [conventional commit messages](https://www.conventionalcommits.org/en/v1.0.0/).
Validation is per conventional commits (www.conventionalcommits.org).
Implemented in Bash, with unit tests.

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
    with:
      # Optional: integer >= 0, 250 is default and max
      COMMITS_HISTORY: 1
      # Optional: Dafault is false, in which case there is no change in bahavior.
      # When true, logic is as follow:
      # If there is one commit, only validate its commit message (and not the PR title). 
      # Else validate PR title only (and skip commit messages).  
      # *** This takes precedence over COMMITS_HISTORY. **
      CHECK_PR_TITLE_OR_ONE_COMMIT: false
```
