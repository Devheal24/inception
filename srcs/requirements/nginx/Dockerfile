ARG ALPINE_IMAGE

FROM ${ALPINE_IMAGE}

ARG DOMAIN_NAME=localhost

RUN apk add --no-cache nginx openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/CN=${DOMAIN_NAME}"

COPY ./conf/nginx.conf /etc/nginx/http.d/nginx.conf

RUN sed -i '/^user /d' /etc/nginx/nginx.conf

EXPOSE 443

RUN chown -R nginx:nginx /etc/nginx/ssl

USER nginx

CMD ["nginx", "-g", "daemon off;"]
