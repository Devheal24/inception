#!/bin/sh

cd /var/www/html

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)

if [ ! -f "wp-config.php" ]; then

    curl -O https://wordpress.org/latest.tar.gz

    tar -xzf latest.tar.gz

    mv wordpress/* .

    rm -rf wordpress latest.tar.gz


    wp config create \
        --dbname=${MYSQL_DATABASE} \
        --dbuser=${MYSQL_USER} \
        --dbpass=${MYSQL_PASSWORD} \
        --dbhost=mariadb

    wp core install \
        --url=${DOMAIN_NAME} \
        --title=${WP_TITLE} \
        --admin_user=${WP_ADMIN} \
        --admin_password=${WP_ADMIN_PASSWORD} \
        --admin_email=${WP_ADMIN_EMAIL}

fi

exec php-fpm83 -F