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

git checkout -b feature/core
printf 'core\n' > core.txt
git add core.txt
git commit -m "Add core"

git checkout -b feature/web
printf 'web\n' > web.txt
printf 'dependencies:\n  - feature/core\n' > .template-deps.yaml
git add web.txt .template-deps.yaml
git commit -m "Add web (depends on core)"

git checkout feature/core
git checkout -b feature/cli
printf 'cli\n' > cli.txt
printf 'dependencies:\n  - feature/core\n' > .template-deps.yaml
git add cli.txt .template-deps.yaml
git commit -m "Add cli (depends on core)"

git checkout feature/core
printf 'core-updated\n' > core.txt
git add core.txt
git commit -m "Update core"
