#!/bin/bash
echo "================================== ОТЧЁТ ПО СЕРВЕРУ ============================="
echo ""
echo "Дата: $(date)"
echo "Хост: $(hostname)"
echo "Пользователь: $(whoami)"
echo "Система: $(uname -s -r)"
echo ""
echo "--- CPU ---"
nproc
echo ""
echo "--- RAM ---"
free -h
echo ""
echo "--- ДИСК ---"
df -h /
echo ""
echo "--- Аптайм ---"
uptime
echo ""
echo "--- Топ 5 Процессов по CPU ---"
ps aux --sort=-%cpu | head -6
echo ""
echo "--- Топ 5 процессов по MEM ---"
ps aux --sort=-%mem | head -6
echo ""
echo "--- Запущенные сервисы (первые 10) ---"
systemctl list-units --type=service --state=running --no-pager | head -10
echo ""
echo "--- Упавшие сервисы (если есть) ---"
systemctl list-units --state=failed --no-pager
echo "==================================================================================="
