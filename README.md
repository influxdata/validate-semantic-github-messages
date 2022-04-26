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
    # optional; 250 is default and max
    with:
      COMMITS_HISTORY: 1
```
