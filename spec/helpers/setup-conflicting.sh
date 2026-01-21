#!/usr/bin/env bash
# Setup template repo with branches that modify the same file (for merge strategy testing)

set -e

repo_dir="$1"

cd "$repo_dir"
git init
git config user.name "Test"
git config user.email "test@test.com"
printf 'base content\n' > shared.txt
git add shared.txt
git commit -m "Initial"

git checkout -b feature/one
printf 'feature one\n' >> shared.txt
git add shared.txt
git commit -m "Feature one"

git checkout master
git checkout -b feature/two
printf 'feature two\n' >> shared.txt
git add shared.txt
git commit -m "Feature two"

git checkout master
