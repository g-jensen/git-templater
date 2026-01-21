#!/usr/bin/env bash
# Verify that files exist in a directory and output results

set -e

target_dir="$1"
shift
files=("$@")

all_exist=true
for file in "${files[@]}"; do
    if [[ -f "${target_dir}/${file}" ]]; then
        echo "EXISTS: ${file}"
    else
        echo "MISSING: ${file}"
        all_exist=false
    fi
done

if [[ "$all_exist" == "true" ]]; then
    exit 0
else
    exit 1
fi
