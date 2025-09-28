#!/bin/sh

# Nodogsplash BinAuth Script for LuCI app
# This script is called by Nodogsplash to authenticate a client.

# Arguments from Nodogsplash:
# $1: "auth_client"
# $2: Client's MAC address
# $3: Client's IP address
# $4: Username (not used in our flow)
# $5: Password (not used in our flow)

# We only care about the 'auth_client' action
if [ "$1" != "auth_client" ]; then
  exit 1
fi

CLIENT_MAC=$2

if [ -z "$CLIENT_MAC" ]; then
  exit 1
fi

# Ask the voucher script for the duration associated with this MAC address.
DURATION_SECONDS=$(/usr/share/ndsvoucher/scripts/voucher.sh validate-mac "$CLIENT_MAC")

# Check if we got a duration back
if [ -n "$DURATION_SECONDS" ] && [ "$DURATION_SECONDS" -gt 0 ]; then
  # Success: Echo the session details for Nodogsplash
  # Format: <duration_seconds> <upload_limit_kbps> <download_limit_kbps>
  # We use 0 for unlimited speed.
  echo "$DURATION_SECONDS 0 0"
  exit 0
else
  # Failure: The backend didn't authorize this MAC.
  exit 1
fi