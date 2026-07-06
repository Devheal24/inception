ARG ALPINE_IMAGE=alpine:3.23

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache mariadb mariadb-client && \
    addgroup -S appuser && adduser -S appuser -G appuser

RUN mkdir -p /run/mysqld && chown -R appuser:appuser /run/mysqld && \
    mkdir -p /var/lib/mysql && chown -R appuser:appuser /var/lib/mysql

RUN sed -i '/skip-networking/d' /etc/my.cnf.d/*.cnf && \
    printf "[mysqld]\nport=3306\nbind-address=0.0.0.0\nskip-networking=0\n" \
    > /etc/my.cnf.d/network.cnf

COPY ./tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 3306

HEALTHCHECK --interval=5s --timeout=3s --retries=10 --start-period=30s \
    CMD mariadb-admin ping -h 127.0.0.1 -uroot -p"$(cat /run/secrets/db_root_password)" --silent || exit 1

USER appuser

ENTRYPOINT ["/setup.sh"]
