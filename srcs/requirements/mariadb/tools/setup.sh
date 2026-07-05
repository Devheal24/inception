#!/bin/sh

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
MYSQL_ROOT_PASSWORD=$(cat /run/secrets/db_root_password)

if [ -z "$MYSQL_PASSWORD" ] || [ -z "$MYSQL_ROOT_PASSWORD" ]; then
    echo "setup.sh: db_password and db_root_password secrets must not be empty" >&2
    exit 1
fi

if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ]; then
    echo "setup.sh: MYSQL_DATABASE and MYSQL_USER must be set (check .env)" >&2
    exit 1
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then

    mariadb-install-db --auth-root-authentication-method=normal --datadir=/var/lib/mysql

    mariadbd --datadir=/var/lib/mysql --skip-networking &
    MARIADB_PID=$!

    for i in $(seq 1 30); do
        mariadb-admin -uroot ping --silent >/dev/null 2>&1 && break
        sleep 1
    done

    mariadb -uroot << EOF

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* 
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;

EOF

    mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown
    wait "$MARIADB_PID"

fi

exec mariadbd --console