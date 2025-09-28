# RoseNet Access Portal

## OpenWrt WiFi Voucher System

RoseNet Access Portal is a comprehensive, self-contained voucher authentication system designed for Wi-Fi users on OpenWrt routers. It provides a robust and lightweight solution for managing internet access through a captive portal, implemented as a LuCI application with shell script backend and seamless integration with NoDogSplash.

**Note: This repository now contains two implementations:**
1. The original Go-based implementation (deprecated)
2. The new LuCI app implementation (recommended)

## Table of Contents

- [Features](#features)
- [System Architecture](#system-architecture)
- [Components](#components)
- [Installation & Deployment](#installation--deployment)
- [Usage](#usage)
  - [User Portal](#user-portal)
  - [Administrator Panel](#administrator-panel)
- [Configuration](#configuration)
- [API Endpoints](#api-endpoints)
- [Contributing](#contributing)
- [License](#license)

## Features

*   **Lightweight & Efficient**: Optimized for resource-constrained OpenWrt environments.
*   **Shell Script Backend**: Easy modification and debugging without compilation.
*   **LuCI Integration**: Fully integrated with the OpenWrt LuCI web interface.
*   **JSON-based Database**: Simple data storage using JSON files.
*   **Integrated Captive Portal**: Seamlessly works with NoDogSplash for user redirection and authentication.
*   **Voucher Management**: Administrators can generate, manage, and revoke time-limited access vouchers.
*   **Secure Admin Panel**: Dedicated interface for voucher administration with password protection.

## System Architecture

The RoseNet Access Portal operates entirely on the OpenWrt router, comprising three core components that work in concert to deliver the captive portal experience:

1.  **LuCI App (`luci-app-ndsvoucher`)**: Provides the administrative interface and user voucher entry page through the LuCI web interface.
2.  **Shell Script Backend**: Handles all voucher management and authentication logic through shell scripts.
3.  **NoDogSplash**: The captive portal software responsible for intercepting unauthenticated traffic and redirecting users to the RoseNet Access Portal.

## Components

### LuCI App (`luci-app-ndsvoucher`)

*   **Language**: Shell scripts with LuCI integration
*   **Database**: JSON files
*   **Database Location (on router)**: `/data/voucher.json`
*   **Configuration**: `/etc/config/ndsvoucher`

### Web Interface

Designed for integration with the LuCI web interface.

*   **User Voucher Page**: The initial page users encounter, featuring a form for voucher code entry.
*   **Administrator Panel**: Integrated into the LuCI interface for comprehensive voucher management.

### NoDogSplash Integration

The integration with NoDogSplash is fundamental to the captive portal functionality:

1.  A user connects to the Wi-Fi network.
2.  NoDogSplash intercepts the user's initial HTTP request and redirects them to its `splash.html` page (`/etc/nodogsplash/htdocs/splash.html`).
3.  This `splash.html` contains a meta-refresh that immediately redirects the user to the RoseNet Access Portal's Go-powered voucher page (e.g., `http://192.168.100.1:7891`), forwarding essential parameters like `ip`, `mac`, and `token`.
4.  The user enters a valid voucher code on the `index.html` page.
5.  The frontend JavaScript validates the voucher with the Go backend.
6.  Upon successful validation, the JavaScript constructs a special NoDogSplash authentication URL (e.g., `http://192.168.100.1:2050/nodogsplash_auth/?tok=...`) and redirects the user.
7.  NoDogSplash processes this request, validates the token, and grants the user internet access for the duration specified by the voucher.

## Installation & Deployment

RoseNet Access Portal can be deployed on your OpenWrt router either by building from source or by using pre-compiled packages from GitHub Releases.

### Method 1: Building from Source (Recommended)

Follow these steps to build the LuCI app package and deploy it on your OpenWrt router:

1.  **Clone the Repository**:
    Clone this repository to your OpenWrt SDK environment.

2.  **Build the Package**:
    Run `make package/luci-app-ndsvoucher/compile` to build the package.

3.  **Install the Package**:
    Copy the resulting `.ipk` file to your OpenWrt router and install it using `opkg install`.

    ```bash
    # Example using scp to copy the package
    scp bin/packages/*/luci-app-ndsvoucher*.ipk root@your_router_ip:/tmp/
    
    # SSH into your router and install the package
    ssh root@your_router_ip
    opkg install /tmp/luci-app-ndsvoucher*.ipk
    ```

### Method 2: Using Pre-compiled Release Packages

This method is recommended for users who do not wish to set up an OpenWrt SDK environment.

1.  **Download the Release Package**:
    Go to the [GitHub Releases page](https://github.com/nhAsif/RoseNet-Access-Portal/releases)
    Download the appropriate release package (e.g., `luci-app-ndsvoucher_*.ipk`).

2.  **Install the Package**:
    Copy the downloaded `.ipk` file to your OpenWrt router and install it using `opkg install`.

    ```bash
    # Example using scp to copy the package
    scp luci-app-ndsvoucher_*.ipk root@your_router_ip:/tmp/
    
    # SSH into your router and install the package
    ssh root@your_router_ip
    opkg install /tmp/luci-app-ndsvoucher_*.ipk
    ```

## Usage

### User Portal

Users connecting to your Wi-Fi network will be redirected to the voucher entry page. They can enter a valid voucher code to gain internet access.

### Administrator Panel

Access the administrator panel through the LuCI web interface under "Services" -> "NDS Voucher".
*   **Default Password**: `rosepinepink` (This is the initial default password. It is highly recommended to change this from the admin panel after the first login for security.).
*   **Features**:
    *   Secure login through LuCI.
    *   View a list of all active and expired vouchers.
    *   Add new vouchers with specified durations.
    *   Delete existing vouchers by ID.

## Configuration

*   **Default Admin Password**: The default administrator password is `rosepinepink`. This can be changed from the administrator panel after the first login. **It is strongly advised to change this to a strong, unique password before deploying the system in a production environment.**
*   **NoDogSplash Configuration**: The package automatically configures NoDogSplash. Review `/etc/config/nodogsplash` and `/etc/nodogsplash/htdocs/splash.html` if you need to customize NoDogSplash behavior further.

## API Endpoints

The LuCI app handles all API interactions internally through the web interface. No direct API access is provided.

## Contributing

Contributions are welcome! Please feel free to submit issues, feature requests, or pull requests.

For developers interested in contributing to the LuCI app implementation, please focus on the `luci-app-ndsvoucher` directory.

## License

This project is licensed under the [MIT License](LICENSE).
