FROM alpine:3.18
RUN apt-get update && apt-get install -y cron
RUN apk add --no-cache mysql-client
COPY src/backup.sh /usr/local/bin/backup.sh
COPY src/restore.sh /usr/local/bin/restore.sh
COPY src/crontab /etc/cron.d/mysql-backup
RUN chmod +x /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/restore.sh
COPY --chmod=+rx src/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

