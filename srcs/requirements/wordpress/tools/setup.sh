#!/bin/sh

cd /var/www/html

MYSQL_PASSWORD=$(cat /run/secrets/db_password)
WP_ADMIN_PASSWORD=$(cat /run/secrets/wp_admin_password)
WP_USER_PASSWORD=$(cat /run/secrets/wp_user_password)

if [ -z "$MYSQL_PASSWORD" ] || [ -z "$WP_ADMIN_PASSWORD" ] || [ -z "$WP_USER_PASSWORD" ]; then
    echo "setup.sh: db_password, wp_admin_password and wp_user_password secrets must not be empty" >&2
    exit 1
fi

if [ -z "$MYSQL_DATABASE" ] || [ -z "$MYSQL_USER" ] || [ -z "$DOMAIN_NAME" ] || \
   [ -z "$WP_TITLE" ] || [ -z "$WP_ADMIN" ] || [ -z "$WP_ADMIN_EMAIL" ] || \
   [ -z "$WP_USER" ] || [ -z "$WP_USER_EMAIL" ]; then
    echo "setup.sh: MYSQL_DATABASE, MYSQL_USER, DOMAIN_NAME, WP_TITLE, WP_ADMIN, WP_ADMIN_EMAIL, WP_USER and WP_USER_EMAIL must all be set (check .env)" >&2
    exit 1
fi

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

    wp user create \
        ${WP_USER} ${WP_USER_EMAIL} \
        --role=author \
        --user_pass=${WP_USER_PASSWORD}

fi

exec php-fpm83 -F