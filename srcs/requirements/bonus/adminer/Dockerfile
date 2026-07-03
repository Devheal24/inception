ARG ALPINE_IMAGE

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache \
	php83 \
	php83-cli \
	php83-mysqli \
	php83-session \
	php83-json \
	curl

RUN mkdir -p /var/www/html && \
	curl -o /var/www/html/adminer.php -L https://github.com/vrana/adminer/releases/download/v5.4.2/adminer-5.4.2.php && \
	chmod +x /var/www/html/adminer.php

EXPOSE 8080

HEALTHCHECK --interval=5s --timeout=3s --retries=10 --start-period=30s \
    CMD nc -z 127.0.0.1 8080 || exit 1

RUN addgroup -S appuser && adduser -S appuser -G appuser

USER appuser

ENTRYPOINT ["php83", "-S", "0.0.0.0:8080", "-t", "/var/www/html"]