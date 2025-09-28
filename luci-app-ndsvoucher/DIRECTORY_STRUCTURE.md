# Directory Structure

```
luci-app-ndsvoucher/
├── ARCHITECTURE.md
├── DIRECTORY_STRUCTURE.md
├── INSTALL.md
├── Makefile
├── README.md
├── SUMMARY.md
├── luasrc/
│   ├── controller/
│   │   └── ndsvoucher.lua
│   ├── model/
│   │   └── cbi/
│   │       ├── ndsvoucher/
│   │       │   ├── settings.lua
│   │       │   └── vouchers.lua
│   └── view/
│       └── ndsvoucher/
│           ├── public_index.htm
│           └── voucher_template.htm
├── root/
│   ├── etc/
│   │   ├── config/
│   │   │   └── ndsvoucher
│   │   ├── init.d/
│   │   │   └── ndsvoucher
│   │   └── uci-defaults/
│   │       └── 99-ndsvoucher
│   └── usr/
│       └── share/
│           └── ndsvoucher/
│               └── scripts/
│                   ├── binauth.sh
│                   ├── configure-nodogsplash.sh
│                   └── voucher.sh
├── test/
│   └── test_voucher.sh
└── www/
    └── ndsvoucher/
        └── index.html
```

## Directory Descriptions

### Root Directory
- `Makefile`: Package build configuration
- `README.md`: Project overview
- `INSTALL.md`: Installation instructions
- `ARCHITECTURE.md`: System architecture documentation
- `SUMMARY.md`: Implementation summary
- `DIRECTORY_STRUCTURE.md`: This file

### luasrc/
Contains LuCI application source code:
- `controller/ndsvoucher.lua`: HTTP request routing and API endpoints
- `model/cbi/ndsvoucher/`: Configuration pages for LuCI
- `view/ndsvoucher/`: HTML templates for web interfaces

### root/
Files that will be installed to the target system:
- `etc/config/ndsvoucher`: UCI configuration file
- `etc/init.d/ndsvoucher`: System service control script
- `etc/uci-defaults/99-ndsvoucher`: Initial configuration script
- `usr/share/ndsvoucher/scripts/`: Backend shell scripts

### test/
- `test_voucher.sh`: Simple test script for verifying functionality

### www/
- `ndsvoucher/index.html`: Public voucher entry page