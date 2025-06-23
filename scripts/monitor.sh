#!/bin/bash

EMAIL="andresbarrosocl@gmail.com"
SERVERS=("8.8.8.8" "8.8.4.4")

check_server() {
    local server=$1
    ping -c 1 $server > /dev/null 2>&1
    if [ $? -ne 0 ]; then
        echo "Server $server is down." | mail -s "Alert: Server $server down" $EMAIL
        echo "$(date): Server $server down. Alert sent."
    else
        echo "$(date): Server $server online."
    fi
}

for server in "${SERVERS[@]}"; do
    check_server $server
done