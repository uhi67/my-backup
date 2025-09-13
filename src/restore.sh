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
if [ "$APP_DB_PASSWORD" = "" ]; then
  echo "Warning: no password is set in APP_DB_PASSWORD neither APP_DB_PASSWORD_FILE ($APP_DB_PASSWORD_FILE)"
fi

if [ "$APP_DB_NAME" = "" ]; then
  echo "Error: No database name defined !"
  exit 1
fi

if [ "$1" = "" ]; then
  echo "Usage: restore.sh <filename>"
  echo "Available files:"
  ls "$APP_BACKUP_DIR"
  exit 2
else
  if [ ! -f "$APP_BACKUP_DIR"/"$1" ]; then
    echo "File $APP_BACKUP_DIR/$1 not found"
    exit 3
  fi
  echo "Restoring database $1..."
  case "$1" in
    *.gz)
      gzip -d -c "$APP_BACKUP_DIR"/"$1" | mysql -h "$APP_DB_HOST" -P "$APP_DB_PORT" -u "$APP_DB_USER" -p"$APP_DB_PASSWORD" "$APP_DB_NAME"
      ;;
    *.sql)
      mysql -h "$APP_DB_HOST" -P "$APP_DB_PORT" -u "$APP_DB_USER" -p"$APP_DB_PASSWORD" "$APP_DB_NAME" < $1
      ;;
    *)
      echo "Please specify a filename with .gz or .sql extension"
      ;;
  esac
fi
