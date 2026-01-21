#!/usr/bin/env bash
# Create a feature branch with a file

set -e

repo_dir="$1"
branch_name="$2"
file_name="$3"
file_content="$4"

cd "$repo_dir"
git checkout -b "$branch_name"
printf '%s\n' "$file_content" > "$file_name"
git add "$file_name"
git commit -m "Add $branch_name"
git checkout master
