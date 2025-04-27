#!/bin/zsh

repos=("equinor/dot-web" "equinor/warp-ui" "equinor/subsurface-portal-web")

# Initialize counter for open PRs
open_pr_count=0

# Loop through each repo
for repo in "${repos[@]}"; do

  # List open PRs for the current repo
  open_prs=$(gh pr list --repo "$repo" --state open --search 'is:open -label:dependencies' --json number --jq 'length')

  # Add the number of open PRs to the total count
  open_pr_count=$((open_pr_count + open_prs))
done

echo "$open_pr_count"