#!/bin/bash
# SSV6051 WiFi Driver Restore Script

if [ "$EUID" -ne 0 ]; then 
    echo "Please run as root: sudo ./restore-ssv6051.sh"
    exit 1
fi

echo "Extracting driver source..."
tar -xzf ssv6051-dkms-master-backup.tar.gz -C /usr/src

echo "Adding to DKMS..."
dkms add -m ssv6051 -v 1.0

echo "Building driver..."
dkms build -m ssv6051 -v 1.0

echo "Installing driver..."
dkms install -m ssv6051 -v 1.0

echo "Loading driver..."
modprobe ssv6051

echo "Checking if loaded..."
if lsmod | grep -q ssv6051; then
    echo "✅ SUCCESS! WiFi driver loaded!"
    echo "Check with: ip a show wlan0"
else
    echo "❌ Failed to load. Check: dmesg | tail -20"
    exit 1
fi
