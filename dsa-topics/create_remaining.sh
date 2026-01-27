#!/bin/bash

# This script will help identify which files still need to be created
echo "Files that should exist based on index:"
for i in {17..37}; do
    printf "%02d\n" $i
done

echo -e "\nFiles that currently exist:"
ls -1 [0-9][0-9]_*.md 2>/dev/null | sed 's/_.*//g'
