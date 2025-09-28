#!/bin/bash

# Test script to verify the build process works correctly

echo "Testing build process..."

# Check if required files exist
REQUIRED_FILES=(
    ".github/workflows/release.yml"
    "luci-app-ndsvoucher/Makefile"
    "luci-app-ndsvoucher/version"
)

echo "Checking required files..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: Required file $file not found!"
        exit 1
    fi
    echo "Found: $file"
done

# Check Makefile version
echo "Checking Makefile version..."
VERSION=$(grep 'PKG_VERSION:=' luci-app-ndsvoucher/Makefile | awk -F '=' '{print $2}')
if [ -z "$VERSION" ]; then
    echo "ERROR: Could not extract version from Makefile!"
    exit 1
fi
echo "Makefile version: $VERSION"

# Check version file
echo "Checking version file..."
VERSION_FILE=$(cat luci-app-ndsvoucher/version)
if [ -z "$VERSION_FILE" ]; then
    echo "ERROR: Could not read version from version file!"
    exit 1
fi
echo "Version file: $VERSION_FILE"

# Verify versions match
if [ "$VERSION" != "$VERSION_FILE" ]; then
    echo "ERROR: Version mismatch between Makefile ($VERSION) and version file ($VERSION_FILE)!"
    exit 1
fi

echo "Versions match correctly."

# Check release workflow
echo "Checking release workflow..."
if [ ! -f ".github/workflows/release.yml" ]; then
    echo "ERROR: Release workflow not found!"
    exit 1
fi

# Check for version detection in workflow
if ! grep -q "PKG_VERSION:=" .github/workflows/release.yml; then
    echo "WARNING: Version detection not found in release workflow!"
fi

echo "Build process verification complete!"
echo "All checks passed. The build process should work correctly."

exit 0