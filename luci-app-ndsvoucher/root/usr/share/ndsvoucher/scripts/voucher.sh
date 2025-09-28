#!/bin/sh

# Voucher management script for LuCI app
# This script handles all voucher operations using JSON files

# Load configuration
CONFIG_FILE="/etc/config/ndsvoucher"
DATA_DIR="/data"
VOUCHER_DB="$DATA_DIR/voucher.json"
SETTINGS_FILE="$DATA_DIR/settings.json"

# Create data directory if it doesn't exist
mkdir -p "$DATA_DIR"

# Initialize database files if they don't exist
if [ ! -f "$VOUCHER_DB" ]; then
    echo "[]" > "$VOUCHER_DB"
fi

if [ ! -f "$SETTINGS_FILE" ]; then
    echo "{}" > "$SETTINGS_FILE"
fi

# Function to generate a random voucher code
generate_voucher_code() {
    hexdump -n 4 -e '1/1 "%02x"' /dev/urandom
}

# Function to get current timestamp
current_timestamp() {
    date -u +"%Y-%m-%dT%H:%M:%SZ"
}

# Function to list all vouchers
list_vouchers() {
    cat "$VOUCHER_DB"
}

# Function to add a new voucher
add_voucher() {
    local name="$1"
    local code="$2"
    local duration="$3"
    local reusable="$4"
    
    # Generate code if not provided
    if [ -z "$code" ]; then
        code=$(generate_voucher_code)
    fi
    
    # Get current max ID
    local max_id=$(jq -r 'map(.id) | max // 0' "$VOUCHER_DB")
    local new_id=$((max_id + 1))
    
    # Create new voucher object
    local new_voucher=$(jq -n \
        --arg id "$new_id" \
        --arg code "$code" \
        --arg name "${name:-$code}" \
        --arg duration "$duration" \
        --arg reusable "$reusable" \
        --arg created "$(current_timestamp)" \
        '{
            id: ($id | tonumber),
            code: $code,
            name: $name,
            duration: ($duration | tonumber),
            is_reusable: ($reusable == "1"),
            is_used: false,
            created_at: $created
        }')
    
    # Add to database
    jq --argjson new_voucher "$new_voucher" '. += [$new_voucher]' "$VOUCHER_DB" > "$VOUCHER_DB.tmp" && mv "$VOUCHER_DB.tmp" "$VOUCHER_DB"
    
    # Return the new voucher
    echo "$new_voucher"
}

# Function to delete a voucher by ID
delete_voucher() {
    local id="$1"
    
    jq --arg id "$id" 'map(select(.id != ($id | tonumber)))' "$VOUCHER_DB" > "$VOUCHER_DB.tmp" && mv "$VOUCHER_DB.tmp" "$VOUCHER_DB"
}

# Function to validate a voucher
validate_voucher() {
    local voucher_code="$1"
    
    # Find voucher by code
    local voucher=$(jq -r --arg code "$voucher_code" '.[] | select(.code == $code)' "$VOUCHER_DB")
    
    if [ -z "$voucher" ]; then
        echo "Invalid voucher code"
        return 1
    fi
    
    # Check if one-time voucher is already used
    local is_used=$(echo "$voucher" | jq -r '.is_used')
    local is_reusable=$(echo "$voucher" | jq -r '.is_reusable')
    
    if [ "$is_used" = "true" ] && [ "$is_reusable" = "false" ]; then
        echo "Voucher has already been used"
        return 1
    fi
    
    # Return the valid voucher
    echo "$voucher"
    return 0
}

# Function to validate a MAC address (for binauth)
validate_mac() {
    local client_mac="$1"
    
    # Find active voucher by MAC address
    local voucher=$(jq -r --arg mac "$client_mac" '.[] | select(.user_mac == $mac and .is_used == true)' "$VOUCHER_DB")
    
    if [ -z "$voucher" ]; then
        echo "0"
        return 1
    fi
    
    # Get voucher details
    local duration=$(echo "$voucher" | jq -r '.duration')
    local start_time=$(echo "$voucher" | jq -r '.start_time')
    
    # Calculate expiration time (start + duration minutes)
    local expire_time=$(date -d "$start_time $duration minutes" -u +%s)
    local current_time=$(date -u +%s)
    
    # Check if expired
    if [ "$current_time" -gt "$expire_time" ]; then
        echo "0"
        return 1
    fi
    
    # Calculate remaining seconds
    local remaining_seconds=$((expire_time - current_time))
    echo "$remaining_seconds"
    return 0
}

# Function to mark voucher as used
use_voucher() {
    local voucher_code="$1"
    local client_ip="$2"
    local client_mac="$3"
    
    # Update the voucher
    jq --arg code "$voucher_code" \
       --arg ip "$client_ip" \
       --arg mac "$client_mac" \
       --arg start_time "$(current_timestamp)" \
       'map(if .code == $code then . + {is_used: true, start_time: $start_time, user_ip: $ip, user_mac: $mac} else . end)' \
       "$VOUCHER_DB" > "$VOUCHER_DB.tmp" && mv "$VOUCHER_DB.tmp" "$VOUCHER_DB"
}

# Function to get admin password
get_admin_password() {
    jq -r '.admin_password // "rosepinepink"' "$SETTINGS_FILE"
}

# Function to set admin password
set_admin_password() {
    local new_password="$1"
    
    jq --arg password "$new_password" '.admin_password = $password' "$SETTINGS_FILE" > "$SETTINGS_FILE.tmp" && mv "$SETTINGS_FILE.tmp" "$SETTINGS_FILE"
}

# Function to authenticate admin
authenticate_admin() {
    local password="$1"
    local admin_password=$(get_admin_password)
    
    if [ "$password" = "$admin_password" ]; then
        echo "authenticated"
        return 0
    else
        echo "invalid"
        return 1
    fi
}

# Function to validate a client (for web authentication)
validate_client() {
    local voucher_code="$1"
    local client_ip="$2"
    local client_mac="$3"
    
    # Validate the voucher
    local voucher=$(validate_voucher "$voucher_code")
    if [ $? -ne 0 ]; then
        echo "$voucher"  # This will be the error message
        return 1
    fi
    
    # Mark voucher as used
    use_voucher "$voucher_code" "$client_ip" "$client_mac"
    
    # Get duration
    local duration=$(echo "$voucher" | jq -r '.duration')
    echo "$duration"
    return 0
}

# Main command dispatcher
case "$1" in
    list)
        list_vouchers
        ;;
    add)
        add_voucher "$2" "$3" "$4" "$5"
        ;;
    delete)
        delete_voucher "$2"
        ;;
    validate)
        validate_voucher "$2"
        ;;
    validate-client)
        validate_client "$2" "$3" "$4"
        ;;
    validate-mac)
        validate_mac "$2"
        ;;
    use)
        use_voucher "$2" "$3" "$4"
        ;;
    get-password)
        get_admin_password
        ;;
    set-password)
        set_admin_password "$2"
        ;;
    authenticate)
        authenticate_admin "$2"
        ;;
    *)
        echo "Usage: $0 {list|add|delete|validate|use|get-password|set-password|authenticate}"
        exit 1
        ;;
esac