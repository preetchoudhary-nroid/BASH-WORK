#!/bin/bash
TIMESTAMP=$(date +%Y%m%d_%H%M%S)
REPORT_FILE="system_report_$TIMESTAMP.txt"

{
  echo "===SYSTEM INFO REPORT ==="
  echo "Hostname: $(hostname)"
  echo "OS VERSION: $(uname -a)"
  echo "IP Address: $(ip addr | grep 'inet' | grep -v '127.0.0.1')"
  echo "----------------------"
  echo "RAM usage:"
  free -h
  echo "----------------------"
  echo "Disk space:"
  df -h
} >"$REPORT_FILE"
echo "SYSTEM REPORT SAVED TO $REPORT_FILE"