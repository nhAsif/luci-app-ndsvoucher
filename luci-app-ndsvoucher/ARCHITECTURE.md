# NDS Voucher System Architecture

## Overview

This diagram shows the architecture of the NDS Voucher System implemented as a LuCI app for OpenWrt routers.

```mermaid
graph TB
    A[WiFi Client] --> B[NoDogSplash]
    B --> C[Voucher Entry Page]
    C --> D[LuCI Controller]
    D --> E[Shell Scripts]
    E --> F[JSON Database]
    B --> G[BinAuth Script]
    G --> E
    H[LuCI Admin Interface] --> D

    style A fill:#ffe4c4,stroke:#333
    style B fill:#dda0dd,stroke:#333
    style C fill:#87ceeb,stroke:#333
    style D fill:#98fb98,stroke:#333
    style E fill:#ffb6c1,stroke:#333
    style F fill:#fffacd,stroke:#333
    style G fill:#ffb6c1,stroke:#333
    style H fill:#87ceeb,stroke:#333

    linkStyle 0 stroke:#0000ff,fill:none
    linkStyle 1 stroke:#0000ff,fill:none
    linkStyle 2 stroke:#0000ff,fill:none
    linkStyle 3 stroke:#0000ff,fill:none
    linkStyle 4 stroke:#0000ff,fill:none
    linkStyle 5 stroke:#0000ff,fill:none
    linkStyle 6 stroke:#0000ff,fill:none
```

## Components

### 1. WiFi Client
The end user connecting to the WiFi network.

### 2. NoDogSplash
The captive portal software that intercepts unauthenticated traffic and redirects users to the voucher entry page.

### 3. Voucher Entry Page
A web page served by the LuCI controller where users enter their voucher codes.

### 4. LuCI Controller
The main component that handles HTTP requests and serves both the admin interface and the public voucher entry page.

### 5. Shell Scripts
Backend scripts that perform all the actual work:
- Voucher management (add, delete, list, validate)
- Authentication
- Database operations

### 6. JSON Database
Simple JSON files that store voucher data and settings:
- `/data/voucher.json` - Stores voucher information
- `/data/settings.json` - Stores configuration settings

### 7. BinAuth Script
A script called by NoDogSplash to authenticate clients after they've entered a valid voucher.

### 8. LuCI Admin Interface
The administrative interface accessible through the LuCI web interface for managing vouchers.

## Data Flow

1. **User Authentication Flow**:
   - WiFi client connects to network
   - NoDogSplash redirects client to voucher entry page
   - User enters voucher code
   - LuCI controller validates voucher via shell scripts
   - If valid, voucher is marked as used and client is redirected to NoDogSplash auth
   - NoDogSplash calls BinAuth script to verify authentication
   - BinAuth script checks JSON database for valid voucher
   - If found, NoDogSplash grants internet access

2. **Admin Management Flow**:
   - Administrator accesses LuCI interface
   - LuCI controller serves admin pages
   - Admin performs actions (add/delete vouchers, change settings)
   - Controller calls shell scripts to modify JSON database