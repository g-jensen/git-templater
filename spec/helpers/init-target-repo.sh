#!/usr/bin/env bash
# Initialize target directory as git repo with existing work

set -e

target_dir="$1"

cd "$target_dir"
git init
git config user.name "Target"
git config user.email "target@test.com"
printf 'existing work\n' > existing.txt
git add existing.txt
git commit -m "Existing work"
