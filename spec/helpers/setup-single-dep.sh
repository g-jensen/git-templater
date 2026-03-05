#!/usr/bin/env bash
set -e

repo_dir="$1"

cd "$repo_dir"
git init
git config user.name "Test"
git config user.email "test@test.com"
printf 'base\n' > base.txt
git add base.txt
git commit -m "Initial"

git checkout -b feature/parent
printf 'parent\n' > parent.txt
git add parent.txt
git commit -m "Add parent"

git checkout -b feature/child
printf 'child\n' > child.txt
printf 'dependencies:\n  - feature/parent\n' > .template-deps.yaml
git add child.txt .template-deps.yaml
git commit -m "Add child (depends on parent)"

git checkout feature/parent
printf 'parent-updated\n' > parent.txt
git add parent.txt
git commit -m "Update parent"
