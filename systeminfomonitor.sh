#!/bin/bash
LOG_FILE="user_activity.log"
echo "Monitor user activity...Press Ctrl+C to stop"
while true; do
  TIMESTAMP=$(date "+%Y-%m-%d %H-%M-%S")
  echo "[$TIMESTAMP] Current Users:" >> "$LOG_FILE"
  who >> "$LOG_FILE"
  echo "----------------" >> "$LOG_FILE"
  sleep 5
done
