
## https://hub.docker.com/_/alpine/tags
FROM alpine:3.22.0

## https://pkgs.alpinelinux.org/packages?name=minidlna&branch=v3.22&repo=&arch=x86_64&origin=&flagged=&maintainer=
ENV minidlnaV="minidlna=~1.3.3-r1"

LABEL org.opencontainers.image.authors="rardcode <sak37564@ik.me>"
LABEL Description="Minidlna server based on Alpine."

ENV APP_NAME="minidlna"

RUN set -xe && \
  : "---------- ESSENTIAL packages INSTALLATION ----------" && \
  apk update --no-cache && \
  apk upgrade --available && \
  apk add bash

RUN set -xe && \
  : "---------- SPECIFIC packages INSTALLATION ----------" && \
  apk update --no-cache && \
  apk add --upgrade ${minidlnaV}

ADD rootfs /

# Check Process Within The Container Is Healthy
#HEALTHCHECK --interval=60s --timeout=5s CMD chronyc tracking > /dev/null

ENTRYPOINT ["/entrypoint.sh"]
#CMD ["/entrypoint.sh"]
#CMD ["chronyd","-d","-s" ]
