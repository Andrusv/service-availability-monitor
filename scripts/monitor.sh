#!/bin/bash

CONFIG_DIR=$(dirname "$0")/../config
SERVERS_FILE="$CONFIG_DIR/servers.list"
EMAIL_CONFIG="$CONFIG_DIR/email.conf"

if [ -f "$EMAIL_CONFIG" ]; then
    source "$EMAIL_CONFIG"
else
    echo "Email not found in $EMAIL_CONFIG"
    exit 1
fi

# check for mailutils
if ! command -v mail &> /dev/null; then
    echo "Error: mailutils is not installed."
    exit 1
fi

check_server() {
    local server=$1
    local timestamp=$(date +"%Y-%m-%d %T")
    
    if ping -c 3 -W 2 $server > /dev/null 2>&1; then
        echo "$timestamp: OK - Servidor $server respondió al ping."
        return 0
    else
        local subject="ALERTA: Servidor $server no responde"
        local body="El servidor $server no respondió a 3 intentos de ping.\n\nFecha: $timestamp"
        echo -e "$body" | mail -s "$subject" "$ALERT_EMAIL"
        echo "$timestamp: ERROR - Servidor $server no respondió. Alerta enviada a $ALERT_EMAIL"
        return 1
    fi
}

SERVERS=()
while read -r line; do
    # Ignorar comentarios y líneas vacías
    [[ "$line" =~ ^# ]] || [[ -z "$line" ]] && continue
    # Extraer la primera columna (IP/hostname)
    server=$(echo "$line" | awk '{print $1}')
    SERVERS+=("$server")
done < "$SERVERS_FILE"

for server in "${SERVERS[@]}"; do
    check_server "$server"
done