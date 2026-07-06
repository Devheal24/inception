ARG ALPINE_IMAGE=alpine:3.23

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache nginx

COPY ./conf/nginx.conf /etc/nginx/http.d/nginx.conf

RUN rm -f /etc/nginx/http.d/default.conf

RUN sed -i '/^user /d' /etc/nginx/nginx.conf

COPY ./html /var/www/html

EXPOSE 80

USER nginx

CMD ["nginx", "-g", "daemon off;"]
