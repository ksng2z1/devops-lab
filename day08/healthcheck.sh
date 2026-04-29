#!/usr/bin/env bash

DISK_LIMIT=80
RAM_LIMIT=80
STATUS=0

HOSTNAME=$(hostname)
DATE=$(date +%F)
LOAD_AVG=$(uptime | awk -F'load average:' '{ print $2 }' | xargs)

DISK_USED=$(df / | awk 'NR==2 { gsub("%", "", $5); print $5 }')
RAM_USED=$(free | awk '/Mem:/ { printf "%.0f", $3/$2 * 100 }')

echo "Healthcheck for: $HOSTNAME"
echo "Date: $DATE"
echo "Load average:$LOAD_AVG"
echo "Disk used: ${DISK_USED}%"
echo "RAM used: ${RAM_USED}%"
echo

if [ "$DISK_USED" -ge "$DISK_LIMIT" ]; then
  echo "WARN: disk usage is high"
  STATUS=1
else
  echo "OK: disk usage is fine"
fi

if [ "$RAM_USED" -ge "$RAM_LIMIT" ]; then
  echo "WARN: RAM usage is high"
  STATUS=1
else
  echo "OK: RAM usage is fine"
fi

if systemctl is-active --quiet ssh; then
  echo "OK: ssh service is active"
else
  echo "CRITICAL: ssh service is not active"
  STATUS=1
fi

exit "$STATUS"

