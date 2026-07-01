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

COPY ./conf/nginx.conf /etc/nginx/http.d/nginx.conf

EXPOSE 443

RUN addgroup -S appuser && adduser -S appuser -G appuser

RUN mkdir -p /var/lib/nginx/logs /var/log/nginx /run/nginx && \
    chown -R appuser:appuser /var/lib/nginx /var/log/nginx /run/nginx 

USER appuser

CMD ["nginx", "-g", "daemon off;"]
