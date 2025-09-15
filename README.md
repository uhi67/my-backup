my-backup
=========

A side-car container to backup and restore MySQL database.

Version: 1.0.0

Example usage
-------------

```yml
  backup:
    image: ghcr.io/uhi67/my-backup:main
    restart: unless-stopped
    volumes:
      - ./docker-data/backup:/var/backup
    environment:
      TZ: "Europe/Budapest"
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

The scheduled backup operation is performed by the `cron` service. Manual backup can be done any time by running `backup.sh` in the container.
The backup file is stored in the backup directory defined by the `APP_BACKUP_DIR` environment variable.
The backup file name is composed of the database name and the current date and time. The backup file is compressed with gzip.
Also, a log file is created in the backup directory with the same name as the backup file. In addition, the last log file is always copied to there as 'last.log'. 

Restoring can be done manually by running the following command:

`restore.sh <filename>`

The backup file to restore must be in the backup directory defined by the `APP_BACKUP_DIR` environment variable.
Without a filename, the command lists all files in the backup directory.
Only .gz and .sql files are accepted.

Development information
-----------------------

1. The image is automatically built on GitHub triggered by push operations. The image is tagged with the git tag.
