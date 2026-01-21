#!/usr/bin/env bash
# Verify that directories exist and output results

set -e

base_dir="$1"
shift
dirs=("$@")

all_exist=true
for dir in "${dirs[@]}"; do
    full_path="${base_dir}/${dir}"
    # Handle absolute paths (like .git)
    if [[ "$dir" == /* ]]; then
        full_path="${base_dir}${dir}"
    fi
    
    if [[ -d "$full_path" ]]; then
        echo "EXISTS: ${dir}"
    else
        echo "MISSING: ${dir}"
        all_exist=false
    fi
done

if [[ "$all_exist" == "true" ]]; then
    exit 0
else
    exit 1
fi
