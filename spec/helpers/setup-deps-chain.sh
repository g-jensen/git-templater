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

git checkout -b feature/base-lib
printf 'base-lib\n' > base-lib.txt
git add base-lib.txt
git commit -m "Add base-lib"

git checkout -b feature/middleware
printf 'middleware\n' > middleware.txt
printf 'dependencies:\n  - feature/base-lib\n' > .template-deps.yaml
git add middleware.txt .template-deps.yaml
git commit -m "Add middleware (depends on base-lib)"

git checkout -b feature/api
printf 'api\n' > api.txt
printf 'dependencies:\n  - feature/middleware\n' > .template-deps.yaml
git add api.txt .template-deps.yaml
git commit -m "Add api (depends on middleware)"

git checkout feature/base-lib
printf 'base-lib-updated\n' > base-lib.txt
git add base-lib.txt
git commit -m "Update base-lib"
