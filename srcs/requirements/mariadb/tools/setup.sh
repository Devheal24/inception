#!/bin/sh

if [ ! -d "/var/lib/mysql/mysql" ]; then

    mariadb-install-db --user=mysql --datadir=/var/lib/mysql

    mariadbd --user=mysql --datadir=/var/lib/mysql &

    sleep 5

    mariadb << EOF

CREATE DATABASE IF NOT EXISTS ${MYSQL_DATABASE};

CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';

GRANT ALL PRIVILEGES ON ${MYSQL_DATABASE}.* 
TO '${MYSQL_USER}'@'%';

ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';

FLUSH PRIVILEGES;

EOF

    mariadb-admin -uroot -p${MYSQL_ROOT_PASSWORD} shutdown

fi

exec mariadbd --user=mysql --console