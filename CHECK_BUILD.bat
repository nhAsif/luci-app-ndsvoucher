@echo off
echo Testing build process...

echo Checking required files...
if not exist ".github\workflows\release.yml" (
    echo ERROR: Release workflow not found!
    exit /b 1
)
echo Found: .github\workflows\release.yml

if not exist "luci-app-ndsvoucher\Makefile" (
    echo ERROR: Makefile not found!
    exit /b 1
)
echo Found: luci-app-ndsvoucher\Makefile

if not exist "luci-app-ndsvoucher\version" (
    echo ERROR: Version file not found!
    exit /b 1
)
echo Found: luci-app-ndsvoucher\version

echo Checking Makefile version...
for /f "tokens=2 delims==" %%a in ('findstr "PKG_VERSION:=" luci-app-ndsvoucher\Makefile') do set VERSION=%%a
if "%VERSION%"=="" (
    echo ERROR: Could not extract version from Makefile!
    exit /b 1
)
echo Makefile version: %VERSION%

echo Checking version file...
set /p VERSION_FILE=<luci-app-ndsvoucher\version
if "%VERSION_FILE%"=="" (
    echo ERROR: Could not read version from version file!
    exit /b 1
)
echo Version file: %VERSION_FILE%

if not "%VERSION%"=="%VERSION_FILE%" (
    echo ERROR: Version mismatch between Makefile (%VERSION%) and version file (%VERSION_FILE%)!
    exit /b 1
)

echo Versions match correctly.
echo Build process verification complete!
echo All checks passed. The build process should work correctly.