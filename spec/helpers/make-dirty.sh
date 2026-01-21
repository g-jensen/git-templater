#!/usr/bin/env bash
# Make target repo dirty with uncommitted changes

set -e

target_dir="$1"

cd "$target_dir"
printf 'modified content\n' > existing.txt
