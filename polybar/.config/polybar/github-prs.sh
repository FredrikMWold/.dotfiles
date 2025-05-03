#!/bin/zsh

repos=("equinor/dot-web" "equinor/warp-ui" "equinor/subsurface-portal-web", "equinor/pressure-db-ingestion-web")

# Initialize counter for open PRs
pr_to_review_count=0
my_open_prs=0

# Loop through each repo
for repo in "${repos[@]}"; do

  open_prs=$(gh pr list --repo "$repo" --state open --search '-label:dependencies -label:"autorelease: pending" -author:@me is:open' --json number --jq 'length')
  pr_to_review_count=$((pr_to_review_count + open_prs))

  open_prs=$(gh pr list --repo "$repo" --state open --search '-label:dependencies -label:"autorelease: pending" author:@me is:open' --json number --jq 'length')
  my_open_prs=$((my_open_prs + open_prs))
done

echo "%{F#b4befe}%{F-} my $my_open_prs %{F#585b70}| %{F#b4befe}%{F-} review $pr_to_review_count"