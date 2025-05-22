#!/bin/bash
# filepath: clean_local_branches.sh

# Fetch latest remote branches
git fetch --prune

# List all local branches except the current one
for branch in $(git branch --format='%(refname:short)' | grep -v "$(git branch --show-current)"); do
    # Check if branch exists on remote
    if ! git ls-remote --exit-code --heads origin "$branch" > /dev/null; then
        echo "Deleting local branch: $branch"
        git branch -D "$branch"
    fi
done

echo "Done. All local branches not on remote have been deleted."