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
    php83-tokenizer \
    php83-ctype \
    php83-pecl-redis \
    curl \
    mariadb-client

RUN ln -s /usr/bin/php83 /usr/bin/php && \
    addgroup -S appuser && adduser -S appuser -G appuser && \
    mkdir -p /var/www/html && chown -R appuser:appuser /var/www/html /var/log/php83 && \
    sed -i \
        -e 's/listen = 127.0.0.1:9000/listen = 9000/' \
        -e 's/^user = .*/user = appuser/' \
        -e 's/^group = .*/group = appuser/' \
        /etc/php83/php-fpm.d/www.conf && \
    curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar && \
    chmod +x wp-cli.phar && \
    mv wp-cli.phar /usr/local/bin/wp

WORKDIR /var/www/html

COPY ./tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 9000

HEALTHCHECK --interval=5s --timeout=3s --retries=10 --start-period=15s \
    CMD nc -z 127.0.0.1 9000 || exit 1

USER appuser

ENTRYPOINT ["/setup.sh"]