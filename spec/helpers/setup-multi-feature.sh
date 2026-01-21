#!/usr/bin/env bash
# Setup template repo with multiple independent feature branches

set -e

repo_dir="$1"

cd "$repo_dir"
git init
git config user.name "Test"
git config user.email "test@test.com"
printf 'base file\n' > base.txt
git add base.txt
git commit -m "Initial commit"

# Feature 1: auth
git checkout -b feature/auth
printf 'auth feature\n' > auth.txt
git add auth.txt
git commit -m "Add auth"

# Feature 2: logging
git checkout master
git checkout -b feature/logging
printf 'logging feature\n' > logging.txt
git add logging.txt
git commit -m "Add logging"

# Feature 3: database
git checkout master
git checkout -b feature/database
printf 'database feature\n' > database.txt
git add database.txt
git commit -m "Add database"

git checkout master
