my-backup
=========

A side-car container to backup and restore MySQL database.

Example usage
-------------

```yml
  backup:
    image: ghcr.io/uhi67/my-backup:main
    restart: unless-stopped
    volumes:
      - ./docker-data/backup:/var/backup
    environment:
      APP_DB_HOST: db
      APP_DB_PORT: 3306
      APP_DB_USER: $APP_DB_USER
      APP_DB_PASSWORD_FILE: "/run/secrets/app_db_password"
      APP_DB_NAME: $APP_DB_NAME
      APP_BACKUP_DIR: /var/backup
      CRON_SCHEDULE: "*\\/15 * * * *" # Note: slashes must be escaped
    networks:
      - app
    secrets:
      - app_db_password
```

Restoring can be done manually by running the following command:

`restore.sh <filename>`

The backup file to restore must be in the backup directory defined by the `APP_BACKUP_DIR` environment variable.

Development informations
-------------------------

1. The image is automatically built on GitHub triggered by push operations.
