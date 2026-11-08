#!/bin/bash
#
# netmon.sh — Simple Network Monitor
# Part of PREET.SYS Systems Hacker Roadmap - Day 28
#
# Watches for:
#   1. New devices joining the network (via ARP)
#   2. DNS queries made by any device on the network
#
# Usage: sudo ./netmon.sh <interface>
# Example: sudo ./netmon.sh eth0

# ---- CONFIG ----
IFACE="${1:-eth0}"                     # interface, default eth0 if not given
KNOWN_DEVICES="known_devices.txt"      # stores MACs we've already seen
DNS_LOG="dns_queries.log"              # logs every DNS query
ARP_LOG="arp_alerts.log"               # logs new device alerts

# ---- CHECKS ----
if [ "$EUID" -ne 0 ]; then
    echo "[!] Please run as root (sudo ./netmon.sh $IFACE)"
    exit 1
fi

if ! command -v tcpdump &> /dev/null; then
    echo "[!] tcpdump not found. Install with: sudo apt install tcpdump"
    exit 1
fi

touch "$KNOWN_DEVICES" "$DNS_LOG" "$ARP_LOG"

echo "=================================================="
echo " Network Monitor started on interface: $IFACE"
echo " ARP alerts  -> $ARP_LOG"
echo " DNS logs    -> $DNS_LOG"
echo " Press Ctrl+C to stop everything."
echo "=================================================="

# ---- CLEANUP ON EXIT ----
# When we hit Ctrl+C, kill both background tcpdump jobs cleanly
cleanup() {
    echo ""
    echo "[*] Stopping network monitor..."
    kill "$ARP_PID" "$DNS_PID" 2>/dev/null
    exit 0
}
trap cleanup SIGINT SIGTERM

# ---- ARP MONITOR (background) ----
# Reads live ARP traffic, extracts MAC address, checks if new
monitor_arp() {
    sudo tcpdump -i "$IFACE" -l -n -e arp 2>/dev/null | while read -r line; do
        # Extract the source MAC address from the tcpdump line
        mac=$(echo "$line" | grep -oE '([0-9a-f]{2}:){5}[0-9a-f]{2}' | head -1)

        if [ -n "$mac" ]; then
            if ! grep -q "$mac" "$KNOWN_DEVICES" 2>/dev/null; then
                echo "$mac" >> "$KNOWN_DEVICES"
                timestamp=$(date '+%Y-%m-%d %H:%M:%S')
                alert="[$timestamp] NEW DEVICE JOINED: $mac"
                echo "$alert" | tee -a "$ARP_LOG"
            fi
        fi
done
}

# ---- DNS MONITOR (background) ----
# Reads live DNS traffic, extracts the domain being queried
monitor_dns() {
    sudo tcpdump -i "$IFACE" -l -n udp port 53 2>/dev/null | while read -r line; do
        # DNS query lines contain "A?" or "AAAA?" followed by the domain
        domain=$(echo "$line" | grep -oE '[A-Za-z0-9.-]+\.[A-Za-z]{2,}\.?( A| AAAA)?' | head -1)

        if [ -n "$domain" ]; then
            timestamp=$(date '+%Y-%m-%d %H:%M:%S')
            echo "[$timestamp] DNS QUERY: $domain" >> "$DNS_LOG"
        fi
    done
}

# ---- LAUNCH BOTH MONITORS IN BACKGROUND ----
monitor_arp &
ARP_PID=$!

monitor_dns &
DNS_PID=$!

echo "[*] ARP monitor running (PID $ARP_PID)"
echo "[*] DNS monitor running (PID $DNS_PID)"
echo "[*] Watching... (tail -f $DNS_LOG in another terminal to watch DNS live)"


# Keep script alive so background jobs keep running until Ctrl+C
wait
