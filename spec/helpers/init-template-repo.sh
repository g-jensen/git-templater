#!/usr/bin/env bash
# Initialize a basic template repository with master branch

set -e

repo_dir="$1"

cd "$repo_dir"
git init
git config user.name "Test"
git config user.email "test@test.com"
git commit --allow-empty -m "Initial commit"
