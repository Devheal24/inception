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

    sleep 5

    mariadb -uroot << EOF

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* 
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;

EOF

    mariadb-admin -uroot -p"${MYSQL_ROOT_PASSWORD}" shutdown

fi

exec mariadbd --console