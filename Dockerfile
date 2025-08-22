FROM mysql
RUN apt-get update && apt-get install -y cron
COPY src/backup.sh /usr/local/bin/backup.sh
COPY src/restore.sh /usr/local/bin/restore.sh
COPY src/crontab /etc/cron.d/mysql-backup
RUN chmod +x /usr/local/bin/backup.sh
RUN chmod +x /usr/local/bin/restore.sh
#CMD ["cron", "-f"]
COPY --chmod=+rx src/entrypoint.sh /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
