#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then

    mariadb-install-db --auth-root-authentication-method=normal --datadir=/var/lib/mysql

    mariadbd --datadir=/var/lib/mysql &

    sleep 5

    mariadb -uroot << EOF

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* 
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;

EOF

    mariadb-admin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown

fi

exec mariadbd --console