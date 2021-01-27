FROM golang:1.15-alpine as builder

RUN apk add git && \
    git clone https://github.com/restic/restic /go/src/github.com/restic/restic
WORKDIR /go/src/github.com/restic/restic
RUN go run build.go -v -o /usr/bin/restic


FROM ghcr.io/linuxserver/baseimage-alpine:3.12

# packages as variables
ARG BUILD_PACKAGES=""
ARG RUNTIME_PACKAGES="\
    fuse"

COPY --from=builder /usr/bin/restic /bin/restic

RUN \
 if [ -n "${BUILD_PACKAGES}" ]; then \
    echo "**** install build packages ****" && \
    apk add --no-cache \
        --virtual=build-dependencies \
        $BUILD_PACKAGES; \
 fi && \
 if [ -n "${RUNTIME_PACKAGES}" ]; then \
    echo "**** install runtime packages ****" && \
    apk add --no-cache \
        $RUNTIME_PACKAGES; \
 fi && \
 echo "**** cleanup ****" && \
 if [ -n "${BUILD_PACKAGES}" ]; then \
    apk del --purge \
        build-dependencies; \
 fi && \
 rm -rf \
    /root/.cache \
    /tmp/*

# copy local files
COPY root /

# docker mods
ENV DOCKER_MODS linuxserver/mods:universal-cron

# restic env variables
ENV RESTIC_REPOSITORY /data
ENV RESTIC_OPTIONAL_ARGS --verbose

VOLUME /config
