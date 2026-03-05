#!/usr/bin/env bash
set -e

local_dir="$1"
remote_dir="$2"

mkdir -p "$remote_dir"
cd "$remote_dir"
git init --bare

cd "$local_dir"
git init
git config user.name "Test"
git config user.email "test@test.com"
printf 'base\n' > base.txt
git add base.txt
git commit -m "Initial"
git remote add origin "$remote_dir"
git push -u origin master

git checkout -b feature/auth
printf 'auth\n' > auth.txt
git add auth.txt
git commit -m "Add auth"
git push -u origin feature/auth

git checkout master
git checkout -b feature/logging
printf 'logging\n' > logging.txt
git add logging.txt
git commit -m "Add logging"
git push -u origin feature/logging

git checkout master
