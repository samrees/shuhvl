FROM alpine:3

RUN  echo "@edge-main http://dl-cdn.alpinelinux.org/alpine/edge/main" >> /etc/apk/repositories \
  && echo "@edge-community http://dl-cdn.alpinelinux.org/alpine/edge/community" >> /etc/apk/repositories \
  && echo "@edge-testing http://dl-cdn.alpinelinux.org/alpine/edge/testing" >> /etc/apk/repositories \
  && apk add --update --no-cache \
    bash \
    ca-certificates \
    curl \
    ripgrep@edge-community \
    fd@edge-community \
    b3sum@edge-testing
