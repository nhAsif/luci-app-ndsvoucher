@echo off
echo Testing package structure...

echo Checking required directories...
if not exist "luasrc" (
    echo ERROR: Directory luasrc not found!
    exit /b 1
)
if not exist "luasrc\controller" (
    echo ERROR: Directory luasrc\controller not found!
    exit /b 1
)
if not exist "luasrc\model" (
    echo ERROR: Directory luasrc\model not found!
    exit /b 1
)
if not exist "luasrc\model\cbi" (
    echo ERROR: Directory luasrc\model\cbi not found!
    exit /b 1
)
if not exist "luasrc\model\cbi\ndsvoucher" (
    echo ERROR: Directory luasrc\model\cbi\ndsvoucher not found!
    exit /b 1
)
if not exist "luasrc\view" (
    echo ERROR: Directory luasrc\view not found!
    exit /b 1
)
if not exist "luasrc\view\ndsvoucher" (
    echo ERROR: Directory luasrc\view\ndsvoucher not found!
    exit /b 1
)
if not exist "root" (
    echo ERROR: Directory root not found!
    exit /b 1
)
if not exist "root\etc" (
    echo ERROR: Directory root\etc not found!
    exit /b 1
)
if not exist "root\etc\config" (
    echo ERROR: Directory root\etc\config not found!
    exit /b 1
)
if not exist "root\etc\init.d" (
    echo ERROR: Directory root\etc\init.d not found!
    exit /b 1
)
if not exist "root\etc\uci-defaults" (
    echo ERROR: Directory root\etc\uci-defaults not found!
    exit /b 1
)
if not exist "root\usr" (
    echo ERROR: Directory root\usr not found!
    exit /b 1
)
if not exist "root\usr\share" (
    echo ERROR: Directory root\usr\share not found!
    exit /b 1
)
if not exist "root\usr\share\ndsvoucher" (
    echo ERROR: Directory root\usr\share\ndsvoucher not found!
    exit /b 1
)
if not exist "root\usr\share\ndsvoucher\scripts" (
    echo ERROR: Directory root\usr\share\ndsvoucher\scripts not found!
    exit /b 1
)
if not exist "root\www" (
    echo ERROR: Directory root\www not found!
    exit /b 1
)
if not exist "root\www\ndsvoucher" (
    echo ERROR: Directory root\www\ndsvoucher not found!
    exit /b 1
)
if not exist "test" (
    echo ERROR: Directory test not found!
    exit /b 1
)
echo All required directories present.

echo Checking required files...
if not exist "Makefile" (
    echo ERROR: File Makefile not found!
    exit /b 1
)
if not exist "luasrc\controller\ndsvoucher.lua" (
    echo ERROR: File luasrc\controller\ndsvoucher.lua not found!
    exit /b 1
)
if not exist "luasrc\model\cbi\ndsvoucher\settings.lua" (
    echo ERROR: File luasrc\model\cbi\ndsvoucher\settings.lua not found!
    exit /b 1
)
if not exist "luasrc\model\cbi\ndsvoucher\vouchers.lua" (
    echo ERROR: File luasrc\model\cbi\ndsvoucher\vouchers.lua not found!
    exit /b 1
)
if not exist "luasrc\view\ndsvoucher\public_index.htm" (
    echo ERROR: File luasrc\view\ndsvoucher\public_index.htm not found!
    exit /b 1
)
if not exist "luasrc\view\ndsvoucher\voucher_template.htm" (
    echo ERROR: File luasrc\view\ndsvoucher\voucher_template.htm not found!
    exit /b 1
)
if not exist "root\etc\config\ndsvoucher" (
    echo ERROR: File root\etc\config\ndsvoucher not found!
    exit /b 1
)
if not exist "root\etc\init.d\ndsvoucher" (
    echo ERROR: File root\etc\init.d\ndsvoucher not found!
    exit /b 1
)
if not exist "root\etc\uci-defaults\99-ndsvoucher" (
    echo ERROR: File root\etc\uci-defaults\99-ndsvoucher not found!
    exit /b 1
)
if not exist "root\usr\share\ndsvoucher\scripts\voucher.sh" (
    echo ERROR: File root\usr\share\ndsvoucher\scripts\voucher.sh not found!
    exit /b 1
)
if not exist "root\usr\share\ndsvoucher\scripts\binauth.sh" (
    echo ERROR: File root\usr\share\ndsvoucher\scripts\binauth.sh not found!
    exit /b 1
)
if not exist "root\usr\share\ndsvoucher\scripts\configure-nodogsplash.sh" (
    echo ERROR: File root\usr\share\ndsvoucher\scripts\configure-nodogsplash.sh not found!
    exit /b 1
)
if not exist "root\www\ndsvoucher\index.html" (
    echo ERROR: File root\www\ndsvoucher\index.html not found!
    exit /b 1
)
if not exist "test\test_voucher.sh" (
    echo ERROR: File test\test_voucher.sh not found!
    exit /b 1
)
echo All required files present.

echo Checking Makefile...
findstr "PKG_NAME:=luci-app-ndsvoucher" Makefile >nul
if errorlevel 1 (
    echo ERROR: PKG_NAME not found in Makefile!
    exit /b 1
)
findstr "PKG_VERSION:=1.0.0" Makefile >nul
if errorlevel 1 (
    echo ERROR: PKG_VERSION not found in Makefile!
    exit /b 1
)
findstr "include $(TOPDIR)/feeds/luci/luci.mk" Makefile >nul
if errorlevel 1 (
    echo ERROR: luci.mk include not found in Makefile!
    exit /b 1
)
echo Makefile checks passed.

echo Package structure verification complete!
echo All checks passed. Package structure is correct.