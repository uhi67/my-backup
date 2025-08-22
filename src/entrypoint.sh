#!/bin/bash

# Terminate execution if any command fails
set -e

if [ "$APP_DB_PASSWORD" == "" ]; then
  export APP_DB_PASSWORD=$(cat $APP_DB_PASSWORD_FILE)
fi
if [ "$APP_DB_PASSWORD" == "" ]; then
  echo "Warning: no password is set in APP_DB_PASSWORD neither APP_DB_PASSWORD_FILE ($APP_DB_PASSWORD_FILE)"
fi

printenv | sed 's/^\([a-zA-Z0-9_]*\)=\(.*\)$/export \1='"'"'\2'"'"'/g' > /root/env.sh

# Replace cron schedule from environment
if [ "$CRON_SCHEDULE" = "" ]; then
    CRON_SCHEDULE="21 1 * * *"
fi
sed -i "s/\$CRON_SCHEDULE/$CRON_SCHEDULE/g" /etc/cron.d/mysql-backup
cat /etc/cron.d/mysql-backup

echo "*** starting cron"
crontab /etc/cron.d/mysql-backup
exec cron -f
