#!/bin/sh

echo "Creating cron tasks..."
cat << EOF | sudo tee /etc/cron.d/userside
* * * * *    root    docker exec -t userside_fpm_1 php userside cron > /dev/null 2>&1
0 3 * * *    root    docker exec userside_fpm_1 /app/backup.sh > /dev/null 2>&1
0 4 * * *    root    docker exec userside_postgres_1 /app/backup.sh > /dev/null 2>&1
EOF
echo "Done."

echo "Creating logrotate config..."
cat << EOF | sudo tee /etc/logrotate.d/userside
/var/log/userside/nginx/*.log {
    rotate 7
    daily
    compress
    delaycompress
    missingok
    notifempty
}
EOF
echo "Done."
