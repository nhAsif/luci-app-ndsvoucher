#!/bin/sh

# This script should be run on the OpenWRT router after installing the luci-app-ndsvoucher package.
# It configures the system for the voucher system.

echo "Setting up voucher system..."

# 1. Create directories
echo "Creating directories..."
mkdir -p /data # For the persistent database

# 2. Ensure the binauth script is in the right place and executable
echo "Setting up binauth script..."
mkdir -p /usr/share/ndsvoucher/scripts
cp "$(dirname "$0")/binauth.sh" /usr/share/ndsvoucher/scripts/
chmod +x /usr/share/ndsvoucher/scripts/binauth.sh

# 3. Ensure the init script is in place
echo "Setting up init script..."
cp /etc/init.d/ndsvoucher /etc/init.d/voucher 2>/dev/null || true
chmod +x /etc/init.d/voucher
/etc/init.d/voucher enable
/etc/init.d/voucher start

# 5. Configure NoDogSplash
echo "Configuring NoDogSplash..."

if [ ! -f /etc/init.d/nodogsplash ]; then
    echo "Error: NoDogSplash service not found at /etc/init.d/nodogsplash."
    echo "Please install NoDogSplash first by running: opkg update && opkg install nodogsplash"
    exit 1
fi

# Use the luci-app-ndsvoucher script to configure NoDogSplash
/usr/share/ndsvoucher/scripts/configure-nodogsplash.sh 2>/dev/null || true


# 6. The splash page will be created by the configure-nodogsplash.sh script

# 7. Restart NoDogSplash to apply changes
echo "Restarting NoDogSplash..."
/etc/init.d/nodogsplash restart

echo "Installation complete!"
echo "Your voucher system should be running and integrated with NoDogSplash."
echo "You can access the admin panel through the LuCI interface under Services -> NDS Voucher."
