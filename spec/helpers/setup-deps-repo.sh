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

git checkout -b feature/auth
printf 'auth\n' > auth.txt
git add auth.txt
git commit -m "Add auth"

git checkout master
git checkout -b feature/logging
printf 'logging\n' > logging.txt
git add logging.txt
git commit -m "Add logging"

git checkout master
git checkout -b feature/database
printf 'database\n' > database.txt
git add database.txt
git commit -m "Add database"

git checkout master
