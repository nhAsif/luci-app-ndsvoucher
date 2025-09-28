#!/bin/sh

# Configure NoDogSplash for the voucher system

# Backup existing config if it exists
if [ -f /etc/config/nodogsplash ]; then
    cp /etc/config/nodogsplash /etc/config/nodogsplash.backup
fi

# Create NoDogSplash configuration
cat > /etc/config/nodogsplash << 'EOF'
config nodogsplash
    option enabled '1'
    option fwhook_enabled '1'
    option gatewayinterface 'br-lan'
    option maxclients '250'
    option binauth '/usr/share/ndsvoucher/scripts/binauth.sh'
    option client_idle_timeout '2'
    list preauthenticated_users 'allow tcp port 80'
    list preauthenticated_users 'allow tcp port 53'
    list preauthenticated_users 'allow udp port 53'
    list authenticated_users 'allow all'
    option splashpage 'splash.html'
    option preauthidletimeout '3'
    option authidletimeout '1'
    option checkinterval '20'
EOF

# Create the splash page
mkdir -p /etc/nodogsplash/htdocs/
cat > /etc/nodogsplash/htdocs/splash.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <meta charset="utf-8" />
    <title>Connecting...</title>
    <meta http-equiv="refresh" content="0; url=http://192.168.100.1:7891/?ip=$clientip&mac=$clientmac&token=$tok" />
</head>
<body>
    <p>Please wait, you are being redirected to the login page...</p>
</body>
</html>
EOF

# Restart NoDogSplash to apply changes
/etc/init.d/nodogsplash restart

echo "NoDogSplash configured for voucher system"