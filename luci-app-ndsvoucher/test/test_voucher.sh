#!/bin/sh

# Test script for voucher system

echo "Testing voucher system..."

# Create test data directory
mkdir -p /tmp/test-data

# Set environment variables for testing
export DATA_DIR="/tmp/test-data"
export VOUCHER_DB="$DATA_DIR/voucher.json"
export SETTINGS_FILE="$DATA_DIR/settings.json"

# Initialize test database
echo "[]" > "$VOUCHER_DB"
echo "{\"admin_password\": \"testpassword\"}" > "$SETTINGS_FILE"

# Test voucher generation
echo "Testing voucher generation..."
voucher_code=$(/usr/share/ndsvoucher/scripts/voucher.sh generate-code)
echo "Generated voucher code: $voucher_code"

# Test adding a voucher
echo "Testing adding a voucher..."
/usr/share/ndsvoucher/scripts/voucher.sh add "Test Voucher" "" "60" "0"

# Test listing vouchers
echo "Testing listing vouchers..."
/usr/share/ndsvoucher/scripts/voucher.sh list

# Test validating a voucher
echo "Testing voucher validation..."
/usr/share/ndsvoucher/scripts/voucher.sh validate "$voucher_code"

# Test admin authentication
echo "Testing admin authentication..."
/usr/share/ndsvoucher/scripts/voucher.sh authenticate "testpassword"

# Clean up
rm -rf /tmp/test-data

echo "Tests completed."