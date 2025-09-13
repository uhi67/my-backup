#! /bin/sh
# Required environment variables:
#      APP_DB_HOST
#      APP_DB_PORT
#      APP_DB_NAME
#      APP_DB_USER
#      APP_DB_PASSWORD or APP_DB_PASSWORD_FILE
#      APP_BACKUP_DIR

if [ "$APP_DB_PASSWORD" = "" ]; then
  # shellcheck disable=SC2155
  export APP_DB_PASSWORD="$(cat "$APP_DB_PASSWORD_FILE")"
fi

if [ "$APP_DB_NAME" = "" ]; then
  echo "Error: No database defined !"
  exit 1
fi
TIMESTAMP=$(date "+%Y-%m-%d_%H-%M-%S")
echo "Starting backup into: $APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.gz"
mysqldump -h "$APP_DB_HOST" -u "$APP_DB_USER" -p$APP_DB_PASSWORD --add-drop-table --single-transaction --routines --triggers --no-tablespaces "$APP_DB_NAME" 2> "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP".log | gzip -c > "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.tmp"
mv "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.tmp" "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP.gz"
cp "$APP_BACKUP_DIR/$APP_DB_NAME-$TIMESTAMP".log "$APP_BACKUP_DIR/last.log"
echo "Backup finished successfully."
exit 0
