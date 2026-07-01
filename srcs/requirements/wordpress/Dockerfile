ARG ALPINE_IMAGE

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache \
    php83 \
    php83-cli \
    php83-fpm \
    php83-mysqli \
    php83-json \
    php83-curl \
    php83-dom \
    php83-exif \
    php83-fileinfo \
    php83-mbstring \
    php83-openssl \
    php83-phar \
    php83-iconv \
    curl \
    mariadb-client

RUN ln -s /usr/bin/php83 /usr/bin/php

RUN mkdir -p /var/www/html

RUN sed -i 's/listen = 127.0.0.1:9000/listen = 9000/' /etc/php83/php-fpm.d/www.conf

RUN curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 9000

ENTRYPOINT ["/setup.sh"]