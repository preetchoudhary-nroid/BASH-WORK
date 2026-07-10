#!/bin/bash
TARGET_IP=$1
START_PORT=$2
END_PORT=$3
echo "SCANNING $TARGET_IP FROM PORT $START_PORT TO $END_PORT..."
for ((port=$START_PORT; port<=$END_PORT; port++)); do
  echo > "/dev/tcp/$TARGET_IP/$port" 2>/dev/null

  if [ $? -eq 0 ]; then
    echo "PORT $port is OPEN"
  fi
done
echo "SCAN COMPLETE"