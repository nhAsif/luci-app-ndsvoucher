# LuCI App for NoDogSplash Voucher Management

## Overview

This project provides a complete replacement for the original RoseNet Access Portal, implementing all functionality as a LuCI application for OpenWrt routers. The solution eliminates the need for the Go-based voucher server and instead uses shell scripts with JSON-based storage.

## Key Features

1. **Pure Shell Script Implementation**: All backend functionality is implemented using shell scripts, eliminating the need for compiled binaries.

2. **JSON-Based Database**: Uses simple JSON files for data storage instead of SQLite, making the system lighter and easier to manage.

3. **LuCI Integration**: Fully integrated with the LuCI web interface for both administration and user-facing pages.

4. **NoDogSplash Compatibility**: Maintains full compatibility with NoDogSplash for captive portal functionality.

5. **Responsive Design**: Mobile-friendly interfaces for both admin and user pages.

## Components

### 1. LuCI Controller (`luasrc/controller/ndsvoucher.lua`)

Handles all HTTP requests and routes them to appropriate handlers:
- Admin interface for voucher management
- Public voucher entry page
- API endpoints for voucher operations

### 2. Shell Scripts (`root/usr/share/ndsvoucher/scripts/`)

Provides all backend functionality:
- `voucher.sh`: Main script for voucher management operations
- `binauth.sh`: NoDogSplash authentication script
- `configure-nodogsplash.sh`: Script to configure NoDogSplash integration

### 3. JSON Database

Simple JSON files for data storage:
- `/data/voucher.json`: Stores all voucher information
- `/data/settings.json`: Stores configuration settings

### 4. Web Interfaces

- **Admin Interface**: LuCI-based interface for managing vouchers
- **Public Interface**: User-facing page for voucher entry

### 5. Configuration Files

- UCI configuration for the application
- NoDogSplash configuration
- System init scripts

## Implementation Details

### Voucher Management

Vouchers are stored in a JSON array with the following structure:
```json
{
  "id": 1,
  "code": "abcd1234",
  "name": "Test Voucher",
  "duration": 60,
  "is_reusable": false,
  "is_used": false,
  "created_at": "2023-01-01T00:00:00Z",
  "start_time": "2023-01-01T01:00:00Z",
  "user_ip": "192.168.1.100",
  "user_mac": "00:11:22:33:44:55"
}
```

### Authentication Flow

1. User connects to WiFi network
2. NoDogSplash redirects to voucher entry page
3. User enters voucher code
4. LuCI controller validates voucher via shell script
5. If valid, voucher is marked as used
6. User is redirected to NoDogSplash authentication
7. NoDogSplash calls binauth script
8. binauth script validates user against JSON database
9. If valid, NoDogSplash grants internet access

### Admin Functions

- Add new vouchers (with custom or auto-generated codes)
- List existing vouchers
- Delete vouchers
- Change admin password
- Configure system settings

## Advantages Over Original Implementation

1. **No Compiled Binaries**: Pure shell scripts are easier to modify and debug
2. **Lighter Resource Usage**: No need to run a separate Go server process
3. **Simpler Deployment**: Single package installation via opkg
4. **Integrated Management**: All configuration through LuCI interface
5. **Easier Customization**: Shell scripts are more accessible than Go code

## Dependencies

- `nodogsplash`: Captive portal software
- `jq`: JSON processing in shell scripts
- `jsonfilter`: JSON parsing in LuCI
- `curl`: HTTP requests in binauth script

## Installation

The application is built as a standard OpenWrt package and can be installed via opkg:
```bash
opkg install luci-app-ndsvoucher
```

After installation, the application will be available in the LuCI interface under "Services" -> "NDS Voucher".

## Configuration

The application can be configured through:
1. LuCI web interface
2. UCI command line (`uci set ndsvoucher...`)
3. Editing `/etc/config/ndsvoucher` directly

Default settings:
- Admin password: `rosepinepink`
- Data directory: `/data`
- Server port: 7891 (for compatibility with existing setups)

## Security Considerations

- Admin password should be changed after installation
- Voucher codes should be sufficiently random to prevent guessing
- JSON database files should have appropriate permissions
- Communication between components happens locally, so no encryption is needed

## Future Enhancements

1. Add voucher expiration dates
2. Implement data limits in addition to time limits
3. Add voucher groups/roles
4. Implement usage statistics and reporting
5. Add support for QR code generation for vouchers
6. Implement voucher printing functionality