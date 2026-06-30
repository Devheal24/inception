ARG ALPINE_IMAGE

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache nginx openssl && \
    mkdir -p /etc/nginx/ssl && \
    openssl req -x509 \
    -nodes \
    -days 365 \
    -newkey rsa:2048 \
    -keyout /etc/nginx/ssl/server.key \
    -out /etc/nginx/ssl/server.crt \
    -subj "/CN=localhost"

COPY nginx.conf /etc/nginx/http.d/nginx.conf

EXPOSE 443

CMD ["nginx", "-g", "daemon off;"]
