#!/bin/bash

PORTS=""
SERVICE_SCAN_REPORT="service_scan_report"

if [ "$1" ]; then
        TARGET="$1"
        echo -e "\n[+] Scanning open ports in $TARGET"
        PORTS="$(nmap -sS -Pn -p- -T5 $TARGET | tail -n +6 | head -n -3 | awk '{print $1}' | awk -F/ '{print $1}' | xargs | sed 's/ /,/g')"
        SERVICE_SCAN_COMMAND="nmap -Pn -sS -sV -sC -T5 -p$PORTS $TARGET -oA $SERVICE_SCAN_REPORT"
        echo -e "\n\t[+] Next ports are open: $PORTS"
        echo -e "[+] Proceeding to scan them (agressive): "
        echo -e "[+] Running: $SERVICE_SCAN_COMMAND"
        $SERVICE_SCAN_COMMAND
        if [ "$!" -eq 0 ]; then
                echo -e "\t[+] Scan succeeded!"
                echo -e "\t[+] You can see the results in three formats: $SERVICE_SCAN_REPORT"
        else
                echo -e "\t[!] Scan failed"
        fi
else
        echo -e "\n[+] Usage $0 <target>"
fi

