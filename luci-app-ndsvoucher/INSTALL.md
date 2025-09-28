# Installation Guide for luci-app-ndsvoucher

## Prerequisites

Before installing luci-app-ndsvoucher, ensure your OpenWrt router has the following packages installed:
- `nodogsplash` - The captive portal software
- `jq` - For processing JSON data in shell scripts

These dependencies will be automatically installed when you install luci-app-ndsvoucher.

## Installation Methods

### Method 1: Installing Pre-built Package (Recommended)

If you have a pre-built `.ipk` package:

```bash
# Upload the package to your router
scp luci-app-ndsvoucher_*.ipk root@your-router-ip:/tmp/

# SSH into your router
ssh root@your-router-ip

# Install the package
opkg install /tmp/luci-app-ndsvoucher_*.ipk
```

### Method 2: Building from Source

If you want to build from source:

1. Clone the repository to your OpenWrt SDK environment:
   ```bash
   git clone https://github.com/your-username/luci-app-ndsvoucher.git
   ```

2. Navigate to your OpenWrt SDK directory and build the package:
   ```bash
   cd /path/to/openwrt-sdk
   make package/luci-app-ndsvoucher/compile
   ```

3. Install the resulting package:
   ```bash
   opkg install bin/packages/*/luci-app-ndsvoucher*.ipk
   ```

## Post-Installation Configuration

After installation, the following steps are automatically performed:
1. Data directories are created
2. Initial JSON database files are created
3. NoDogSplash is configured for voucher authentication
4. The service is enabled and started

## Accessing the Interface

### Admin Interface
Access the administrative interface through LuCI:
1. Navigate to `http://your-router-ip/cgi-bin/luci`
2. Go to "Services" → "NDS Voucher"
3. Use the default password `rosepinepink` to log in

### Public Voucher Page
Users will be automatically redirected to the voucher entry page when they connect to the WiFi network and try to access any website.

The direct URL is: `http://your-router-ip:7891/`

## Initial Setup

1. **Change the Admin Password**:
   - Log into the admin interface
   - Go to the "Settings" tab
   - Change the default password to a secure one

2. **Create Vouchers**:
   - Go to the "Vouchers" tab
   - Use the "Add New Voucher" section to create vouchers
   - Specify duration, name, and whether the voucher is reusable

3. **Configure NoDogSplash (if needed)**:
   - The installation script automatically configures NoDogSplash
   - If you need custom configuration, edit `/etc/config/nodogsplash`

## Troubleshooting

### Common Issues

1. **Voucher validation fails**:
   - Check that the voucher code is entered correctly
   - Verify that the voucher hasn't expired or been used (for non-reusable vouchers)
   - Check the system logs: `logread | grep ndsvoucher`

2. **Users cannot access the voucher page**:
   - Verify NoDogSplash is running: `/etc/init.d/nodogsplash status`
   - Check NoDogSplash configuration: `cat /etc/config/nodogsplash`
   - Ensure port 7891 is not blocked by firewall rules

3. **Admin interface not accessible**:
   - Verify the LuCI app is installed: `opkg list-installed | grep ndsvoucher`
   - Restart the web server: `/etc/init.d/uhttpd restart`

### Log Files

- System logs: `/tmp/log/messages` or via `logread`
- NoDogSplash logs: `/tmp/nodogsplash.log`
- Voucher system logs: Currently logs to system log

### Data Files

- Voucher database: `/data/voucher.json`
- Settings: `/data/settings.json`

## Upgrading

To upgrade to a new version:

```bash
# Download and install the new package
opkg install /path/to/new/luci-app-ndsvoucher_*.ipk

# Or if upgrading from a repository
opkg update
opkg upgrade luci-app-ndsvoucher
```

Existing voucher data will be preserved during upgrades.

## Uninstallation

To completely remove the application:

```bash
# Remove the package
opkg remove luci-app-ndsvoucher

# Optionally remove data files
rm -rf /data/voucher.json /data/settings.json

# Optionally remove NoDogSplash configuration
# (Only if you don't need NoDogSplash for other purposes)
```

Note that removing the package will not automatically revert NoDogSplash configuration changes.