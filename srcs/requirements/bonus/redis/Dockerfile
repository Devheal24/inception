ARG ALPINE_IMAGE

FROM ${ALPINE_IMAGE}

RUN apk add --no-cache redis

HEALTHCHECK --interval=5s --timeout=3s --retries=10 --start-period=5s \
    CMD redis-cli ping | grep -q PONG || exit 1

USER redis

CMD ["redis-server", "--protected-mode", "no"]
