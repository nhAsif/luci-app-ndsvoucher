#!/bin/bash

# Script to update the version in Makefile

if [ $# -ne 1 ]; then
    echo "Usage: $0 <new_version>"
    exit 1
fi

NEW_VERSION=$1

# Update the version in Makefile
sed -i "s/PKG_VERSION:=.*/PKG_VERSION:=$NEW_VERSION/" Makefile

# Update the version file
echo "$NEW_VERSION" > version

echo "Version updated to $NEW_VERSION"