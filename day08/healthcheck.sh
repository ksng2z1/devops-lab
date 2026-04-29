#!/usr/bin/env bash

DISK_LIMIT=80
RAM_LIMIT=80
STATUS=0

print_header() {
  local hostname_value
  local current_date
  local load_avg

  hostname_value=$(hostname)
  current_date=$(date +%F)
  load_avg=$(uptime | awk -F'load average:' '{ print $2 }' | xargs)

  echo "Healthcheck for: $hostname_value"
  echo "Date: $current_date"
  echo "Load average: $load_avg"
  echo
}

check_disk() {
  local disk_used

  disk_used=$(df / | awk 'NR==2 { gsub("%", "", $5); print $5 }')

  echo "Disk used: ${disk_used}%"

  if [ "$disk_used" -ge "$DISK_LIMIT" ]; then
    echo "WARN: disk usage is high"
    STATUS=1
  else
    echo "OK: disk usage is fine"
  fi

  echo
}

check_ram() {
  local ram_used

  ram_used=$(free | awk '/Mem:/ { printf "%.0f", $3/$2 * 100 }')

  echo "RAM used: ${ram_used}%"

  if [ "$ram_used" -ge "$RAM_LIMIT" ]; then
    echo "WARN: RAM usage is high"
    STATUS=1
  else
    echo "OK: RAM usage is fine"
  fi

  echo
}

check_service() {
  local service_name

  service_name="$1"

  if systemctl is-active --quiet "$service_name"; then
    echo "OK: $service_name service is active"
  else
    echo "CRITICAL: $service_name service is not active"
    STATUS=1
  fi

  echo
}

print_header
check_disk
check_ram
check_service "ssh"
check_service "cron"

exit "$STATUS"
