#!/usr/bin/env bash
# Setup template repo with hierarchical branches (parent/child)
# Note: Can't use database/postgresql/migrations because git refs don't allow
# a branch name to be both a file (database/postgresql) and a directory

set -e

repo_dir="$1"

cd "$repo_dir"
git init
git config user.name "Test"
git config user.email "test@test.com"
printf 'base\n' > base.txt
git add base.txt
git commit -m "Initial"

# Parent branch
git checkout -b database/postgresql
printf 'postgresql\n' > postgresql.txt
git add postgresql.txt
git commit -m "Add PostgreSQL"

# Child branch - extends postgresql with migrations
git checkout -b database/postgresql-migrations
printf 'migrations\n' > migrations.txt
git add migrations.txt
git commit -m "Add migrations"

git checkout master
