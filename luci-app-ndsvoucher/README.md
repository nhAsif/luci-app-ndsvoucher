# luci-app-ndsvoucher

A LuCI application for managing NoDogSplash vouchers on OpenWrt routers.

## Features

*   **Voucher Management**: Create, list, and delete vouchers through the LuCI web interface
*   **JSON-based Database**: Uses JSON files for storing voucher data instead of a database server
*   **Shell Script Backend**: Pure shell script implementation without requiring a Go server
*   **NoDogSplash Integration**: Seamless integration with NoDogSplash for captive portal functionality
*   **Responsive Web Interface**: Mobile-friendly interface built with LuCI

## Installation

1. Clone this repository to your OpenWrt SDK environment
2. Run `make package/luci-app-ndsvoucher/compile` to build the package
3. Install the resulting `.ipk` file on your OpenWrt router

## Configuration

After installation, the application will be available in the LuCI interface under "Services" -> "NDS Voucher".

The default admin password is `rosepinepink`. You can change this in the settings page.

## Usage

1. Navigate to the NDS Voucher page in LuCI
2. Create vouchers with custom names, codes, and durations
3. Users will be redirected to a voucher entry page when they connect to the WiFi network
4. Users enter a valid voucher code to gain internet access for the specified duration

## Technical Details

*   **Data Storage**: Voucher data is stored in `/data/voucher.json`
*   **Settings Storage**: Configuration is stored in `/data/settings.json`
*   **Scripts**: All backend functionality is implemented in shell scripts located in `/usr/share/ndsvoucher/scripts/`
*   **NoDogSplash Integration**: Uses a custom binauth script to authenticate users

## Dependencies

*   `nodogsplash` - The captive portal software
*   `jsonfilter` - For parsing JSON data in shell scripts
*   `curl` - For making HTTP requests
*   `jq` - For processing JSON data in shell scripts

## License

This project is licensed under the MIT License.