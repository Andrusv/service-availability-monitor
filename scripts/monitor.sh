#!/bin/bash

# ========================
# Configuration Variables 
# ========================
CONFIG_DIR=$(dirname "$0")/../config
LOG_DIR=$(dirname "$0")/../logs
SERVERS_FILE="$CONFIG_DIR/servers.list"
EMAIL_CONFIG="$CONFIG_DIR/email.conf"
LOG_FILE="$LOG_DIR/monitor.log"
MAX_RETRIES=3
RETRY_DELAY=5
PING_TIMEOUT=2

# Ensure logs directory exists
mkdir -p "$LOG_DIR"
touch "$LOG_FILE"

# ========================
# Logging Functions
# ========================
log_message() {
    local timestamp=$(date +"%Y-%m-%d %T")
    echo "$timestamp: $1" >> "$LOG_FILE"
    echo "$timestamp: $1"  # Also print to console
}

# ========================
# Main Monitoring Logic
# ========================
check_server() {
    local server=$1
    
    log_message "Checking server: $server"
    
    if ping -c $MAX_RETRIES -W $PING_TIMEOUT $server > /dev/null 2>&1; then
        log_message "OK - Server $server responded"
        return 0
    else
        local subject="ALERT: Server $server down"
        local body="Server $server failed to respond to $MAX_RETRIES ping attempts"
        
        log_message "ERROR - Server $server down. Sending alert"
        echo "$body" | mail -s "$subject" "$ALERT_EMAIL"
        
        return 1
    fi
}

SERVERS=()
while read -r line; do
    # Ignore empty lines
    [[ "$line" =~ ^# ]] || [[ -z "$line" ]] && continue
    # Extract first column (IP/hostname)
    server=$(echo "$line" | awk '{print $1}')
    SERVERS+=("$server")
done < "$SERVERS_FILE"

for server in "${SERVERS[@]}"; do
    check_server "$server"
done