#!/bin/bash
RAM=$(free -h | awk '/^Mem:/ {print $3"/"$2}')
DISK=$(df -h / | awk 'NR==2 {print $3"/"$2}')
UP=$(uptime -p)

echo ""
echo "🚀  labvm — учебная DevOps VM"
echo "👤  Владелец: Кирилл"
echo "📅  $(date '+%Y-%m-%d %H:%M')"
echo "💾  RAM:   $RAM"
echo "💽  Диск:  $DISK"
echo "⏱️   $UP"
echo ""
