#!/usr/bin/env bash
# Setup template repo with branches that create actual merge conflicts (not auto-resolvable)

set -e

repo_dir="$1"

cd "$repo_dir"
git init
git config user.name "Test"
git config user.email "test@test.com"
printf 'line 1\nline 2\nline 3\n' > conflict.txt
git add conflict.txt
git commit -m "Initial"

git checkout -b feature/conflict-a
printf 'line 1\nmodified by A\nline 3\n' > conflict.txt
git add conflict.txt
git commit -m "Feature A changes"

git checkout master
git checkout -b feature/conflict-b
printf 'line 1\nmodified by B\nline 3\n' > conflict.txt
git add conflict.txt
git commit -m "Feature B changes"

git checkout master
