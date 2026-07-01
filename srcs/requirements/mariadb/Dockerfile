ARG ALPINE_IMAGE

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache mariadb mariadb-client

RUN mkdir -p /run/mysqld && \
    chown -R mysql:mysql /run/mysqld

RUN sed -i '/skip-networking/d' /etc/my.cnf.d/*.cnf && \
    printf "[mysqld]\nport=3306\nbind-address=0.0.0.0\nskip-networking=0\n" \
    > /etc/my.cnf.d/network.cnf

COPY ./tools/setup.sh /setup.sh

RUN chmod +x /setup.sh

EXPOSE 3306

ENTRYPOINT ["/setup.sh"]
