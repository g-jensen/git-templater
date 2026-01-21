#!/usr/bin/env bash
# Extract just the branch names from list output (removing header and formatting)

set -e

# Read from stdin, skip header lines, extract branch names
grep -v "^Available branches" | grep -v "^$" | sed 's/^[* ]*//' | sed 's/ .*//'
