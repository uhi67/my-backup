FROM alpine:3.20
RUN apk add --no-cache mysql-client
RUN apk add --no-cache mariadb-connector-c-dev
RUN apk add --no-cache tzdata
COPY src/backup.sh /usr/local/bin/backup.sh
COPY src/restore.sh /usr/local/bin/restore.sh
COPY src/crontab /etc/cron.d/mysql-backup
RUN chmod +x /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/restore.sh
COPY --chmod=+rx src/entrypoint.sh /entrypoint.sh
STOPSIGNAL SIGKILL
ENTRYPOINT ["/entrypoint.sh"]

