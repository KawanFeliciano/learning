#!/bin/bash
LOG_FILE="ping_errors.log"

validate_ip(){
        local ip=$1
        local stat=1

        if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
                IFS='.' read -r -a octets <<< "$ip"
                [[ ${octets[0]} -le 255 && ${octets[1]} -le 255 && \
                   ${octets[2]} -le 255 && ${octets[3]} -le 255  ]]
                stat=$?
        fi
        return $stat
}

while true; do
        read -p "Enter target IP to ping (or 'quit'): " ip

        [[ "$ip" == "quit" ]] && break

        if ! validate_ip "$ip"; then
                echo "ERROR: '$ip' isn't a valid IP (must be X.X.X.X with numbers 0-255)"
                continue
        fi

        if ping -c 1 -W 2 "$ip" &> /dev/null; then
                echo "Success: Host $ip is reachable."
        else
                echo "Error: Host $ip is unreachable."
        fi
done
