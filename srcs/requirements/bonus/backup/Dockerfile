ARG ALPINE_IMAGE=alpine:3.23

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache mariadb-client

COPY ./tools/backup.sh /usr/local/bin/backup.sh

RUN chmod +x /usr/local/bin/backup.sh

COPY ./tools/crontab /etc/crontabs/root

CMD ["crond", "-f"]
