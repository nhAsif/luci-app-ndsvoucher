#!/bin/bash

# Test script to verify package structure

echo "Testing package structure..."

# Check if required directories exist
REQUIRED_DIRS=(
    "luasrc"
    "luasrc/controller"
    "luasrc/model"
    "luasrc/model/cbi"
    "luasrc/model/cbi/ndsvoucher"
    "luasrc/view"
    "luasrc/view/ndsvoucher"
    "root"
    "root/etc"
    "root/etc/config"
    "root/etc/init.d"
    "root/etc/uci-defaults"
    "root/usr"
    "root/usr/share"
    "root/usr/share/ndsvoucher"
    "root/usr/share/ndsvoucher/scripts"
    "root/www"
    "root/www/ndsvoucher"
    "test"
)

echo "Checking required directories..."
for dir in "${REQUIRED_DIRS[@]}"; do
    if [ ! -d "$dir" ]; then
        echo "ERROR: Directory $dir not found!"
        exit 1
    fi
done
echo "All required directories present."

# Check if required files exist
REQUIRED_FILES=(
    "Makefile"
    "luasrc/controller/ndsvoucher.lua"
    "luasrc/model/cbi/ndsvoucher/settings.lua"
    "luasrc/model/cbi/ndsvoucher/vouchers.lua"
    "luasrc/view/ndsvoucher/public_index.htm"
    "luasrc/view/ndsvoucher/voucher_template.htm"
    "root/etc/config/ndsvoucher"
    "root/etc/init.d/ndsvoucher"
    "root/etc/uci-defaults/99-ndsvoucher"
    "root/usr/share/ndsvoucher/scripts/voucher.sh"
    "root/usr/share/ndsvoucher/scripts/binauth.sh"
    "root/usr/share/ndsvoucher/scripts/configure-nodogsplash.sh"
    "root/www/ndsvoucher/index.html"
    "test/test_voucher.sh"
)

echo "Checking required files..."
for file in "${REQUIRED_FILES[@]}"; do
    if [ ! -f "$file" ]; then
        echo "ERROR: File $file not found!"
        exit 1
    fi
done
echo "All required files present."

# Check Makefile
echo "Checking Makefile..."
if ! grep -q "PKG_NAME:=luci-app-ndsvoucher" Makefile; then
    echo "ERROR: PKG_NAME not found in Makefile!"
    exit 1
fi

if ! grep -q "PKG_VERSION:=1.0.0" Makefile; then
    echo "ERROR: PKG_VERSION not found in Makefile!"
    exit 1
fi

if ! grep -q "include \$(TOPDIR)/feeds/luci/luci.mk" Makefile; then
    echo "ERROR: luci.mk include not found in Makefile!"
    exit 1
fi

echo "Makefile checks passed."

echo "Package structure verification complete!"
echo "All checks passed. Package structure is correct."