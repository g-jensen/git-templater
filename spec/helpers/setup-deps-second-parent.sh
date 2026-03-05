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

git checkout -b feature/utils
printf 'utils\n' > utils.txt
git add utils.txt
git commit -m "Add utils"

git checkout master
git checkout -b feature/auth
printf 'auth\n' > auth.txt
git add auth.txt
git commit -m "Add auth"

git checkout -b feature/app
printf 'app\n' > app.txt
printf 'dependencies:\n  - feature/utils\n  - feature/auth\n' > .template-deps.yaml
git add app.txt .template-deps.yaml
git commit -m "Add app (depends on utils and auth)"

git checkout feature/auth
printf 'auth-updated\n' > auth.txt
git add auth.txt
git commit -m "Update auth"
