#!/bin/sh
set -e

BACKUP_DIR=/backups
TIMESTAMP=$(date +%Y-%m-%d_%H-%M)
RETENTION_DAYS=7
MYSQL_PASSWORD=$(cat /run/secrets/db_password)

echo "$(date '+%F %T') [backup] starting backup"

mariadb-dump -h mariadb -uwpuser -p"${MYSQL_PASSWORD}" wordpress \
    | gzip > "${BACKUP_DIR}/mariadb_${TIMESTAMP}.sql.gz"

echo "$(date '+%F %T') [backup] mariadb dump done"

tar -czf "${BACKUP_DIR}/wordpress_${TIMESTAMP}.tar.gz" -C /var/www/html .

echo "$(date '+%F %T') [backup] wordpress archive done"

find "${BACKUP_DIR}" -name '*.gz' -mtime "+${RETENTION_DAYS}" -delete

echo "$(date '+%F %T') [backup] backup complete"
