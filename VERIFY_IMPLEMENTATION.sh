#!/bin/bash

# Verification script for the LuCI app implementation

echo "Verifying LuCI app implementation..."

# Check if required directories exist
echo "Checking directory structure..."
REQUIRED_DIRS=(
    "luci-app-ndsvoucher"
    "luci-app-ndsvoucher/luasrc"
    "luci-app-ndsvoucher/luasrc/controller"
    "luci-app-ndsvoucher/luasrc/model"
    "luci-app-ndsvoucher/luasrc/model/cbi"
    "luci-app-ndsvoucher/luasrc/model/cbi/ndsvoucher"
    "luci-app-ndsvoucher/luasrc/view"
    "luci-app-ndsvoucher/luasrc/view/ndsvoucher"
    "luci-app-ndsvoucher/root"
    "luci-app-ndsvoucher/root/etc"
    "luci-app-ndsvoucher/root/etc/config"
    "luci-app-ndsvoucher/root/etc/init.d"
    "luci-app-ndsvoucher/root/etc/uci-defaults"
    "luci-app-ndsvoucher/root/usr"
    "luci-app-ndsvoucher/root/usr/share"
    "luci-app-ndsvoucher/root/usr/share/ndsvoucher"
    "luci-app-ndsvoucher/root/usr/share/ndsvoucher/scripts"
    "luci-app-ndsvoucher/root/www"
    "luci-app-ndsvoucher/root/www/ndsvoucher"
    "luci-app-ndsvoucher/test"
    "scripts"
    "nodogsplash"
)

for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "ERROR: Directory $dir not found!"
        exit 1
    fi
done

echo "All required directories present."

# Check if required files exist
echo "Checking required files..."
REQUIRED_FILES=(
    "luci-app-ndsvoucher/Makefile"
    "luci-app-ndsvoucher/luasrc/controller/ndsvoucher.lua"
    "luci-app-ndsvoucher/luasrc/model/cbi/ndsvoucher/settings.lua"
    "luci-app-ndsvoucher/luasrc/model/cbi/ndsvoucher/vouchers.lua"
    "luci-app-ndsvoucher/luasrc/view/ndsvoucher/public_index.htm"
    "luci-app-ndsvoucher/luasrc/view/ndsvoucher/voucher_template.htm"
    "luci-app-ndsvoucher/root/etc/config/ndsvoucher"
    "luci-app-ndsvoucher/root/etc/init.d/ndsvoucher"
    "luci-app-ndsvoucher/root/etc/uci-defaults/99-ndsvoucher"
    "luci-app-ndsvoucher/root/usr/share/ndsvoucher/scripts/voucher.sh"
    "luci-app-ndsvoucher/root/usr/share/ndsvoucher/scripts/binauth.sh"
    "luci-app-ndsvoucher/root/usr/share/ndsvoucher/scripts/configure-nodogsplash.sh"
    "luci-app-ndsvoucher/root/www/ndsvoucher/index.html"
    "luci-app-ndsvoucher/test/test_voucher.sh"
    "scripts/binauth.sh"
    "scripts/install.sh"
    "nodogsplash/nodogsplash.conf"
    "README.md"
    "LICENSE"
)

for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: File $file not found!"
        exit 1
    fi
done

echo "All required files present."

# Check if old files have been removed
echo "Checking for removed files..."
REMOVED_FILES=(
    "backend"
    "frontend"
    "build.bat"
    "go.mod"
    "go.sum"
    "scripts/build.sh"
)

for file in "${REMOVED_FILES[@]}"; do
    if [ -e "$file" ]; then
        echo "ERROR: Old file/directory $file still present!"
        exit 1
    fi
done

echo "All old files properly removed."

# Check GitHub workflow
echo "Checking GitHub workflow..."
if [ ! -f ".github/workflows/release.yml" ]; then
    echo "ERROR: GitHub workflow file not found!"
    exit 1
fi

echo "GitHub workflow file present."

# Check documentation files
echo "Checking documentation..."
REQUIRED_DOCS=(
    "luci-app-ndsvoucher/README.md"
    "luci-app-ndsvoucher/INSTALL.md"
    "luci-app-ndsvoucher/ARCHITECTURE.md"
    "luci-app-ndsvoucher/SUMMARY.md"
    "luci-app-ndsvoucher/IMPLEMENTATION_OVERVIEW.md"
    "luci-app-ndsvoucher/DIRECTORY_STRUCTURE.md"
    "MIGRATION_SUMMARY.md"
)

for doc in "${REQUIRED_DOCS[@]}"; do
    if [ ! -f "$doc" ]; then
        echo "ERROR: Documentation file $doc not found!"
        exit 1
    fi
done

echo "All documentation files present."

echo "Implementation verification complete!"
echo "The LuCI app implementation is ready for production."

exit 0